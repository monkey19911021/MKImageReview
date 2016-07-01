//
//  MKImagesReViewController.m
//  MKImageReview
//
//  Created by Liujh on 16/4/6.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "MKImagesReViewController.h"


const NSInteger ImageViewTag = 999;

const NSInteger ImageScrollViewFirstTag = 1000;
const NSInteger ImageScrollViewSecondTag = 1001;


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface MKImagesReViewController ()<UIScrollViewDelegate>

@end

@implementation MKImagesReViewController
{
    UIImageView *currentImageView;
    NSInteger currentIndex;
    
    NSArray<NSString *> *_imagesPathArray;
    
    void (^dismissPhotoSkimBlock)(NSInteger);
}

-(instancetype)init
{
    self = [super init];
    if(self){
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showImages:(NSArray<NSString *> *)imagesPathArray
            index:(NSInteger)index
afterDismissBlock:(void (^)(NSInteger))dismissBlock
{
    dismissPhotoSkimBlock = dismissBlock;
    _imagesPathArray = [NSArray arrayWithArray:imagesPathArray];
    
    for(int i=0; i<2; i++){
        UIScrollView *imageScrollView = [self.view viewWithTag:ImageScrollViewFirstTag+i];
        if(imageScrollView == nil){
            imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            imageScrollView.decelerationRate = 0;
            imageScrollView.delegate = self;
            imageScrollView.backgroundColor = [UIColor blackColor];
            imageScrollView.showsHorizontalScrollIndicator = NO;
            imageScrollView.showsVerticalScrollIndicator = NO;
            imageScrollView.tag = ImageScrollViewFirstTag + i;
            [self.view addSubview:imageScrollView];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageScrollView.bounds];
            imageView.tag = ImageViewTag;
            imageView.backgroundColor = [UIColor clearColor];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.userInteractionEnabled = YES;
            [imageScrollView addSubview:imageView];
            
            //单击消失
            UITapGestureRecognizer *dismissTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPhotoAlbum:)];
            dismissTapGesture.numberOfTapsRequired = 1;
            [imageView addGestureRecognizer:dismissTapGesture];
            
            //双击放大
            UITapGestureRecognizer *scaleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScaleImage:)];
            scaleTapGesture.numberOfTapsRequired = 2;
            [imageView addGestureRecognizer:scaleTapGesture];
            
            [dismissTapGesture requireGestureRecognizerToFail:scaleTapGesture];
            
            
            //左右横扫切换图片
            UISwipeGestureRecognizer *rightSwipeGestur = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(switchImage:)];
            rightSwipeGestur.direction = UISwipeGestureRecognizerDirectionRight;
            [imageView addGestureRecognizer:rightSwipeGestur];
            
            UISwipeGestureRecognizer *leftSwipeGestur = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(switchImage:)];
            leftSwipeGestur.direction = UISwipeGestureRecognizerDirectionLeft;
            [imageView addGestureRecognizer:leftSwipeGestur];
            
            //捏合缩放
            imageScrollView.maximumZoomScale = 2;
            [imageScrollView.pinchGestureRecognizer addTarget:self action:@selector(scaleImage:)];
            
            //拖拉切换
//            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panSwitchImage:)];
//            [imageView addGestureRecognizer:panGesture];
//            [panGesture requireGestureRecognizerToFail: rightSwipeGestur];
//            [panGesture requireGestureRecognizerToFail: leftSwipeGestur];
        }
    }
    
    if(currentImageView == nil){
        currentImageView = [[self.view viewWithTag:ImageScrollViewSecondTag] viewWithTag:ImageViewTag];
    }
    UIImage *image = nil;
    if(index < imagesPathArray.count){
        image = [UIImage imageWithContentsOfFile: imagesPathArray[index]];
    }
    currentIndex = index;
    currentImageView.image = image;
    
    [[self getCurrentViewController] presentViewController:self animated:YES completion:NULL];
}

#pragma mark - 消失图片
-(void)dismissPhotoAlbum:(UITapGestureRecognizer *)tapGesture
{
    if(tapGesture.numberOfTapsRequired == 1){
        [self dismissViewControllerAnimated:YES completion:^{
            if(dismissPhotoSkimBlock != nil){
                dismissPhotoSkimBlock(currentIndex);
            }
        }];
    }
}

#pragma mark - 放大缩小图片
-(void)tapScaleImage:(UITapGestureRecognizer *)tapGesture
{
    if(tapGesture.numberOfTapsRequired == 2){
        UIImageView *imageView = (UIImageView *)tapGesture.view;
        UIScrollView *contView = (UIScrollView *)imageView.superview;
        
        CGFloat imageWidth = imageView.frame.size.width;
        CGFloat imageHeight= imageView.frame.size.height;
        
        if(imageWidth == SCREEN_WIDTH){
            [UIView animateWithDuration:0.3 animations:^{
                imageView.frame = CGRectMake(0, 0, imageWidth*2, imageHeight*2);
                contView.contentOffset = CGPointMake(imageWidth/2, imageHeight/2);
            } completion:^(BOOL finished) {
                contView.contentSize = imageView.frame.size;
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                imageView.frame = (CGRect){CGPointZero, contView.bounds.size};
                contView.contentOffset = CGPointZero;
            } completion:^(BOOL finished) {
                contView.contentSize = contView.bounds.size;
            }];
        }
    }
}

