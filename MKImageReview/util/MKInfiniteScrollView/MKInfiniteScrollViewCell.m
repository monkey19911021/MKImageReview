//
//  MKInfiniteScrollViewCell.m
//  MKImageReview
//
//  Created by Liujh on 16/4/8.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "MKInfiniteScrollViewCell.h"

@implementation MKInfiniteScrollViewCell

-(instancetype)init
{
    self = [super init];
    if(self){
        
    }
    return self;
}

-(void)setBackgroundView:(UIView *)backgroundView
{
    _backgroundView = backgroundView;
    [self addSubview:backgroundView];
    [self sendSubviewToBack:backgroundView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
