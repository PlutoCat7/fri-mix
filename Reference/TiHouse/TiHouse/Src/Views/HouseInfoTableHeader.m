//
//  HouseInfoTableHeader.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/19.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "HouseInfoTableHeader.h"
#import "House.h"
@interface HouseInfoTableHeader()


@end

@implementation HouseInfoTableHeader

-(instancetype)init{
    if (self = [super init]) {
        //        self.masksToBounds = YES;
        [self backgroundImageView];
        UIView *bgColor = [UIView new];
        bgColor.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        bgColor.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editBtnClick)];
        [bgColor addGestureRecognizer:tap];
        [self addSubview:bgColor];
        [bgColor mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_backgroundImageView);
        }];
        
        [self icon];
        [self name];
        [self estate];
        //        [self editBtn];
        
        NSArray *muneArr = @[@"预算",@"账本",@"日程",@"云记录",@"亲友"];
        UIView *lastView = nil;
        for (int i = 0; i<muneArr.count; i++) {
            
            UIButton *muneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            muneBtn.tag = 10 + i;
            [muneBtn setTitle:muneArr[i] forState:UIControlStateNormal];
            muneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [muneBtn addTarget:self action:@selector(MuneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:muneBtn];
            [muneBtn sizeToFit];
            [muneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (lastView)
                {
                    make.left.mas_equalTo(lastView.mas_right);
                }
                else
                {
                    make.left.mas_equalTo(self.mas_left);
                }
                make.bottom.equalTo(self);
                make.height.equalTo(@(40));
                make.width.equalTo(@(muneBtn.width));
            }];
            //            muneBtn.frame = CGRectMake(CGRectGetMaxX(lastView.frame), 0, muneBtn.width, 40);
            lastView = muneBtn;
        }
        [self layoutIfNeeded];
        CGFloat padding = ((kScreen_Width-CGRectGetMaxX(lastView.frame))/6);
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(obj.width + padding));
                    if (obj.tag == 10) {
                        make.left.equalTo(@(padding/2));
                    }
                }];
                
                //                obj.x = padding*(obj.tag-9) + obj.x;
                //                [_BtnFramArr addObject:obj];
            }
        }];
        
        
    }
    return self;
}

-(void)setHouse:(House *)house{
    
    _house = house;
    UIButton *btn12 = [self viewWithTag:12];
    if (house.housepersonnumunreadrc > 0) {
        [btn12 addBadgePoint:4 withPointPosition:CGPointMake(CGRectGetMaxX(btn12.titleLabel.frame)+3, btn12.titleLabel.y+4)];
    }else{
        [btn12 removeBadgePoint];
    }

    UIButton *btn14 = [self viewWithTag:14];
    if (house.housepersonnumunreadqy > 0) {
        [btn14 addBadgePoint:4 withPointPosition:CGPointMake(CGRectGetMaxX(btn14.titleLabel.frame)+3, btn14.titleLabel.y+4)];
    }else{
        [btn14 removeBadgePoint];
    }
}


-(UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.textColor = [UIColor whiteColor];
        _name.font = [UIFont systemFontOfSize:19];
        _name.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editBtnClick)];
        [_name addGestureRecognizer:tap];
        [self addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_icon.mas_right).offset(10);
            make.top.equalTo(_icon).offset(0);
            make.width.equalTo(@(0));
            make.height.equalTo(@(30));
        }];
    }
    return _name;
}

-(UILabel *)estate{
    if (!_estate) {
        _estate = [[UILabel alloc]init];
        _estate.textColor = [UIColor whiteColor];
        _estate.font = [UIFont systemFontOfSize:13];
        _estate.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editBtnClick)];
        [_estate addGestureRecognizer:tap];
        [self addSubview:_estate];
        [_estate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_icon.mas_right).offset(10);
            make.top.equalTo(_name.mas_bottom).offset(0);
            make.right.equalTo(self);
            make.height.equalTo(@(20));
        }];
    }
    return _estate;
}

-(UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *icon = [UIImage imageNamed:@"edit_icon"];
        [_editBtn setImage:icon forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_editBtn];
        [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_name.mas_right).offset(10);
            make.centerY.equalTo(_name.mas_centerY);
            make.size.mas_equalTo(icon.size);
        }];
    }
    return _editBtn;
}


-(UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        
        
        _backgroundImageView = [[UIImageView alloc]init];
//        _backgroundImageView.image = [UIImage imageNamed:@"AddHouse_tabbelHeader_Bg"];
        _backgroundImageView.contentMode = UIViewContentModeLeft | UIViewContentModeRight | UIViewContentModeBottom;
        [self addSubview:_backgroundImageView];
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.right.left.equalTo(self);
            make.width.equalTo(@(kScreen_Width));
            make.height.equalTo(@(kScreen_Width));
        }];
        
//        _backgroundImageView = [[UIImageView alloc]init];
//        _backgroundImageView.contentMode =  UIViewContentModeLeft | UIViewContentModeRight | UIViewContentModeBottom;
//        [self addSubview:_backgroundImageView];
//        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@(-(kScreen_Width - self.height)));
//            make.left.bottom.right.equalTo(self);
//            make.height.equalTo(@(kScreen_Width));
//        }];
    }
    return _backgroundImageView;
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.contentMode = UIViewContentModeScaleAspectFill;
        _icon.layer.borderColor = [UIColor whiteColor].CGColor;
        _icon.layer.borderWidth = 1.0f;
        _icon.layer.cornerRadius = 56/2;
        _icon.layer.masksToBounds = YES;
        _icon.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconClick)];
        [_icon addGestureRecognizer:tap];
        [self addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.bottom.equalTo(self).offset(-57);
            make.size.mas_equalTo(CGSizeMake(56, 56));
        }];
    }
    return _icon;
}

-(void)setNameStr:(NSString *)nameStr{
    _nameStr = nameStr;
    _name.text = nameStr;
    [_name sizeToFit];
    [_name mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(_name.width));
    }];
}

-(void)editBtnClick{
    if (_editBlock) {
        _editBlock();
    }
}

-(void)iconClick{
    if (_iconBlock) {
        _iconBlock();
    }
}

-(void)MuneBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(HouseInfoTableMuneSelected:Index:)]) {
        [self.delegate HouseInfoTableMuneSelected:self Index:btn.tag-10];
    }
}

-(NSMutableArray *)getMuneBnts{
    
    __block NSMutableArray *btns = [NSMutableArray new];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [btns addObject:obj];
        }
    }];
    return btns;
}


@end

