//
//  MKFileCtrl.h
//  MKImageReview
//
//  Created by DONLINKS on 16/9/28.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKFileCtrl : NSObject


/**
 删除文件，包括文件夹

 @param filePath 路径集合
 */
-(void)deleteItemAtPaths:(NSArray<NSString *> *)filePaths complateHandler:(void (^)(NSError *))handler;


/**
 分享文件，包括文件夹，文件夹会经过压缩

 @param filePath 路径
 @param handler
 */
-(void)shareItemAtPaths:(NSArray<NSString *> *)filePaths complateHandler:(void (^)(NSError *))handler;

@end
