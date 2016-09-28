//
//  MKFileObject.h
//  MKImageReview
//
//  Created by Liujh on 16/3/30.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MKFileType) {
    
    MKFileTypeUnknown = -1, //未知
    
    MKFileTypeDirectory = 0, //目录
    
    MKFileTypeImage = 1, //图片
    
    MKFileTypeTxt = 2, //文本
};

@interface MKFileObject : NSObject

-(instancetype)initWithFilePath:(NSString *)filePath;

//文件路径
@property (strong, nonatomic) NSString *filePath;

@property (strong, nonatomic) NSString *name;

//图标
@property (strong, nonatomic) UIImage *image;

@property (assign, nonatomic) MKFileType fileType;


/**
 *  获取路径下所有某类型的文件
 *
 *  @param path     路径
 *  @param fileType 文件类型
 *
 *  @return 文件路径集合
 */
+(NSArray<NSString *> *)getFilesInPath:(NSString *)path fileType:(MKFileType)fileType;


/**
 *  获取当前文件所在目录所有相同类型的文件集合
 *
 *  @return 文件路径集合
 */
-(NSArray<NSString *> *)getDirectoryFiles;
@end
