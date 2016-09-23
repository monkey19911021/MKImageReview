//
//  NSObject+MKInstance.m
//  MKImageReview
//
//  Created by DONLINKS on 16/9/23.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "NSObject+MKInstance.h"

@implementation NSObject (MKInstance)

+(instancetype)instance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

@end
