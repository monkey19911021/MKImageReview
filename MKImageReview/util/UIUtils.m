//
//  UIUtils.m
//  MKImageReview
//
//  Created by Liujh on 16/4/6.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "UIUtils.h"

@implementation UIUtils

+(UIWindow *)getCurrentWindow
{
    UIWindow *currentWindow = [[UIApplication sharedApplication] keyWindow];
    if (currentWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                currentWindow = tmpWin;
                break;
            }
        }
    }
    
    return currentWindow;
}

+(UIViewController *)getCurrentViewController
{
    
    UIViewController *currentViewController = [UIUtils getCurrentWindow].rootViewController;
    UIViewController *presentViewController = currentViewController.presentedViewController;
    if(presentViewController != nil){
        return presentViewController;
    }
    return currentViewController;
}

@end
