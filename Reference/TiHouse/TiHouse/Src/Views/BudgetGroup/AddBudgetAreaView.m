//
//  BottomBtnView.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AddBudgetAreaView.h"
#import "BudgetThreeClass.h"

@interface AddBudgetAreaView()

@property (nonatomic, retain) UILabel *label;

@end

@implementation AddBudgetAreaView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self label];
        [self allMoney];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        line.backgroundColor = kLineColer;
        [self addSubview:line];
    }
    return self;
}



-(UITextField *)allMoney{
    if (!_allMoney) {
        _allMoney = [[UITextField alloc]init];
        _allMoney.textColor = XWColorFromHex(0xfec00c);
        _allMoney.layer.borderColor = XWColorFromHex(0xebebeb).CGColor;
        _allMoney.layer.borderWidth = 0.5f;
        _allMoney.layer.cornerRadius = 5;
//        _allMoney.placeholder = @"请输";
        _allMoney.rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _allMoney.rightViewMode = UITextFieldViewModeAlways;
        _allMoney.textAlignment = NSTextAlignmentRight;
        _allMoney.keyboardType = UIKeyboardTypeNumberPad;
        _allMoney.font = [UIFont systemFontOfSize:24];
        _allMoney.backgroundColor = XWColorFromHex(0xfcfcfc);
        [self addSubview:_allMoney];
        [_allMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(13);
            make.right.equalTo(self).offset(-13);
            make.top.equalTo(_label.mas_bottom).offset(11);
            make.height.equalTo(@(46));
        }];
    }
    return _allMoney;
}

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.text = @"您可以根据单价计算总价或者直接输入总价";
        _label.textColor = kColor999;
        _label.font = [UIFont systemFontOfSize:12];
        CGSize size = [_label sizeThatFits:CGSizeMake(20, 20)];
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self).offset(11);
            make.width.equalTo(@(size.width));
            make.height.equalTo(@(size.height));
        }];
    }
    return _label;
}



@end
