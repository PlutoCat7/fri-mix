//
//  AddHouseTableHeaderView.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/16.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "AddHouseTableHeaderView.h"

@interface AddHouseTableHeaderView()

@property (nonatomic , retain) UIImageView *Camera;//相机图标
//@property (nonatomic , retain) UILabel *HintTest;//提示语

@end

@implementation AddHouseTableHeaderView

-(instancetype)init{
    
    if (self = [super init]) {
        
        [self bgImageV];
        [self addSubview:self.HintTest];
        [self addSubview:self.Icon];
        [self addSubview:self.Camera];
        
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    [_HintTest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-25);
        make.right.left.equalTo(self);
        make.height.equalTo(@(15));
    }];
    
    [_Icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(68));
        make.width.equalTo(@(68));
        make.bottom.equalTo(_HintTest.mas_top).offset(-20);
    }];
    _Icon.layer.masksToBounds = YES;
    _Icon.layer.cornerRadius = 34;
    
//    _Icon.size = CGSizeMake(68, 68);
//    _Icon.center = self.center;
//    _Icon.centerY -= 6;
//    _Icon.layer.masksToBounds = YES;
//    _Icon.layer.cornerRadius = 34;
    
    [_Camera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_Icon.mas_bottom);
        make.centerX.equalTo(_Icon).offset(20);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    
}


-(UIImageView *)Icon{
    if (!_Icon) {
        _Icon = [[UIImageView alloc]init];
        _Icon.contentMode = UIViewContentModeScaleAspectFill;
        _Icon.layer.borderColor = [UIColor whiteColor].CGColor;
        _Icon.layer.borderWidth = 1.f;
        _Icon.image = [UIImage imageNamed:@"placeholderImage"];
        _Icon.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectorPhoto)];
        [_Icon addGestureRecognizer:tap];
        
    }
    return _Icon;
}

-(UIImageView *)Camera{
    if (!_Camera) {
        _Camera = [[UIImageView alloc]init];
        _Camera.contentMode = UIViewContentModeScaleAspectFit;
        _Camera.image = [UIImage imageNamed:@"Camera_icon"];
    }
    return _Camera;
}

-(UIImageView *)bgImageV{
    if (!_bgImageV) {
        _bgImageV = [[UIImageView alloc]init];
        _bgImageV.image = [UIImage imageNamed:@"housebg"];
        _bgImageV.userInteractionEnabled = YES;
        _bgImageV.contentMode = UIViewContentModeLeft | UIViewContentModeRight | UIViewContentModeBottom;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectorbgImage)];
        [_bgImageV addGestureRecognizer:tap];
        [self addSubview:_bgImageV];
        [_bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.right.left.equalTo(self);
            make.left.left.equalTo(self);
            make.width.equalTo(@(kScreen_Width));
            make.height.equalTo(@(kScreen_Width));
        }];
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width)];
        grayView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2];
        [_bgImageV addSubview:grayView];
    }
    return _bgImageV;
}

-(UILabel *)HintTest{
    if (!_HintTest) {
        _HintTest = [[UILabel alloc]init];
        _HintTest.text = @"点击设置房屋头像";
        _HintTest.font = [UIFont systemFontOfSize:12];
        _HintTest.textAlignment = NSTextAlignmentCenter;
        _HintTest.textColor = [UIColor whiteColor];
        _HintTest.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectorPhoto)];
        [_HintTest addGestureRecognizer:tap];
    }
    return _HintTest;
}


-(void)selectorPhoto{
    if (self.SelectPhoto) {
        self.SelectPhoto();
    }
}

-(void)selectorbgImage{
    if (self.SelectBgImage) {
        self.SelectBgImage();
    }
}


@end
