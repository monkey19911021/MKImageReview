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
#import "MKUserPerference.h"
#import "MKPreviewingViewController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MKDocViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation MKDocViewController
{
    NSMutableArray<MKFileObject *> *domArray;
    
    NSString *filePath;
    
    MKAddPic *addPic;
    
    UIAlertController *createDirectoryAlertCtrl;
    
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
    
    if([MKUserPerference instance].isSecrectModel){
        __weak typeof(self) weakSelf = self;
        [[MKValidUtil new] validUserWithsuccess:^{
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf loadData];
            });
            
        } failure:^{
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"叫爸爸！" message:NULL preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertCtrl animated:YES completion:NULL];
        }];
    }else{
        [self loadData];
    }
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

#pragma mark - 添加图片或者新增文件夹
-(void)addPic {
    //在顶层只能创建文件夹
    if([filePath isEqualToString: HomeFilePath]) {
        [self createDirectory];
    }else {
        if(!addPic){
            addPic = [MKAddPic new];
        }
        addPic.imagePickerDelegate = self;
        [addPic addPic];
    }
}

-(void)createDirectory {
    if(createDirectoryAlertCtrl){
        [self presentViewController: createDirectoryAlertCtrl animated:YES completion:nil];
    }else{
        
        NSArray<UIAlertAction *> *createDirectoryActions;
        NSArray<UITextField *> *createDirectoryTextFields;
        
        //actions
        __weak typeof(self) weakSelf = self;
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler: ^(UIAlertAction * _Nonnull action) {
            
            NSString *name = createDirectoryAlertCtrl.textFields[0].text;
            if(name.length > 0){
                NSFileManager *fileMgr = [NSFileManager defaultManager];
                NSString *createdFielPath = [filePath stringByAppendingPathComponent: name];
                if(![fileMgr fileExistsAtPath: createdFielPath]){
                    [fileMgr createDirectoryAtPath: createdFielPath withIntermediateDirectories: YES attributes: nil error:nil];
                    [weakSelf loadData];
                }
            }
            
        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler: nil];
        createDirectoryActions = @[actionConfirm, actionCancel];
        
        //textFields
        UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 50, 22)];
        titleLabel.text = @"命名:";
        
        UITextField *textField = [[UITextField alloc] initWithFrame: CGRectZero];
        textField.placeholder = @"填写文件夹的名字";
        textField.leftView = titleLabel;
        textField.leftViewMode = UITextFieldViewModeAlways;
        
        createDirectoryTextFields = @[textField];
        
        createDirectoryAlertCtrl = [UIUtils showAlertWithTitle: @"填写创建的文件夹的名字" message: nil actions: createDirectoryActions textFields: createDirectoryTextFields];
    }
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
        MKFileObject *object = [[MKFileObject alloc] initWithFilePath: [NSString stringWithFormat:@"%@/%@", filePath, str]];
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
    
    cell.fileObject = domArray[indexPath.row];
    cell.indexPath = indexPath;
    if(!cell.previewingRegister){
        cell.previewingRegister = self;
    }
    
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
            MKPreviewingViewController *ctrl = [MKPreviewingViewController new];
            ctrl.fileObject = fileObject;
            [self.navigationController pushViewController: ctrl animated: YES];
            
        }
            break;
            
        default:
        {
            [UIUtils showAlertWithTitle: @"未支持打开该类型文件"
                                message: nil
                                actions: @[[UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleCancel handler: nil]] textFields: nil];
        }
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
