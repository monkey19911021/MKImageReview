//
//  MKInfiniteScrollView.m
//  MKImageReview
//
//  Created by Liujh on 16/4/8.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "MKInfiniteScrollView.h"

@implementation MKInfiniteScrollView
{
    NSMutableArray<MKInfiniteScrollViewCell *> *reuseItems;
    
    NSInteger numberOfItems;
}
-(instancetype)init
{
    self = [super init];
    if(self){
        reuseItems = [NSMutableArray new];
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        for(int count=0; count<3; count++){
            
        }
        
    }
    return self;
}

-(MKInfiniteScrollViewCell *)getCellAtIndex:(NSInteger)index
{
    MKInfiniteScrollViewCell *cell = nil;
    if(_dataSource != nil){
        cell = [_dataSource infiniteScrollView:self cellForItemAtIndex:index];
    }
    return cell;
}

-(void)reloadData
{
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
