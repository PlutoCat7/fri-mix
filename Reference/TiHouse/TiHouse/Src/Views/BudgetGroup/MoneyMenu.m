//
//  MoneyMenu.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/22.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#define MoneyMenuTitleViewFont [UIFont systemFontOfSize:13]

#import "MoneyMenu.h"
#import "NewBudgetPopView.h"
@interface MoneyMenu()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, assign) BOOL showLine;
@property (nonatomic, retain) UIView *line;
@property (nonatomic, retain) UIButton *iconView;

@end

@implementation MoneyMenu

-(instancetype)initWithTitle:(NSString *)title Money:(NSString *)money{
    return [self initWithTitle:title Money:money ShowLine:NO];
}

-(instancetype)initWithTitle:(NSString *)title Money:(NSString *)money ShowLine:(BOOL)line{
    
    return [self initWithTitle:title Money:money Icon:nil ShowLine:line];
}

-(instancetype)initWithTitle:(NSString *)title Money:(NSString *)money Icon:(UIImage *)icon ShowLine:(BOOL)line{
    
   return [self initWithFrame:CGRectZero Title:title Money:money Icon:icon ShowLine:line];
}

-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title Money:(NSString *)money Icon:(UIImage *)icon ShowLine:(BOOL)line{
    
    if (self = [super initWithFrame:frame]) {
        _title = title;
        _money = money;
        _icon = icon;
        _showLine = line;
        
        [self titleView];
        [self moneyView];
        if (icon) {
            [self iconView];
        }
        if (line) {
            [self line];
        }
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_titleView sizeToFit];
    [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(_titleView.size.width+10, _titleView.size.height+2));
        make.top.equalTo(@(self.height/3 - _titleView.height/2 - 3));
    }];
    
    [self layoutIfNeeded];
    
    [_moneyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(2);
        make.height.equalTo(@(self.height/2+5));
    }];
}

-(UILabel *)titleView{
    if (!_titleView) {
        _titleView = [[UILabel alloc]init];
        _titleView.text = _title;
        _titleView.layer.masksToBounds = YES;
        _titleView.layer.cornerRadius = 5;
        _titleView.textColor = kTitleAddHouseTitleCOLOR;
        _titleView.textAlignment = NSTextAlignmentCenter;
        _titleView.font = MoneyMenuTitleViewFont;
        [_titleView sizeToFit];
        [self addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(_titleView.size);
            make.top.equalTo(self);
            make.centerX.equalTo(self.mas_centerX);
        }];
    }
    return _titleView;
}

-(UILabel *)moneyView{
    if (!_moneyView) {
        _moneyView = [[UILabel alloc]init];
        _moneyView.text = _money;
        _moneyView.textColor = XWColorFromHex(0x44444b);
        _moneyView.textAlignment = NSTextAlignmentCenter;
        _moneyView.font = MoneyMenuTitleViewFont;
        [self addSubview:_moneyView];
        [_moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(@(self.height/3));
        }];
    }
    return _moneyView;
}

-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = XWColorFromHex(0xfec00c);
        [self addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.right.equalTo(self);
            make.height.equalTo(self);
            make.width.equalTo(@(0.5f));
        }];
    }
    return _line;
}

-(UIButton *)iconView{
    if (!_iconView) {
        _iconView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconView setImage:_icon forState:UIControlStateNormal];
        [_iconView addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(_icon.size);
            make.left.equalTo(_titleView.mas_right).offset(-2);
            make.centerY.equalTo(_titleView.mas_centerY);
        }];
    }
    return _iconView;
}
-(void)pop{
    NewBudgetPopView *pop = [[NewBudgetPopView alloc]initWithType:(NewBudgetPopTyoeAssess)];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:pop];
    [pop Show];
}


@end
