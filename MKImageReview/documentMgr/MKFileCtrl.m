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

-(void)deleteItemAtPath:(NSString *)filePath complateHandler:(void (^)(NSError *))handler {
    if([[MKUserPerference instance] isAskBeforeDelete]) {
        
        __weak typeof(self) weakSelf = self;
        UIAlertAction *confirm = [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf removeItemAtPath: filePath withErrorHandler: handler];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler: nil];
        
        [UIUtils showAlertWithTitle: @"是否删除该文件" message: @"删除后不可恢复" actions: @[confirm, cancel] textFields: nil];
        
    } else {
        [self removeItemAtPath: filePath withErrorHandler: handler];
    }
}

-(void)removeItemAtPath:(NSString *)filePath withErrorHandler:(void (^)(NSError *))handler{
    NSError *error = [NSError new];
    [fileMgr removeItemAtPath: filePath error: &error];
    if(handler){
        handler(error);
    }
}

@end
