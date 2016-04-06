//
//  MKFileObject.m
//  MKImageReview
//
//  Created by Liujh on 16/3/30.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "MKFileObject.h"

@implementation MKFileObject

+(NSArray<NSString *> *)getFilesInPath:(NSString *)path fileType:(MKFileType)fileType;
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
                [filePaths addObject: [NSString stringWithFormat:@"%@/%@", path, subPath]];
            }
        }
    }
    
    return filePaths;
}


-(NSArray<NSString *> *)getDirectoryFiles
{
    return [MKFileObject getFilesInPath:self.filePath fileType:self.fileType];
}

@end
