//
//  MKFileObject.m
//  MKImageReview
//
//  Created by Liujh on 16/3/30.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "MKFileObject.h"

const UInt8 IMAGES_TYPES_COUNT = 7;
const NSString *IMAGES_TYPES[IMAGES_TYPES_COUNT] = {@"png", @"PNG", @"jpg", @"jpeg", @"JPG", @"gif", @"GIF"};

const UInt8 TEXT_TYPES_COUNT = 9;
const NSString *TEXT_TYPES[TEXT_TYPES_COUNT] = {@"txt", @"TXT", @"doc", @"docx", @"html", @"js", @"xls", @"xlsx", @"ppt"};

@implementation MKFileObject
{
    NSFileManager *fileMgr;
}

-(instancetype)init {
    if(self = [super init]) {
        fileMgr = [NSFileManager defaultManager];
    }
    return self;
}

-(instancetype)initWithFilePath:(NSString *)filePath {
    if(self = [self init]){
        self.filePath = filePath;
    }
    return self;
}

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
            NSArray *array = [NSArray arrayWithObjects: IMAGES_TYPES count: IMAGES_TYPES_COUNT];
            if([array containsObject: [subPath pathExtension]]){
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

-(void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    
    self.name = [filePath lastPathComponent];

    BOOL isDirectory = true;
    [fileMgr fileExistsAtPath: filePath isDirectory: &isDirectory];
    self.image = [UIImage imageNamed: @"fielIcon"];
    
    if(isDirectory){
        self.image = [UIImage imageNamed: @"dirIcon"];
        self.fileType = MKFileTypeDirectory;
    }else{
        
        NSArray *imageTypesArray = [NSArray arrayWithObjects: IMAGES_TYPES count: IMAGES_TYPES_COUNT];
        NSArray *textTypesArray = [NSArray arrayWithObjects: TEXT_TYPES count: TEXT_TYPES_COUNT];
        
        if([imageTypesArray containsObject: [filePath pathExtension]]){
            self.image = [UIImage imageWithContentsOfFile: filePath];
            self.fileType = MKFileTypeImage;
        }
        
        if([textTypesArray containsObject: [filePath pathExtension]]){
            self.image = [UIImage imageNamed: @"fielIcon"];
            self.fileType = MKFileTypeTxt;
        }
        
    }
}

@end
