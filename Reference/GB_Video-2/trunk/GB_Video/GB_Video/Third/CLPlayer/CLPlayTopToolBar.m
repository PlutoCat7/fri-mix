//
//  PlayTopToolBar.m
//  PlayView
//
//  Created by Rainy on 2017/12/29.
//  Copyright © 2017年 Rainy. All rights reserved.
//

//间隙

#import "CLPlayTopToolBar.h"
#import "Masonry.h"

@interface CLPlayTopToolBar ()

/**顶部工具条返回按钮*/
@property (nonatomic,strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CLPlayTopToolBar

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        self.userInteractionEnabled = YES;
        [self setUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        [self setUI];
    }
    return self;
}

#pragma mark - Public

- (void)setTitle:(NSString *)title {
    
    self.titleLabel.text = title;
}

#pragma mark - Action

//返回按钮
- (void)backButtonAction:(UIButton *)button {
    
    if (_delegate && [_delegate respondsToSelector:@selector(didClickBackInPlayTopToolBar:)]) {
        [_delegate didClickBackInPlayTopToolBar:self];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}

#pragma mark - Private

- (void)setUI
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backButton];
    [self addSubview:self.titleLabel];
    //返回按钮
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(8);
        make.bottom.mas_equalTo(0);
        make.width.equalTo(self.backButton.mas_height);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backButton);
        make.left.equalTo(self.backButton.mas_right).with.offset(2);
    }];
}

#pragma mark - Setter and Getter

//返回按钮
- (UIButton *)backButton {
    
    if (_backButton == nil){
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"cl_back"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"cl_back"] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:17.0f];
    }
    return _titleLabel;
}

@end
