//
//  MKPreviewingViewController.m
//  MKImageReview
//
//  Created by DONLINKS on 16/9/26.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "MKPreviewingViewController.h"
#import "UIImageView+MKImageView.h"
#import "Utils.h"
#import "MKFileCtrl.h"

@interface MKPreviewingViewController ()

@end

@implementation MKPreviewingViewController
{
    UIImageView *previewImageView;
    
    UIWebView *webView;
    
    __weak IBOutlet UIView *directoryInfoView;
    
    __weak IBOutlet UILabel *diectoryNameLabel;
    __weak IBOutlet UILabel *diectorySizeLabel;
    __weak IBOutlet UILabel *diectorySubsCountLabel;
    __weak IBOutlet UILabel *diectoryCreateLabel;
    __weak IBOutlet UILabel *diectoryModifiedLabel;
    
    __block MKFileCtrl *fileCtrl;
}

-(instancetype)init {
    if(self = [super init]) {
        
        previewImageView = [UIImageView new];
        previewImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        webView = [UIWebView new];
        webView.scalesPageToFit = YES;
        
        directoryInfoView = [[UINib nibWithNibName: @"MKDirectoryPerviewView" bundle: nil] instantiateWithOwner: self options: nil][0];
        
        fileCtrl = [MKFileCtrl new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    previewImageView.frame = self.view.bounds;
    webView.frame = self.view.bounds;
    directoryInfoView.frame = (CGRect){CGPointZero, directoryInfoView.frame.size};
}

-(void)setFileObject:(MKFileObject *)fileObject {
    _fileObject = fileObject;
    switch (_fileObject.fileType) {
        case MKFileTypeTxt:
        {
            [self.view addSubview: webView];
            [webView loadRequest: [NSURLRequest requestWithURL: [NSURL fileURLWithPath: _fileObject.filePath]]];
        }
            break;
            
        case MKFileTypeImage:
        {
            //图片进行预览
            previewImageView.imageData = [NSData dataWithContentsOfFile: fileObject.filePath];
            [self.view addSubview: previewImageView];
            
            CGSize imageSize = CGSizeZero;
            if(previewImageView.image) {
                imageSize = previewImageView.image.size;
            } else {
                imageSize = previewImageView.animationImages[0].size;
            }
            
            //改变 viewCtrl 的尺寸
            CGFloat width = SCREENWIDTH - 8.0*2.0;
            self.preferredContentSize = CGSizeMake(width, width * imageSize.height / imageSize.width);
        }
            break;
            
        case MKFileTypeUnknown:
        case MKFileTypeDirectory:
        {
            [self.view addSubview: directoryInfoView];
            self.view.backgroundColor = [UIColor whiteColor];
            self.preferredContentSize = CGSizeMake(SCREENWIDTH, directoryInfoView.frame.size.height);
            
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSDictionary<NSString *, id> *fileInfo = [fileMgr attributesOfItemAtPath: fileObject.filePath error:nil];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            dateFormat.dateFormat = @"yyyy年MM月dd日 EEEE HH:mm";
            
            diectoryNameLabel.text = fileObject.name;
            diectorySizeLabel.text = [NSString stringWithFormat: @"%.2fM", [self getFileSize: fileObject.filePath]/1024.0f/1024.0f];
            diectorySubsCountLabel.text = [NSString stringWithFormat:@"%@项", @([fileMgr subpathsAtPath: fileObject.filePath].count)];
            diectoryCreateLabel.text = [dateFormat stringFromDate: fileInfo[NSFileCreationDate]];
            diectoryModifiedLabel.text = [dateFormat stringFromDate: fileInfo[NSFileModificationDate]];
        }
            break;
            
        default:
            break;
    }
}

-(CGFloat)getFileSize:(NSString *)filePath {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    CGFloat size = 0;
    for(NSString *subPath in [fileMgr subpathsAtPath: filePath]){
        BOOL isDirectory = NO;
        [fileMgr fileExistsAtPath:subPath isDirectory: &isDirectory];
        NSString *path = [filePath stringByAppendingPathComponent: subPath];
        if(isDirectory){
            size += [self getFileSize: path];
        }else {
            NSDictionary<NSString *, id> *fileInfo = [fileMgr attributesOfItemAtPath: path error:nil];
            size += [fileInfo[NSFileSize] doubleValue];
        }
    }
    return size;
}


//预览视图的操作
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    __weak typeof(self) weakSelf = self;
    
    UIPreviewAction *actionCopy = [UIPreviewAction actionWithTitle:@"复制到..." style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Action 1 selected");
    }];
    
    UIPreviewAction *actionMove = [UIPreviewAction actionWithTitle:@"移动到..." style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Action 2 selected");
    }];
    
    UIPreviewAction *actionDelete = [UIPreviewAction actionWithTitle:@"删除" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        [fileCtrl deleteItemAtPath: _fileObject.filePath complateHandler:^(NSError *error) {
            [weakSelf.delegate fileDidDeleteAtPath: _fileObject.filePath];
        }];
    }];
    
    UIPreviewAction *actionShare = [UIPreviewAction actionWithTitle:@"分享" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    
    NSMutableArray *actions = @[actionCopy, actionMove, actionDelete, actionShare].mutableCopy;
    
    if(_fileObject.fileType != MKFileTypeDirectory){
        UIPreviewAction *actionDetail = [UIPreviewAction actionWithTitle:@"详细信息" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
            NSLog(@"tap 1 selected");
        }];
        [actions insertObject:actionDetail atIndex:3];
    }
    
    return actions;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
