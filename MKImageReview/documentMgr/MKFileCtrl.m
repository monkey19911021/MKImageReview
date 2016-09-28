//
//  MKFileCtrl.m
//  MKImageReview
//
//  Created by DONLINKS on 16/9/28.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "MKFileCtrl.h"
#import "MKUserPerference.h"
#import "UIUtils.h"

@implementation MKFileCtrl
{
    NSFileManager *fileMgr;
}

-(instancetype)init {
    if(self = [super init]){
        fileMgr = [NSFileManager defaultManager];
    }
    return self;
}

-(void)deleteItemAtPaths:(NSArray<NSString *> *)filePaths complateHandler:(void (^)(NSError *))handler {
    if([[MKUserPerference instance] isAskBeforeDelete]) {
        
        __weak typeof(self) weakSelf = self;
        UIAlertAction *confirm = [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf removeItemAtPath: filePaths withErrorHandler: handler];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler: nil];
        
        [UIUtils showAlertWithTitle: @"是否删除该文件" message: @"删除后不可恢复" actions: @[confirm, cancel] textFields: nil];
        
    } else {
        [self removeItemAtPath: filePaths withErrorHandler: handler];
    }
}

-(void)removeItemAtPath:(NSArray<NSString *> *)filePaths withErrorHandler:(void (^)(NSError *))handler{
    for(NSString *path in filePaths){
        if([fileMgr fileExistsAtPath: path]){
            NSError *error = [NSError new];
            [fileMgr removeItemAtPath: path error: &error];
        }
    }
   
    if(handler){
        handler(nil);
    }
}

-(void)shareItemAtPaths:(NSArray<NSString *> *)filePaths complateHandler:(void (^)(NSError *))handler {
    NSMutableArray *items = @[].mutableCopy;
    
    
    
    UIActivityViewController *ctrl = [[UIActivityViewController alloc] initWithActivityItems: items applicationActivities:nil];
    ctrl.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError){
        if(!completed && handler){
            handler(activityError);
        }
    };
    [[UIUtils getCurrentViewController] presentViewController:ctrl animated:YES completion:nil];
}

@end
