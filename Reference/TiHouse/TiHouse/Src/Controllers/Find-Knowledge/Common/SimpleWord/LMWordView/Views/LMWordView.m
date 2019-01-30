//
//  LMWordView.m
//  SimpleWord
//
//  Created by Chenly on 16/5/12.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "LMWordView.h"
#import <objc/runtime.h>
#import "UITextView+ZWPlaceHolder.h"

@implementation LMWordView {
    UIView *_titleView;
    UIView *_separatorLine;
    
    CGRect _frameCache;
}

static CGFloat const kLMWMargin = 12.f;
static CGFloat const kLMWTitleHeight = 44.f;
static CGFloat const kLMWCommonSpacing = 18.f;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _titleTextField = [[UITextField alloc] init];
    _titleTextField.font = [UIFont systemFontOfSize:18.f];
    _titleTextField.placeholder = @"请输入标题";
    
    _separatorLine = [[UIView alloc] init];
    _separatorLine.backgroundColor = [UIColor colorWithRGBHex:0xdbdbdb];
    
    _titleView = [[UIView alloc] init];
    _titleView.backgroundColor = [UIColor whiteColor];
    
    [_titleView addSubview:_titleTextField];
    [_titleView addSubview:_separatorLine];
    [self addSubview:_titleView];
    
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.spellCheckingType = UITextSpellCheckingTypeNo;    
    self.alwaysBounceVertical = YES;
    self.textContainerInset = UIEdgeInsetsMake(kLMWMargin + kLMWTitleHeight + kLMWCommonSpacing,
                                               kLMWCommonSpacing,
                                               kLMWCommonSpacing,
                                               kLMWCommonSpacing);
    self.zw_placeHolder = @"请输入正文";
    self.zw_placeHolderColor = [UIColor colorWithRGBHex:0x999999];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGRectEqualToRect(_frameCache, self.frame)) {
        CGRect rect = CGRectInset(self.bounds, 0, 0);
        rect.origin.y = kLMWMargin;
        rect.size.height = kLMWTitleHeight;
        _titleView.frame = rect;
        
        rect.origin = CGPointZero;
        rect.origin.x = kLMWCommonSpacing+5;
        rect.size.height = kLMWTitleHeight;
        rect.size.width = rect.size.width - 2*(kLMWCommonSpacing+5);
        _titleTextField.frame = rect;
        
        rect.origin.x = kLMWMargin;
        rect.origin.y = CGRectGetHeight(_titleView.bounds) - 1;
        rect.size.height = .5f;
        rect.size.width = _titleView.width-(2*kLMWMargin);
        _separatorLine.frame = rect;
        
        _frameCache = self.frame;
    }
}

@end
