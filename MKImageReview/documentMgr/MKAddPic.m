//
//  MKAddPic.m
//  MKImageReview
//
//  Created by DONLINKS on 16/9/19.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "MKAddPic.h"
#import "UIUtils.h"
#import <UIKit/UIKit.h>

@interface MKAddPic()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

typedef void(^VoidBlock)();
@implementation MKAddPic
{
    UIImagePickerController *imagePickerCtrl;
    UIImagePickerControllerSourceType imageSourceType;
    
    NSString *_filePath;
    VoidBlock _successBlock;
}

-(instancetype)init {
    if(self = [super init]){
        imagePickerCtrl = [[UIImagePickerController alloc] init];
        imagePickerCtrl.delegate = self;
    }
    return self;
}

-(void)addPicToPath:(NSString *)filePath successBlock:(void (^)())successBlock{
    _filePath = filePath;
    _successBlock = successBlock;
    
    UIAlertController *choseAlert = [UIAlertController alertControllerWithTitle: @"选择照片来源" message: nil preferredStyle: UIAlertControllerStyleActionSheet];
    [choseAlert addAction: [UIAlertAction actionWithTitle: @"相机" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imageSourceType = UIImagePickerControllerSourceTypeCamera;
        [self showPhotoPicker];
    }]];
    [choseAlert addAction: [UIAlertAction actionWithTitle: @"相册" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imageSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self showPhotoPicker];
    }]];
    [choseAlert addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler: nil]];
    [[UIUtils getCurrentViewController] presentViewController: choseAlert animated: YES completion:nil];
}

-(void)showPhotoPicker {
    if (![UIImagePickerController isSourceTypeAvailable: imageSourceType]) {
        return;
    }
    
    imagePickerCtrl.sourceType = imageSourceType;
    [[UIUtils getCurrentViewController] presentViewController: imagePickerCtrl animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(image != nil){
        NSLog(@"%@", info);
    }
//    NSFileManager *mgr = [NSFileManager defaultManager];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if(_successBlock){
            _successBlock();
        }
    }];
}

@end
