//
//  UIUtils.h
//  MKImageReview
//
//  Created by Liujh on 16/4/6.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIUtils : NSObject

/**
 *  获取当前视窗
 *
 *  @return window
 */
+(UIWindow *)getCurrentWindow;

/**
 *  获取当前根视图控制器
 *
 *  @return UIViewController
 */
+(UIViewController *)getCurrentViewController;


/**
 返回上一视图控制器
 */
+(void)backToLastViewController;

+(UIAlertController *)showAlertWithTitle:(NSString *)title
                  message:(NSString *)message
                  actions:(NSArray<UIAlertAction *> *)actions
               textFields:(NSArray<UITextField *> *)textFields;

@end
