//
//  MKUserPerference.m
//  MKImageReview
//
//  Created by DONLINKS on 16/9/23.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "MKUserPerference.h"

NSString *const SecretModelKey = @"SecretModelKey";
@implementation MKUserPerference
{
    NSUserDefaults *userDefaults;
}

-(instancetype)init {
    if(self = [super init]){
        userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

-(void)setIsSecrectModel:(BOOL)isSecrectModel {
    [userDefaults setObject: @(isSecrectModel) forKey: SecretModelKey];
    [userDefaults synchronize];
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
