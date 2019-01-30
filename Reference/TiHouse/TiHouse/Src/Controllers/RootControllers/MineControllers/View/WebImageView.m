//
//  WebImageView.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/25.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "WebImageView.h"

@interface WebImageView ()

@property (nonatomic, strong  ) UIImageView *contentImageView;
@property (nonatomic, strong  ) UIImageView *placeHolderImageView;

@end

@implementation WebImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupUIInterface];
    }
    return self;
}

- (void)setupUIInterface
{
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    
    [self addSubview:self.placeHolderImageView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeHolderImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeHolderImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    self.placeHolderImageView.image = placeholder;
    self.placeHolderImageView.alpha = 1.0;
    [self sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error)
        {
            BOOL hasAnimation = NO;
            if (image) {
                if (cacheType == SDImageCacheTypeNone || cacheType == SDImageCacheTypeDisk)
                {
                    hasAnimation = YES;
                }
            }
            if (hasAnimation)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.placeHolderImageView.alpha = 0.0;
                }];
            }
            else
            {
                self.placeHolderImageView.alpha = 0.0;
            }
        }
    }];
}

- (UIImageView *)placeHolderImageView
{
    if (!_placeHolderImageView)
    {
        _placeHolderImageView = [[UIImageView alloc] init];
        _placeHolderImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _placeHolderImageView.contentMode = UIViewContentModeCenter;
    }
    return _placeHolderImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
