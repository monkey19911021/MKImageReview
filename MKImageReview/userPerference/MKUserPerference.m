//
//  MKUserPerference.m
//  MKImageReview
//
//  Created by DONLINKS on 16/9/23.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "MKUserPerference.h"
#import "MKValidUtil.h"
#import "UIUtils.h"

NSString *const SecretModelKey = @"SecretModelKey";
@implementation MKUserPerference
{
    __weak NSUserDefaults *userDefaults;
}

-(instancetype)init {
    if(self = [super init]){
        userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

-(void)setIsSecrectModel:(BOOL)isSecrectModel {
    if(!isSecrectModel){
        
        [[MKValidUtil new] validUserWithsuccess:^{
            
            
            [userDefaults setObject: @(NO) forKey: SecretModelKey];
            [userDefaults synchronize];
            
        } failure:^{
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"关闭隐私模式失败" message: @"将返回上一层页面" preferredStyle:UIAlertControllerStyleAlert];
            [alertCtrl addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [UIUtils backToLastViewController];
            }]];
            
            [[UIUtils getCurrentViewController] presentViewController:alertCtrl animated:YES completion: nil];
        }];
        
    }else{
        [userDefaults setObject: @(YES) forKey: SecretModelKey];
        [userDefaults synchronize];
    }
}

-(BOOL)isSecrectModel {
    if([userDefaults objectForKey: SecretModelKey]){
        return [[userDefaults objectForKey: SecretModelKey] boolValue];
    }else {
        self.isSecrectModel = YES;
        return YES;
    }
}

@end
