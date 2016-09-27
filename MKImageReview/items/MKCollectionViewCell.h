//
//  MKCollectionViewCell.h
//  MKImageReview
//
//  Created by Liujh on 16/3/30.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKFileObject.h"

@interface MKCollectionViewCell : UICollectionViewCell

@property(strong, nonatomic, readonly)UILabel *titleLabel;

@property(strong, nonatomic, readonly)UIImageView *imageView;

@property(assign, nonatomic)BOOL isSelected;

@property(weak, nonatomic) MKFileObject *fileObject;

@property(weak, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) UICollectionViewController *previewingRegister;

@end
