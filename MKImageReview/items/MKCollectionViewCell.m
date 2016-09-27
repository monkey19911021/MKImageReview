//
//  MKCollectionViewCell.m
//  MKImageReview
//
//  Created by Liujh on 16/3/30.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "MKCollectionViewCell.h"
#import "MKImagesReViewController.h"
#import "UIImageView+MKImageView.h"
#import "MKPreviewingViewController.h"


@interface MKCollectionViewCell() <UIViewControllerPreviewingDelegate>

@end

@implementation MKCollectionViewCell
{
    id <UIViewControllerPreviewing> ctrlPreviewing;
}
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
        
        //设置高亮背景
        CGRect bgViewFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        UIColor *bgViewColor = [UIColor colorWithRed:68/255.0f green:179/255.0f blue:236/255.0f alpha:0.5];
        UIView *backgroundView = [[UIView alloc] initWithFrame: bgViewFrame];
        backgroundView.backgroundColor = bgViewColor;
        [backgroundView.layer setCornerRadius:5];
        [self setSelectedBackgroundView:backgroundView];
    }
    
    return self;
}

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if(_isSelected){
        self.layer.borderColor = [UIColor redColor].CGColor;
    }else{
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    }
}

-(void)setPreviewingRegister:(UICollectionViewController *)previewingRegister {
    _previewingRegister = previewingRegister;
    if(!ctrlPreviewing){
        if (_previewingRegister.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            ctrlPreviewing = [_previewingRegister registerForPreviewingWithDelegate: self sourceView: self];
        }
    }
}

-(void)setFileObject:(MKFileObject *)fileObject {
    _fileObject = fileObject;
    _titleLabel.text = fileObject.name;
    _imageView.image = fileObject.image;
    if(fileObject.fileType == MKFileTypeImage){
        _imageView.imageData = [NSData dataWithContentsOfFile: fileObject.filePath];
    }
}

#pragma mark - UIViewControllerPreviewingDelegate
//peek
-(UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    if([_previewingRegister.presentedViewController isKindOfClass: [MKPreviewingViewController class]]){
        return nil;
    }else{
        MKPreviewingViewController *ctrl = [MKPreviewingViewController new];
        ctrl.fileObject = _fileObject;
        
        return ctrl;
    }
}

//pop
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [_previewingRegister collectionView:_previewingRegister.collectionView didSelectItemAtIndexPath: _indexPath];
}

-(void)dealloc {
    if(_previewingRegister){
        [_previewingRegister unregisterForPreviewingWithContext: ctrlPreviewing];
    }
}

@end
