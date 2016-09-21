//
//  MKDocViewController.m
//  MKImageReview
//
//  Created by DONLINKS on 16/9/19.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "MKDocViewController.h"
#import "MKValidUtil.h"
#import "MKCollectionViewCell.h"
#import "Utils.h"
#import "MKFileObject.h"
#import "MKImagesReViewController.h"
#import "MKAddPic.h"
#import "UIUtils.h"
#import "UIImageView+MKImageView.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MKDocViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end


typedef void(^VoidBlock)();
@implementation MKDocViewController
{
    NSMutableArray<MKFileObject *> *domArray;
    
    NSString *filePath;
    
    
    UIImagePickerController *imagePickerCtrl;
    UIImagePickerControllerSourceType imageSourceType;
}
static NSString * const reuseIdentifier = @"DocCell";
static NSString * const BackString = @"返回";

-(instancetype)init {
    if(self = [super initWithCollectionViewLayout: [self collectionViewFlowLayout]]){
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    domArray = [NSMutableArray new];
    filePath = HomeFilePath;
    [self setNavItem];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[MKCollectionViewCell class]
                forCellWithReuseIdentifier: reuseIdentifier];
    
    __weak typeof(self) weakSelf = self;
//    [[MKValidUtil new] validUserWithsuccess:^{
//        
//        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf loadData];
//        });
//
//    } failure:^{
//        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"叫爸爸！" message:NULL preferredStyle:UIAlertControllerStyleAlert];
//        [self presentViewController:alertCtrl animated:YES completion:NULL];
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setNavItem {
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [addBtn setImage: [UIImage imageNamed: @"add"] forState: UIControlStateNormal];
    [addBtn addTarget: self action: @selector(addPic) forControlEvents: UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem: [[UIBarButtonItem alloc] initWithCustomView: addBtn]];
}

-(void)addPic {
    MKAddPic *addPic = [MKAddPic new];
    addPic.imagePickerDelegate = self;
    [addPic addPicToPath: filePath];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [imageData writeToFile: [filePath stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.jpg", @([[NSDate date] timeIntervalSince1970])]] atomically: YES];
        [self loadData];
        
    }else{
        //相册来源的图片使用 Photos 库写入文件
        NSURL *picURL = [info objectForKey: UIImagePickerControllerReferenceURL];
        
        //获取资源
        PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsWithALAssetURLs:@[picURL] options:nil];
        PHAsset *asset = [result firstObject];
        NSArray<PHAssetResource *> *resourceArray = [PHAssetResource assetResourcesForAsset: asset];
        PHAssetResource *res = [resourceArray firstObject];
        
        //写入数据设置
        PHAssetResourceRequestOptions *resOptions = [PHAssetResourceRequestOptions new];
        resOptions.networkAccessAllowed = NO;
        resOptions.progressHandler = ^(double progress){
            NSLog(@"%@", @(progress));
        };
        
        //写入文件
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:res
                                                                    toFile:[NSURL fileURLWithPath:[filePath stringByAppendingPathComponent: res.originalFilename] isDirectory:NO]
                                                                   options: resOptions
                                                         completionHandler:^(NSError * _Nullable error)
         {
             [self loadData];
         }];
    }
    [picker dismissViewControllerAnimated:YES completion: nil];
}


- (UICollectionViewFlowLayout *)collectionViewFlowLayout{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat widthToHeight = 13.0 / 16.0;
    CGFloat width = SCREENWIDTH / 4.0 - 12;
    CGFloat height = width / widthToHeight;
    flowLayout.itemSize = CGSizeMake(width, height);
    
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    return flowLayout;
}

- (void)loadData{
    [domArray removeAllObjects];
    
    //返回
    if(![filePath isEqualToString: HomeFilePath]){
        MKFileObject *object = [MKFileObject new];
        object.name = BackString;
        object.image = [UIImage imageNamed: @"icon_back"];
        object.fileType = MKFileTypeDirectory;
        [domArray addObject: object];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray<NSString *> *subPathsArray = [fileManager contentsOfDirectoryAtPath: filePath
                                                                          error: NULL];
    for(NSString *str in subPathsArray){
        MKFileObject *object = [MKFileObject new];
        object.name = str;
        object.filePath = [NSString stringWithFormat:@"%@/%@", filePath, str];
        NSString *path = object.filePath;
        BOOL isDirectory = true;
        [fileManager fileExistsAtPath:path isDirectory: &isDirectory];
        object.image = [UIImage imageNamed: @"fielIcon"];
        
        if(isDirectory){
            object.image = [UIImage imageNamed: @"dirIcon"];
            object.fileType = MKFileTypeDirectory;
        }else{
            if([IMAGES_TYPES containsObject: [path pathExtension]]){
                object.image = [UIImage imageWithContentsOfFile: path];
                object.objcData = [NSData dataWithContentsOfFile: path];
                object.fileType = MKFileTypeImage;
            }
        }
        
        [domArray addObject: object];
    }
    [self.collectionView reloadData];
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return domArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = reuseIdentifier;
    MKCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                           forIndexPath:indexPath];
    
    //设置高亮背景
    CGRect bgViewFrame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    UIColor *bgViewColor = [UIColor colorWithRed:68/255.0f green:179/255.0f blue:236/255.0f alpha:0.5];
    UIView *backgroundView = [[UIView alloc] initWithFrame: bgViewFrame];
    backgroundView.backgroundColor = bgViewColor;
    [backgroundView.layer setCornerRadius:5];
    [cell setSelectedBackgroundView:backgroundView];
    
    MKFileObject *fileObject = [domArray objectAtIndex: indexPath.row];
    cell.titleLabel.text = fileObject.name;
    cell.imageView.image = fileObject.image;
    cell.imageView.imageData = fileObject.objcData;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath: indexPath animated: YES];
    
//    MKCollectionViewCell *cell = (MKCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    MKFileObject *fileObject = [domArray objectAtIndex: indexPath.row];
    
    switch (fileObject.fileType) {
            
        case MKFileTypeDirectory:
        {
            NSString *fileName = fileObject.name;
            if([fileName isEqualToString:BackString]){
                filePath = [filePath stringByDeletingLastPathComponent];
            }else{
                filePath = [NSString stringWithFormat: @"%@/%@", filePath, fileObject.name];
            }
            [self loadData];
        }
            break;
            
        case MKFileTypeImage:
        {
            NSArray<NSString *> *filePaths = [fileObject getDirectoryFiles];
            [[MKImagesReViewController new] showImages:filePaths
                                                 index:indexPath.row-1
                                     afterDismissBlock:^(NSInteger index) {
                                         [self startAnimat:collectionView withIndexPath:indexPath];
                                         __block NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:index
                                                                                                   inSection:indexPath.section];
                                         [self.collectionView scrollToItemAtIndexPath:targetIndexPath
                                                                    atScrollPosition:UICollectionViewScrollPositionTop
                                                                            animated:YES];
                                     }];
        }
            break;
            
        case MKFileTypeTxt:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self startAnimat:collectionView withIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self startAnimat:collectionView withIndexPath:indexPath];
}

-(void)startAnimat:(UICollectionView *)collectionView withIndexPath:(NSIndexPath *)indexPath {
    MKCollectionViewCell *cell = (MKCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    MKFileObject *fileObject = [domArray objectAtIndex: indexPath.row];
    if(fileObject.fileType == MKFileTypeImage){
        if(cell.imageView.animationImages.count > 0){
            [cell.imageView startAnimating];
        }
    }
}

@end
