//
//  MKAddPic.h
//  MKImageReview
//
//  Created by DONLINKS on 16/9/19.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MKAddPic : NSObject

@property(weak, nonatomic) id imagePickerDelegate;

-(void)addPicToPath:(NSString *)filePath;

@end
