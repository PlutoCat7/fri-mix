//
//  LeftMenuTableViewCell.m
//  MagicBean
//
//  Created by yahua on 16/3/29.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "LeftMenuTableViewCell.h"

@interface LeftMenuTableViewCell ()

@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *typeLabel;

@end

@implementation LeftMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.typeImageView];
        [self.contentView addSubview:self.typeLabel];
        
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        selectedBackgroundView.backgroundColor = [UIColor colorWithHex:0xffffff andAlpha:0.3];
        self.selectedBackgroundView = selectedBackgroundView;
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.typeImageView.left = 15;
    [self.typeImageView centerYInContainer];
    
    [self.typeLabel setHeight:self.contentView.height];
    [self.typeLabel resizeLabelHorizontal];
    [self.typeLabel centerYInContainer];
    [self.typeLabel left:10 FromView:self.typeImageView];
}

#pragma mark - Public

- (void)reloadWithImage:(UIImage *)image typeTitle:(NSString *)typeTitle {
    
    self.typeImageView.image = image;
    self.typeLabel.text = typeTitle;
}

#pragma mark - Getters and Setters

- (UIImageView *)typeImageView {
    
    if (!_typeImageView) {
        _typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    }
    return _typeImageView;
}

- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.font = [UIFont systemFontOfSize:17.0f];
    }
    return _typeLabel;
}

@end
