//
//  MKCollectionViewCell.m
//  MKImageReview
//
//  Created by Liujh on 16/3/30.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "MKCollectionViewCell.h"

@implementation MKCollectionViewCell

-(id)initWithFrame: (CGRect)frame{
    self = [super initWithFrame: frame];
    CGFloat height = frame.size.height;
    CGFloat width = frame.size.width;
    
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.layer.cornerRadius = 5.0f;
        
        //取宽的1/20作为图标的边距
        CGFloat margin = width / 20.f;
        _imageView = [[UIImageView alloc] initWithFrame: CGRectMake(margin,
                                                                    margin,
                                                                    width - 2 * margin,
                                                                    width - 2 * margin)];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(margin,
                                                                 _imageView.frame.size.height,
                                                                 width - 2 * margin,
                                                                 height - _imageView.frame.size.height)];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize: (width / 7)];
        
        [self addSubview: _imageView];
        [self addSubview: _titleLabel];
    }
    
    return self;
}

@end