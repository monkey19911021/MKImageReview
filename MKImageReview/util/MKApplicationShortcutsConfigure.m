//
//  MKApplicationShortcutsConfigure.m
//  MKImageReview
//
//  Created by DONLINKS on 16/9/23.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "MKApplicationShortcutsConfigure.h"
#import <UIKit/UIKit.h>

@implementation MKApplicationShortcutsConfigure

+(void)configure {
    
    //创建shortIcon
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName: @"config"]; //如果使用自定义的图片，则系统的图标就不生效
//    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType: UIApplicationShortcutIconType];
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType: @"cn.mkapple.album" localizedTitle: @"打开相册" localizedSubtitle: nil icon:icon1 userInfo:@{@"scheme":@"mkapple://album"}];
    [UIApplication sharedApplication].shortcutItems = @[item1];
}

@end
