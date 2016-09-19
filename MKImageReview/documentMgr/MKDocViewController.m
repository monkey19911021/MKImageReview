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

@interface MKDocViewController ()

@end

@implementation MKDocViewController
{
    NSMutableArray<MKFileObject *> *domArray;
    
    NSString *filePath;
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
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[MKCollectionViewCell class]
                forCellWithReuseIdentifier: reuseIdentifier];
    
    __weak typeof(self) weakSelf = self;
    [[MKValidUtil new] validUserWithsuccess:^{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf loadData];
        });
        
    } failure:^{
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"叫爸爸！" message:NULL preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertCtrl animated:YES completion:NULL];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(65, 80);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
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
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath: indexPath animated: YES];
    
    //    MKCollectionViewCell *cell = [contCollectionView cellForItemAtIndexPath:indexPath];
    
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

@end
