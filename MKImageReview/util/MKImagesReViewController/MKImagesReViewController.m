//
//  MKImagesReViewController.m
//  MKImageReview
//
//  Created by Liujh on 16/4/6.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "MKImagesReViewController.h"
#import "JT3DScrollView.h"
#import "Utils.h"
#import "UIUtils.h"


@interface MKImagesReViewController ()

@end

@implementation MKImagesReViewController
{
    JT3DScrollView *photoPreviewScrollView;
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
    if(photoPreviewScrollView == nil){
        photoPreviewScrollView = [[JT3DScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        photoPreviewScrollView.effect = JT3DScrollViewEffectDepth;
        photoPreviewScrollView.backgroundColor = [UIColor blackColor];
        photoPreviewScrollView.delegate = self;
    }
    
    photoPreviewScrollView.contentSize = CGSizeMake(SCREENWIDTH*imagesPathArray.count, SCREENHEIGHT);
    dismissPhotoSkimBlock = dismissBlock;
    
    for(int i=0; i<imagesPathArray.count; i++){
        UIImageView *imageView = (UIImageView *)[photoPreviewScrollView viewWithTag:1000+i];
        if(imageView == nil){
            UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(i*SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT)];
            imageScrollView.decelerationRate = 0;
            imageScrollView.showsHorizontalScrollIndicator = NO;
            imageScrollView.showsVerticalScrollIndicator = NO;
            [photoPreviewScrollView addSubview:imageScrollView];
            
            imageView = [[UIImageView alloc] initWithFrame:imageScrollView.bounds];
            imageView.tag = 1000 + i;
            imageView.backgroundColor = [UIColor clearColor];
            imageView.image = [UIImage imageWithContentsOfFile: imagesPathArray[i]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *dismissTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPhotoAlbum:)];
            dismissTapGesture.numberOfTapsRequired = 1;
            [imageView addGestureRecognizer:dismissTapGesture];
            
            UITapGestureRecognizer *scaleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
            scaleTapGesture.numberOfTapsRequired = 2;
            [imageView addGestureRecognizer:scaleTapGesture];
            
            [dismissTapGesture requireGestureRecognizerToFail:scaleTapGesture];
            [imageScrollView addSubview:imageView];
            
        }
    }
    
    photoPreviewScrollView.contentOffset = CGPointMake(index*photoPreviewScrollView.frame.size.width, photoPreviewScrollView.contentOffset.y);
    [self.view addSubview:photoPreviewScrollView];
    
    [[UIUtils getCurrentViewController] presentViewController:self animated:YES completion:NULL];
}


-(void)dismissPhotoAlbum:(UITapGestureRecognizer *)tapGesture
{
    if(tapGesture.numberOfTapsRequired == 1){
        NSInteger index = photoPreviewScrollView.contentOffset.x/photoPreviewScrollView.frame.size.width;
        
        [self dismissViewControllerAnimated:YES completion:^{
            if(dismissPhotoSkimBlock != nil){
                dismissPhotoSkimBlock(index);
            }
        }];
    }
}

#pragma mark - 放大缩小图片
-(void)scaleImage:(UITapGestureRecognizer *)tapGesture
{
    if(tapGesture.numberOfTapsRequired == 2){
        UIImageView *imageView = (UIImageView *)tapGesture.view;
        UIScrollView *contView = (UIScrollView *)imageView.superview;
        
        if(imageView.frame.size.width == SCREENWIDTH){
            [UIView animateWithDuration:0.3 animations:^{
                imageView.frame = CGRectMake(0, 0, imageView.frame.size.width*2, imageView.frame.size.height*2);
                contView.contentOffset = CGPointMake(imageView.frame.size.width/4.0f, imageView.frame.size.height/4.0f);
            } completion:^(BOOL finished) {
                contView.contentSize = imageView.frame.size;
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                imageView.frame = CGRectMake(0, 0, imageView.frame.size.width/2, imageView.frame.size.height/2);
                contView.contentOffset = CGPointZero;
            } completion:^(BOOL finished) {
                contView.contentSize = imageView.frame.size;
            }];
        }
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([scrollView isEqual:photoPreviewScrollView]){
        for(UIScrollView *contView in [scrollView subviews]){
            if([contView isKindOfClass:[UIScrollView class]] && contView.contentSize.width > SCREENWIDTH){
                
                for(UIImageView *imageView in [contView subviews]){
                    if([imageView isKindOfClass:[UIImageView class]] && imageView.tag >= 1000){
                        [UIView animateWithDuration:0.3 animations:^{
                            imageView.frame = CGRectMake(0, 0, imageView.frame.size.width/2, imageView.frame.size.height/2);
                            contView.contentOffset = CGPointZero;
                        } completion:^(BOOL finished) {
                            contView.contentSize = imageView.frame.size;
                        }];
                        break;
                    }
                }
                break;
                
            }
        }
    }
}

@end
