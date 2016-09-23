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

+(void)backToLastViewController {
    UIViewController *ctrl = [UIUtils getCurrentViewController];
    if([ctrl isKindOfClass: [UINavigationController class]]){
        //导航视图
        [(UINavigationController *)ctrl popViewControllerAnimated: YES];
    }else if(ctrl.presentingViewController){
        //模态视图
        [ctrl dismissViewControllerAnimated: YES completion: nil];
    }else if(([ctrl isKindOfClass: [UITabBarController class]])){
        //页签视图
        UINavigationController *navCtrl = (UINavigationController *)[(UITabBarController *)ctrl selectedViewController];
        [navCtrl popViewControllerAnimated: YES];
    }
    
}

+(UIAlertController *)showAlertWithTitle:(NSString *)title
                  message:(NSString *)message
                  actions:(NSArray<UIAlertAction *> *)actions
               textFields:(NSArray<UITextField *> *)textFields{
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle: title message: message preferredStyle: UIAlertControllerStyleAlert];
    for(UIAlertAction *action in actions){
        [alertCtrl addAction: action];
    }
    for(__weak UITextField *textField in textFields){
        [alertCtrl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull _textField) {
            _textField.text = textField.text;
            _textField.textColor = textField.textColor;
            _textField.leftView = textField.leftView;
            _textField.leftViewMode = textField.leftViewMode;
            _textField.placeholder = textField.placeholder;
        }];
    }
    [[UIUtils getCurrentViewController] presentViewController: alertCtrl animated:YES completion: nil];
    return alertCtrl;
}

@end
