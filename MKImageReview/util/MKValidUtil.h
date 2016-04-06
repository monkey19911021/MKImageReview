//
//  MKValidUtil.h
//  MKImageReview
//
//  Created by Liujh on 16/3/11.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKValidUtil : NSObject

-(void)validUserWithsuccess:(void (^)()) successBlock failure:(void (^)()) failureBlock;

@end
