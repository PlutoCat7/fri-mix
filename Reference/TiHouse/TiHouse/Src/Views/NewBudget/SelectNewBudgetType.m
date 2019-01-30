//
//  SelectNewBudgetType.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/24.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SelectNewBudgetType.h"

@interface SelectNewBudgetType()

@property (nonatomic, retain) UIButton *zeroStartBtn;
@property (nonatomic, retain) UIButton *oneKeyBtn;
@property (nonatomic, retain) UIButton *whatOneKeyBtn;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIImageView *imageV;

@end

@implementation SelectNewBudgetType

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kRKBViewControllerBgColor;
        [self zeroStartBtn];
        [self imageV];
        [self oneKeyBtn];
        [self whatOneKeyBtn];
        [self label];
        
    }
    return self;
}

-(void)Show{
    [self.superview bringSubviewToFront:self];
    self.backgroundColor = [UIColor whiteColor];
    
//    [_zeroStartBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(175);
//    }];
    
    [UIView animateWithDuration:0 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
//        [self layoutIfNeeded];
        _zeroStartBtn.y = self.centerY - 100;
    } completion:^(BOOL finished) {
        
//        [_imageV mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_zeroStartBtn.mas_bottom).offset(20);
//        }];
        [UIView animateWithDuration:0 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
//            [self layoutIfNeeded];
            _imageV.y = CGRectGetMaxY(_zeroStartBtn.frame)+8;
        } completion:^(BOOL finished) {
//            [_label mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(_imageV.mas_bottom).offset(20);
//            }];
            _label.y = CGRectGetMaxY(_imageV.frame)+8;
            [UIView animateWithDuration:0 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
//                [self layoutIfNeeded];
                _label.alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
//                    [self layoutIfNeeded];
                    _oneKeyBtn.y = CGRectGetMaxY(_label.frame)+25;
                } completion:^(BOOL finished) {
//                    [_oneKeyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//                        make.top.equalTo(_label.mas_bottom).offset(25);
//                    }];
                    _whatOneKeyBtn.alpha = 1;
                }];
            }];
        }];
    }];
    
}

-(void)zeroStart:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(SelectNewBudgetTypeBtntag:)]) {
        [self.delegate SelectNewBudgetTypeBtntag:btn.tag];
    }
}




-(UIButton *)zeroStartBtn{
    if (!_zeroStartBtn) {
        _zeroStartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _zeroStartBtn.layer.cornerRadius = 25;
        _zeroStartBtn.backgroundColor = XWColorFromHex(0xfec00c);
        _zeroStartBtn.tag = 10;
        [_zeroStartBtn setTitle:@"从零开始做预算" forState:UIControlStateNormal];
        [_zeroStartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_zeroStartBtn addTarget:self action:@selector(zeroStart:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_zeroStartBtn];
        _zeroStartBtn.frame = CGRectMake(0, self.height, 270, 50);
        _zeroStartBtn.centerX = self.centerX;
//        [_zeroStartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).offset(52);
//            make.right.equalTo(self).offset(-52);
//            make.height.equalTo(@(50));
//            make.top.equalTo(self.mas_bottom);
//        }];
    }
    return _zeroStartBtn;
}

-(UIButton *)oneKeyBtn{
    if (!_oneKeyBtn) {
        _oneKeyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _oneKeyBtn.layer.cornerRadius = 25;
        _oneKeyBtn.layer.borderWidth = 1.f;
        _oneKeyBtn.tag = 11;
        _oneKeyBtn.layer.borderColor = XWColorFromHex(0xfec00c).CGColor;
        _oneKeyBtn.backgroundColor = [UIColor whiteColor];
        [_oneKeyBtn setTitle:@"一键生成预算表" forState:UIControlStateNormal];
        [_oneKeyBtn setTitleColor:XWColorFromHex(0xfec00c) forState:UIControlStateNormal];
        [_oneKeyBtn addTarget:self action:@selector(zeroStart:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_oneKeyBtn];
        _oneKeyBtn.frame = CGRectMake(0, self.height, 270, 50);
        _oneKeyBtn.centerX = self.centerX;
//        [_oneKeyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).offset(52);
//            make.right.equalTo(self).offset(-52);
//            make.height.equalTo(@(50));
//            make.top.equalTo(self.mas_bottom);
//        }];
    }
    return _oneKeyBtn;
}

-(UIImageView *)imageV{
    if (!_imageV) {
        UIImage *image = [UIImage imageNamed:@"or_icon"];
        _imageV = [[UIImageView alloc]init];
        _imageV.image = image;
        [self addSubview:_imageV];
        _imageV.size = image.size;
        _imageV.centerX = self.centerX;
        _imageV.y = self.height;
//        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.mas_centerX);
//            make.top.equalTo(self.mas_bottom);
//            make.size.mas_equalTo(image.size);
//        }];
    }
    return _imageV;
}

-(UIButton *)whatOneKeyBtn{
    if (!_whatOneKeyBtn) {
        _whatOneKeyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_whatOneKeyBtn setTitle:@" 什么是一键生成？" forState:UIControlStateNormal];
        [_whatOneKeyBtn setImage:[UIImage imageNamed:@"I_icon"] forState:UIControlStateNormal];
        _whatOneKeyBtn.alpha = 0;
        _whatOneKeyBtn.tag = 12;
        _whatOneKeyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_whatOneKeyBtn setTitleColor:XWColorFromHex(0x576b95) forState:UIControlStateNormal];
        [_whatOneKeyBtn addTarget:self action:@selector(zeroStart:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_whatOneKeyBtn];
        [_whatOneKeyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(52);
            make.right.equalTo(self).offset(-52);
            make.height.equalTo(@(25));
            make.bottom.equalTo(self.mas_bottom).offset(-50);
        }];
    }
    return _whatOneKeyBtn;
}

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.text = @"我懒，不想自己做？也可以:";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:13];
        _label.textColor = XWColorFromHex(0xe7bb8c);
        [_label sizeToFit];
        [self addSubview:_label];
        _label.size = CGSizeMake(200, 25);
        _label.alpha = 0;
        _label.centerX = self.centerX;
        _label.y = self.height;
//        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.mas_centerX);
//            make.top.equalTo(self.mas_bottom);
//            make.size.mas_equalTo(_label.size);
//        }];
    }
    return _label;
}

@end