#pragma mark - 捏合缩放图片
-(void)scaleImage:(UIPinchGestureRecognizer *)pinchGesture
{
    UIScrollView *contView = (UIScrollView *)pinchGesture.view;
    UIImageView *imageView = [contView viewWithTag:ImageViewTag];
    
    CGFloat scale = pinchGesture.scale;
    CGFloat imageWidth = imageView.bounds.size.width;
    CGFloat imageHeight= imageView.bounds.size.height;
    
    
    CGFloat contWidth = contView.bounds.size.width;
    CGFloat contHeight= contView.bounds.size.height;
    
    CGFloat scaleWidth = imageWidth * scale;
    CGFloat scaleHeight= imageHeight * scale;
    
    if(scaleWidth >= SCREEN_WIDTH && scaleWidth <= SCREEN_WIDTH*2){
        imageView.frame = CGRectMake(0, 0, scaleWidth, scaleHeight);
        contView.contentOffset = CGPointMake((scaleWidth-contWidth)/2.0f, (scaleHeight-contHeight)/2.0f);
        contView.contentSize = imageView.frame.size;
        pinchGesture.scale = 1;
    }
}

#pragma mark - 切换图片
-(void)switchImage:(UISwipeGestureRecognizer *)swipeGesture
{
    BOOL isRight = YES;
    if(swipeGesture.direction == UISwipeGestureRecognizerDirectionRight){
        isRight = YES;
    }else if(swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft){
        isRight = NO;
    }
    [self switchImageDirection:isRight];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat xOffset = scrollView.contentOffset.x;
    if(xOffset < -80.0){
        [self switchImageDirection:YES];
    }else if(xOffset > (scrollView.contentSize.width - SCREEN_WIDTH + 80)){
        [self switchImageDirection:NO];
    }
    
}

//#pragma mark - 拖拉切换图片
//-(void)panSwitchImage:(UIPanGestureRecognizer *)panGesture
//{
//    NSLog(@"%@", NSStringFromCGPoint([panGesture translationInView:panGesture.view]));
//}

-(void)switchImageDirection:(BOOL)isRight
{
    UIImageView *imageView = currentImageView;
    UIScrollView *contView = (UIScrollView *)imageView.superview;
    
    UIScrollView *nextContView = nil;
    UIImageView *nextImageView = nil;
    
    if(contView.tag == ImageScrollViewFirstTag){
        nextContView = [self.view viewWithTag:ImageScrollViewSecondTag];
    }else{
        nextContView = [self.view viewWithTag:ImageScrollViewFirstTag];
    }
    nextImageView = [nextContView viewWithTag:ImageViewTag];
    
    
    NSInteger change = 0;
    CGFloat xOffset = 0;
    if(isRight){
        //向右
        change = -1;
        currentIndex += change;
        if(currentIndex == -1){
            currentIndex = _imagesPathArray.count-1;
        }
        xOffset = contView.frame.size.width/2 * 3;
    }else{
        //向左
        change = 1;
        currentIndex += change;
        if(currentIndex == _imagesPathArray.count){
            currentIndex = 0;
        }
        xOffset = -contView.frame.size.width/2 * 3;
    }
    
    nextImageView.image = [UIImage imageWithContentsOfFile: _imagesPathArray[currentIndex]];
    
    if(xOffset != 0){
        
        [UIView animateWithDuration:0.3 animations:^{
            contView.center = CGPointMake(xOffset, contView.center.y);
            imageView.userInteractionEnabled = NO;
            nextImageView.userInteractionEnabled = NO;
        } completion:^(BOOL finished) {
            [self.view bringSubviewToFront:nextContView];
            //还原
            contView.center = nextContView.center;
            contView.contentOffset = CGPointZero;
            contView.contentSize = contView.bounds.size;
            imageView.frame = contView.bounds;
            imageView.userInteractionEnabled = YES;
            nextImageView.userInteractionEnabled = YES;
        }];
        
        currentImageView = nextImageView;
    }
}

-(UIViewController *)getCurrentViewController
{
    UIWindow *currentWindow = [[UIApplication sharedApplication] keyWindow];
    if (currentWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                currentWindow = tmpWin;
                break;
            }
        }
    }
    
    UIViewController *currentViewController = currentWindow.rootViewController;
    UIViewController *presentViewController = currentViewController.presentedViewController;
    if(presentViewController != nil){
        return presentViewController;
    }
    return currentViewController;
}

@end
