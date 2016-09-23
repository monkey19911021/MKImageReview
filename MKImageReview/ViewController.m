//
//  ViewController.m
//  MKImageReview
//
//  Created by Liujh on 16/3/11.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "ViewController.h"
#import "MKDocViewController.h"
#import "MKUserPerferenceTableViewController.h"
#import "Utils.h"
#import "MKAddPic.h"

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
}

-(void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(snapshoot) name: SnapshootNotification object: nil];
}

- (IBAction)goSandBox:(id)sender {
    [self.navigationController pushViewController: [MKDocViewController new] animated: YES];
}

- (IBAction)config:(id)sender {
    UIViewController *ctrl = [[UIStoryboard storyboardWithName: NSStringFromClass([MKUserPerferenceTableViewController class]) bundle: nil] instantiateInitialViewController];
    [self.navigationController pushViewController: ctrl animated: YES];
}

-(void)snapshoot {
    MKAddPic *addPic = [MKAddPic new];
    addPic.imagePickerDelegate = self;
    [addPic snapshoot];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        NSString *filePath = [HomeFilePath stringByAppendingPathComponent: @"默认相册"];
        NSFileManager *mgr = [NSFileManager defaultManager];
        if(![mgr fileExistsAtPath:filePath]){
            [mgr createDirectoryAtPath: filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        [imageData writeToFile: [filePath stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.jpg", @([[NSDate date] timeIntervalSince1970])]] atomically: YES];
    }
    
    [picker dismissViewControllerAnimated:YES completion: nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
