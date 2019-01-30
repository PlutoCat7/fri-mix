//
//  GBSegmentTitleView.m
//  GB_Football
//
//  Created by gxd on 17/7/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBSegmentTitleView.h"

@interface GBSegmentTitleView() {
    CGSize _titleSize;
}

@property (strong, nonatomic) UIButton *label;
@property (strong, nonatomic) UIView *contentView;

@end

@implementation GBSegmentTitleView
- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.currentTransformSx = 1.0;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.label];
        
    }
    
    return self;
}

- (void)setCurrentTransformSx:(CGFloat)currentTransformSx {
    _currentTransformSx = currentTransformSx;
    self.transform = CGAffineTransformMakeScale(currentTransformSx, currentTransformSx);
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.label.frame = self.bounds;

}

- (void)adjustSubviewFrame {
    
    CGRect contentViewFrame = self.bounds;
    self.contentView.frame = contentViewFrame;
    self.label.frame = self.contentView.bounds;
    
    [self addSubview:self.contentView];
    [self.label removeFromSuperview];
    [self.contentView addSubview:self.label];
    
}



- (CGFloat)titleViewWidth {
    return _titleSize.width;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.label.titleLabel.font = font;
}

- (void)setHighlightFont:(UIFont *)font {
    _highlightFont = font;
}

- (void)setText:(NSString *)text {
    _text = text;
    [self.label setTitle:text forState:UIControlStateNormal];
    if (self.highlightFont != nil) {
        CGRect bounds = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.highlightFont} context:nil];
        _titleSize = bounds.size;
    } else {
        CGRect bounds = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.label.titleLabel.font} context:nil];
        _titleSize = bounds.size;
    }
    
    
    
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self.label setTitleColor:textColor forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
}

- (UIButton *)label {
    if (_label == nil) {
        _label = [[UIButton alloc] init];
        //[_label setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
        [_label addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _label;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}


-(void) clickButton: (id) sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(GBSegmentTitleView:)]) {
        [self.delegate GBSegmentTitleView:self];
    }
}

@end
