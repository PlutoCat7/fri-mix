//
//  AddBudgetBtn.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/24.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AddBudgetBtn.h"

@interface AddBudgetBtn()
@property (nonatomic, retain) UIView *line;

@end


@implementation AddBudgetBtn

-(instancetype)init{
    
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowOffset = CGSizeMake(3, 0);
        [self Title];
        [self line];
    }
    return self;
}

-(UILabel *)Title{
    if (!_Title) {
        _Title = [[UILabel alloc]init];
        _Title.text = @"添加预算";
        _Title.textColor = kTitleAddHouseCOLOR;
        _Title.font = [UIFont systemFontOfSize:18 weight:20];
        _Title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_Title];
        [_Title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top);
            make.width.equalTo(@(200));
            make.height.equalTo(@(40));
        }];
    }
    return _Title;
}

-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = kTiMainBgColor;
        _line.layer.cornerRadius = 3.f;
        [self addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.equalTo(_Title.mas_bottom).offset(-5);
            make.width.equalTo(@(30));
            make.height.equalTo(@(3));
        }];
    }
    return _line;
}

@end
