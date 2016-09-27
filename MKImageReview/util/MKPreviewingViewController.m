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

@interface MKPreviewingViewController ()

@end

@implementation MKPreviewingViewController
{
    UIImageView *previewImageView;
    
    UIWebView *webView;
}

-(instancetype)init {
    if(self = [super init]) {
        
        previewImageView = [UIImageView new];
        previewImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        webView = [UIWebView new];
        webView.scalesPageToFit = YES;
        
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
            
        case MKFileTypeDirectory:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
