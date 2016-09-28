//
//  MKUserPerference.h
//  MKImageReview
//
//  Created by DONLINKS on 16/9/23.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MKInstance.h"

@interface MKUserPerference : NSObject

//是否开启隐私模式
@property (assign, nonatomic) BOOL isSecrectModel;

//是否询问用户删除文件
@property (assign, nonatomic) BOOL isAskBeforeDelete;

@end
