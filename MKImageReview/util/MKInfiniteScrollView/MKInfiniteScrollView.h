//
//  MKInfiniteScrollView.h
//  MKImageReview
//
//  Created by Liujh on 16/4/8.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKInfiniteScrollView;
@class MKInfiniteScrollViewCell;

@protocol MKInfiniteScrollViewDataSource <NSObject>

@required
- (NSInteger)numberOfItems;

- (nullable MKInfiniteScrollViewCell *)infiniteScrollView:(nullable MKInfiniteScrollView *)scrollView cellForItemAtIndex:(NSInteger)index;

@end

@protocol MKInfiniteScrollViewDelegate <NSObject>



@end

@interface MKInfiniteScrollView : UIView

@property (nonatomic, weak, nullable) id <MKInfiniteScrollViewDelegate> delegate;
@property (nonatomic, weak, nullable) id <MKInfiniteScrollViewDataSource> dataSource;

//是否循环
@property (nonatomic, assign) BOOL isCycle;

-(void)reloadData;

@end
