//
//  MKPreviewingViewController.h
//  MKImageReview
//
//  Created by DONLINKS on 16/9/26.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKFileObject.h"

@protocol MKPreviewingViewDelegate <NSObject>

-(void)fileDidDeleteAtPath:(NSString *)filePath;

@end

@interface MKPreviewingViewController : UIViewController

@property(weak, nonatomic) MKFileObject *fileObject;

@property(weak, nonatomic) id<MKPreviewingViewDelegate> delegate;

@end
