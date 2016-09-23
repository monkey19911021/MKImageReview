//
//  Config.m
//  test
//
//  Created by steven on 13-1-27.
//  Copyright (c) 2013年 minstone. All rights reserved.
//

#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>

NSString *const SnapshootNotification = @"SnapshootNotification";

@implementation Utils{
    UIViewController *tempViewContyroller;
}

-(id)init{
    self = [super init];
    if(self){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:InternetImageFilePath]){
            [fileManager createDirectoryAtPath:InternetImageFilePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

+(Utils *)sharedConfig{
    static Utils *_sharedConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConfig = [[Utils alloc]init];
    });
    return _sharedConfig;

}


@end


