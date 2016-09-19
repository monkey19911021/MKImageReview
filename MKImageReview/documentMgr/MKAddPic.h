//
//  MKAddPic.h
//  MKImageReview
//
//  Created by DONLINKS on 16/9/19.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKAddPic : NSObject

-(void)addPicToPath:(NSString *)filePath successBlock:(void(^)())successBlock;

@end
