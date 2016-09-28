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

 @param filePath 路径
 */
-(void)deleteItemAtPath:(NSString *)filePath complateHandler:(void (^)(NSError *))handler;


@end
