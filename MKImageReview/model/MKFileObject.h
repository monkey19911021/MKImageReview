//
//  MKFileObject.h
//  MKImageReview
//
//  Created by Liujh on 16/3/30.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MKFileObject : NSObject

@property(strong, nonatomic)NSString *name;

@property(strong, nonatomic)UIImage *image;

//是否文件夹
@property(assign, nonatomic)BOOL isDirectory;

@property(strong, nonatomic)NSString *filePath;

@end
