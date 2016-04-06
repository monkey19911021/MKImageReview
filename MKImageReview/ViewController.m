//
//  ViewController.m
//  MKImageReview
//
//  Created by Liujh on 16/3/11.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "ViewController.h"
#import "MKValidUtil.h"
#import "MKCollectionViewCell.h"
#import "Utils.h"
#import "MKFileObject.h"

#define ContCollectionViewCellIdentifier @"cellIde"

#define BackString @"返回"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation ViewController
{
    __weak IBOutlet UICollectionView *contCollectionView;
    NSMutableArray<MKFileObject *> *domArray;
    __weak IBOutlet UITextField *filePathTextField;
    
    NSString *filePath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    domArray = [NSMutableArray new];
    filePath = HomeFilePath;
    
    [contCollectionView setCollectionViewLayout: [self collectionViewFlowLayout]];
    [contCollectionView registerClass:[MKCollectionViewCell class] forCellWithReuseIdentifier: ContCollectionViewCellIdentifier];
    
//    [[MKValidUtil new] validUserWithsuccess:^{
    
        [self loadData];
        
//    } failure:^{
//        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"叫爸爸！" message:NULL preferredStyle:UIAlertControllerStyleAlert];
//        [self presentViewController:alertCtrl animated:YES completion:NULL];
//    }];
    
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
        [domArray addObject: object];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray<NSString *> *subPathsArray = [fileManager contentsOfDirectoryAtPath: filePath error: NULL];
    for(NSString *str in subPathsArray){
        NSString *path = [NSString stringWithFormat:@"%@/%@", filePath, str];
        BOOL isDirectory = true;
        [fileManager fileExistsAtPath:path isDirectory: &isDirectory];
        UIImage *image = [UIImage imageNamed: @"fielIcon"];
        if(isDirectory){
            image = [UIImage imageNamed: @"dirIcon"];
        }else{
            if([[path pathExtension] isEqualToString:@"jpg"] || [[path pathExtension] isEqualToString:@"png"]){
                image = [UIImage imageWithContentsOfFile: path];
            }
        }
        
        MKFileObject *object = [MKFileObject new];
        object.name = str;
        object.image = image;
        [domArray addObject: object];
    }
    filePathTextField.text = filePath;
    [contCollectionView reloadData];
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return domArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = ContCollectionViewCellIdentifier;
    MKCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    //设置高亮背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    backgroundView.backgroundColor = [UIColor colorWithRed:68/255.0f green:179/255.0f blue:236/255.0f alpha:0.5];
    [backgroundView.layer setCornerRadius:5];
    [cell setSelectedBackgroundView:backgroundView];
    
    MKFileObject *fileObject = [domArray objectAtIndex: indexPath.row];
    cell.titleLabel.text = fileObject.name;
    cell.imageView.image = fileObject.image;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath: indexPath animated: YES];
    
    MKFileObject *fileObject = [domArray objectAtIndex: indexPath.row];
    NSString *fileName = fileObject.name;
    if([fileName isEqualToString:BackString]){
        NSArray<NSString *> *filePathArray = [filePath componentsSeparatedByString: @"/"];
        NSMutableString *tempFilePath = [NSMutableString new];
        for(int i=0; i<filePathArray.count-1; i++){
            [tempFilePath appendFormat: @"/%@", filePathArray[i]];
        }
        filePath = [NSString stringWithString: tempFilePath];
    }else{
        filePath = [NSString stringWithFormat: @"%@/%@", filePath, fileObject.name];
    }
    
    
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)injected{
    [self loadData];
}

@end
