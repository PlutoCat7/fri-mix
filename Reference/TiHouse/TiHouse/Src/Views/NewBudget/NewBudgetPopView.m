//
//  NewBudgetPopView.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/24.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "NewBudgetPopView.h"

#define kBoarderHeight 840/2/2

@interface NewBudgetPopView()

@property (nonatomic, retain) UIImageView *imageV;
@property (nonatomic, retain) UIButton *iKnowBtn;

@property (nonatomic, retain) UIButton *economicBtn;//经济
@property (nonatomic, retain) UIButton *comfortBtn;//舒适
@property (nonatomic, retain) UIButton *qualityBtn;//品质
@property (nonatomic, retain) UIButton *extravagantBtn;//轻奢

@end

@implementation NewBudgetPopView

-(instancetype)initWithType:(NewBudgetPopTyoe)type{
    if (self = [super initWithFrame:kScreen_Bounds]) {
//        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _type = type;
        [self imageV];
        if (type == NewBudgetPopTyoeWhatOneKye || type == NewBudgetPopTyoeAssess) {
            [self iKnowBtn];
        }else{
            [self economicBtn];
            [self comfortBtn];
            [self qualityBtn];
            [self extravagantBtn];
        }
    }
    return self;
}

#pragma mark - event response
-(void)Show{
    
    [UIView animateWithDuration: 0.6 delay:0.1f usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:0 animations:^{
        if (_type == NewBudgetPopTyoeOneKye) {
            _imageV.y = self.centerY - kBoarderHeight;
        }else{
            _imageV.y = 125;
        }
    } completion:nil];
    
}

-(void)close{
    [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        _imageV.y = kScreen_Height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)oneKye:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(NewBudgetWithStyle:)]) {
        [self.delegate NewBudgetWithStyle:btn.tag];
    }
    [self close];
}

#pragma mark - getters and setters
-(UIImageView *)imageV{
    if (!_imageV) {
        UIImage *image = [UIImage new];
        if (_type == NewBudgetPopTyoeOneKye) {
            image = [UIImage imageNamed:@"bk"];
        }else if(_type == NewBudgetPopTyoeAssess){
            image = [UIImage imageNamed:@"Assess_pop"];
        }else{
            image = [UIImage imageNamed:@"whatOneKey_pop"];
        }
        _imageV = [[UIImageView alloc]init];
        _imageV.contentMode = UIViewContentModeTop;
        _imageV.image = image;
        [self addSubview:_imageV];
        _imageV.size = image.size;
        _imageV.height = image.size.height + 75;
        _imageV.centerX = self.centerX;
        _imageV.y = -kScreen_Height;
        _imageV.userInteractionEnabled = YES;
        
        UIImage *closeImage = [UIImage imageNamed:@"budget_ close"];
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.size = closeImage.size;
        closeBtn.y = _imageV.height-closeImage.size.height;
        closeBtn.centerX = _imageV.width/2;
        [closeBtn setImage:closeImage forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_imageV addSubview:closeBtn];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(closeBtn.centerX, image.size.height, 0.5, closeBtn.y - image.size.height)];
        line.backgroundColor = [UIColor whiteColor];
        [_imageV addSubview:line];
        
    }
    return _imageV;
}

-(UIButton *)comfortBtn{
    if (!_comfortBtn) {
        _comfortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comfortBtn setImage:[UIImage imageNamed:@"ss"] forState:UIControlStateNormal];
        [_comfortBtn setImage:[UIImage imageNamed:@"ss"] forState:UIControlStateHighlighted];
        _comfortBtn.tag = NewBudgetStyleComfort;
        [_comfortBtn addTarget:self action:@selector(oneKye:) forControlEvents:UIControlEventTouchUpInside];
        [_imageV addSubview:_comfortBtn];
        [_comfortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imageV);
            make.height.equalTo(@(65));
            make.top.equalTo(_economicBtn.mas_bottom).offset(20);
        }];
    }
    return _comfortBtn;
}

- (UIButton *)economicBtn
{
    if (!_economicBtn) {
        _economicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _economicBtn.tag = NewBudgetStyleEconomic;
        [_economicBtn setImage:[UIImage imageNamed:@"jj"] forState:UIControlStateNormal];
        [_economicBtn setImage:[UIImage imageNamed:@"jj"] forState:UIControlStateHighlighted];
        [_economicBtn addTarget:self action:@selector(oneKye:) forControlEvents:UIControlEventTouchUpInside];
        [_imageV addSubview:_economicBtn];
        [_economicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imageV);
            make.height.equalTo(@(65));
            make.top.equalTo(_imageV).offset(75);
        }];
    }
    return _qualityBtn;
}

-(UIButton *)qualityBtn{
    if (!_qualityBtn) {
        _qualityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qualityBtn setImage:[UIImage imageNamed:@"pz"] forState:UIControlStateNormal];
        [_qualityBtn setImage:[UIImage imageNamed:@"pz"] forState:UIControlStateHighlighted];
        _qualityBtn.tag = NewBudgetStyleQuality;
        [_qualityBtn addTarget:self action:@selector(oneKye:) forControlEvents:UIControlEventTouchUpInside];
        [_imageV addSubview:_qualityBtn];
        [_qualityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imageV);
            make.height.equalTo(@(65));
            make.top.equalTo(_comfortBtn.mas_bottom).offset(20);
        }];
    }
    return _qualityBtn;
    
}
-(UIButton *)extravagantBtn{
    if (!_extravagantBtn) {
        _extravagantBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_extravagantBtn setImage:[UIImage imageNamed:@"qs.jpg"] forState:UIControlStateNormal];
        [_extravagantBtn setImage:[UIImage imageNamed:@"qs.jpg"] forState:UIControlStateHighlighted];
        _extravagantBtn.tag = NewBudgetStyleExtravagant;
        [_extravagantBtn addTarget:self action:@selector(oneKye:) forControlEvents:UIControlEventTouchUpInside];
        [_imageV addSubview:_extravagantBtn];
        [_extravagantBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imageV);
            make.height.equalTo(@(65));
            make.top.equalTo(_qualityBtn.mas_bottom).offset(20);
        }];
    }
    return _extravagantBtn;
    
}

-(UIButton *)iKnowBtn{
    if (!_iKnowBtn) {
        _iKnowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _iKnowBtn.backgroundColor = XWColorFromHex(0xfec00c);
        [_iKnowBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        _iKnowBtn.layer.cornerRadius = 25;
        [_iKnowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_iKnowBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_imageV addSubview:_iKnowBtn];
        [_iKnowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageV).offset(32);
            make.right.equalTo(_imageV).offset(-32);
            make.height.equalTo(@(50));
            make.bottom.equalTo(@(_iKnowBtn.height-75-27));
        }];
    }
    return _iKnowBtn;
    
}



@end
