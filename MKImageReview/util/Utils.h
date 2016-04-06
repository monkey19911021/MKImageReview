//
//  Config.h
//  test
//
//  Created by steven on 13-1-27.
//  Copyright (c) 2013年 minstone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//应用图片文件路径
#define InternetImageFilePath ([NSString stringWithFormat:@"%@/Library/Caches/internetImage", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]])

#define HomeFilePath ([NSString stringWithFormat:@"%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]])

@interface Utils : NSObject

+(Utils *)sharedConfig;


@end