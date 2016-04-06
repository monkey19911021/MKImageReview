//
//  MKFileObject.m
//  MKImageReview
//
//  Created by Liujh on 16/3/30.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "MKFileObject.h"

@implementation MKFileObject

-(NSArray<NSString *> *)getCurrentPathFile:(MKFileType)fileType path:(NSString *)path
{
    NSMutableArray<NSString *> *filePaths = [NSMutableArray new];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = false;
    if([fileManager fileExistsAtPath:path isDirectory: &isDirectory]){
        if(!isDirectory){
            path = [path stringByDeletingLastPathComponent];
        }
        
        NSArray<NSString *> *subPaths = [fileManager contentsOfDirectoryAtPath:path error:NULL];
        for(NSString *subPath in subPaths){
            if([IMAGES_TYPES containsObject: [subPath pathExtension]]){
                [filePaths addObject:subPath];
            }
        }
    }
    
    return filePaths;
}

@end
