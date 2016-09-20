//
//  MKImageView+UIImageView.m
//  MKImageReview
//
//  Created by DONLINKS on 16/9/20.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "UIImageView+MKImageView.h"
#import "NSData+MKData.h"
#import <objc/runtime.h>

@implementation UIImageView (MKImageView)

static const char MKImageDataKey = '\0';
-(void)setImageData:(NSData *)imageData {
    if (imageData != self.imageData) {
        self.image = [UIImage imageWithData: imageData];
        
        if([imageData getImageDataFormat] == GIF){
            
        }
        
        
        [self willChangeValueForKey:@"seniorImage"]; // KVO
        objc_setAssociatedObject(self, &MKImageDataKey,
                                 imageData, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"seniorImage"]; // KVO
    }
}

-(NSData *)imageData {
    return objc_getAssociatedObject(self, &MKImageDataKey);
}

@end

