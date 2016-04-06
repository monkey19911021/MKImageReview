//
//  MKValidUtil.m
//  MKImageReview
//
//  Created by Liujh on 16/3/11.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "MKValidUtil.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation MKValidUtil

-(void)validUserWithsuccess:(void (^)()) successBlock failure:(void (^)()) failureBlock
{
    LAContext *contenxt = [[LAContext alloc] init];
    NSError *valiableError;
    //检查指纹验证是否可用
    BOOL isValiable = [contenxt canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error: &valiableError];
    if(isValiable){
        //获取指纹验证结果
        [contenxt evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"伸出你的手指" reply:^(BOOL success, NSError * _Nullable error) {
            if(success){
                successBlock();
            }else{
                failureBlock();
            }
        }];
        
    }else{
        failureBlock();
    }
}

@end
