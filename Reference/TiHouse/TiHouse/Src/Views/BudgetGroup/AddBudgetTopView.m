//
//  BottomBtnView.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AddBudgetTopView.h"
#import "BudgetThreeClass.h"

@interface AddBudgetTopView()


@end

@implementation AddBudgetTopView

-(instancetype)initWithThreeClass:(BudgetThreeClass *)threeClass{
    if (self = [super init]) {
        _threeClass = threeClass;
        self.backgroundColor = [UIColor whiteColor];
        [self allMoney];
        [self label];
        [self titleField];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = kLineColer;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(self);
            make.height.equalTo(@(0.5));
        }];
        [self layoutIfNeeded];
    }
    return self;
}

-(void)setThreeClass:(BudgetThreeClass *)threeClass{
    _threeClass = threeClass;
    _titleField.text = threeClass.proname;
    _allMoney.text = [NSString stringWithFormat:@"%2.f",(float)threeClass.amountzj / 100.0f];
    
}


-(UITextField *)titleField{
    if (!_titleField) {
        _titleField = [[UITextField alloc]init];
        _titleField.textColor = [UIColor blackColor];
        _titleField.text = _threeClass.proname;
        _titleField.placeholder = @"请输入项目名称";
        _titleField.font = [UIFont systemFontOfSize:18 weight:20];
        CGFloat titleH = [@"项目名称" getHeightWithFont:[UIFont systemFontOfSize:18 weight:20] constrainedToSize:CGSizeMake(200, 40)];
        [self addSubview:_titleField];
        [_titleField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_allMoney.mas_left).offset(5);
            make.bottom.equalTo(_label.mas_top).offset(-8);
            make.width.equalTo(@(200));
            make.height.equalTo(@(titleH));
        }];
    }
    return _titleField;
}

-(UITextField *)allMoney{
    if (!_allMoney) {
        _allMoney = [[UITextField alloc]init];
        _allMoney.textColor = XWColorFromHex(0xfec00c);
        _allMoney.layer.borderColor = XWColorFromHex(0xebebeb).CGColor;
        _allMoney.layer.borderWidth = 0.5f;
        _allMoney.layer.cornerRadius = 5;
        _allMoney.rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _allMoney.rightViewMode = UITextFieldViewModeAlways;
        _allMoney.textAlignment = NSTextAlignmentRight;
        _allMoney.keyboardType = UIKeyboardTypeDecimalPad;
        _allMoney.clearButtonMode = UITextFieldViewModeNever;
        _allMoney.font = [UIFont systemFontOfSize:24];
        _allMoney.backgroundColor = XWColorFromHex(0xfcfcfc);
        _allMoney.text = [NSString stringWithFormat:@"%.2f",(float)_threeClass.amountzj / 100.0f];
        [self addSubview:_allMoney];
        [_allMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(13);
            make.right.equalTo(self).offset(-13);
            make.bottom.equalTo(self.mas_bottom).offset(-15);
            make.height.equalTo(@(46));
        }];
    }
    return _allMoney;
}

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.textColor = kColor999; 
        _label.numberOfLines = 0;
        _label.text = _threeClass.catethreetipa;
        _label.font = [UIFont systemFontOfSize:12];
        CGFloat labelH = [_threeClass.catethreetipa getHeightWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreen_Width-30, 100)];
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_allMoney.mas_top).offset(-9);
            make.left.equalTo(_allMoney.mas_left).offset(5);
            make.width.equalTo(@(kScreen_Width-30));
            make.height.equalTo(@(labelH));
        }];
    }
    return _label;
}



@end
