//
//  BottomBtnView.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BottomBtnView.h"
#import "BudgetThreeClass.h"

@interface BottomBtnView()

@property (nonatomic, retain) UIButton *buyBtn;
@property (nonatomic, retain) UIButton *moneyBtn;
@property (nonatomic, retain) UIButton *cancleBtn;
@property (nonatomic, retain) UIButton *finishBtn;

@end

@implementation BottomBtnView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self buyBtn];
        [self moneyBtn];
        [self cancleBtn];
        [self finishBtn];
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        line.backgroundColor = kLineColer;
        [self addSubview:line];
    }
    return self;
}

-(void)setThreeClass:(BudgetThreeClass *)threeClass{
    _threeClass = threeClass;
    _buyBtn.selected = threeClass.protypexb;
    _moneyBtn.selected = threeClass.protypeyg;
    
}



-(UIButton *)buyBtn{
    if (!_buyBtn) {
        UIImage *image = [UIImage imageNamed:@"buyIcon_nu"];
        UIImage *images = [UIImage imageNamed:@"buyIcon"];
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.backgroundColor = [UIColor whiteColor];
        [_buyBtn setImage:image forState:UIControlStateNormal];
        [_buyBtn setImage:images forState:UIControlStateSelected];
        [_buyBtn setTitle:@"设为星标项目" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:XWColorFromHex(0x5186aa) forState:UIControlStateNormal];
        _buyBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
        _buyBtn.frame = CGRectMake(0, 0, self.width/2, kRKBHEIGHT(60));
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _buyBtn.selected = NO;
        _buyBtn.tag = 1;
        [_buyBtn addTarget:self action:@selector(money:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_buyBtn];
    }
    return _buyBtn;
}

-(UIButton *)moneyBtn{
    if (!_moneyBtn) {
        UIImage *image = [UIImage imageNamed:@"moey_icon_nu"];
        UIImage *images = [UIImage imageNamed:@"moey_icon"];
        _moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moneyBtn.backgroundColor = [UIColor whiteColor];
        _moneyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_moneyBtn setImage:image forState:UIControlStateNormal];
        [_moneyBtn setImage:images forState:UIControlStateSelected];
        [_moneyBtn setTitle:@"设为已购项目" forState:UIControlStateNormal];
        [_moneyBtn setTitleColor:XWColorFromHex(0x5186aa) forState:UIControlStateNormal];
        _moneyBtn.frame = CGRectMake(self.width/2, 0, self.width/2, kRKBHEIGHT(60));
        _moneyBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
        [_moneyBtn addTarget:self action:@selector(money:) forControlEvents:UIControlEventTouchUpInside];
        _buyBtn.selected = NO;
        _moneyBtn.tag = 2;
        [self addSubview:_moneyBtn];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(_moneyBtn.x, _moneyBtn.y+10, 0.5, _moneyBtn.height-20)];
        line.backgroundColor = kLineColer;
        [self addSubview:line];
    }
    return _moneyBtn;
}

-(UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancleBtn.backgroundColor = XWColorFromHex(0xebebeb);
        [_cancleBtn setTitleColor:kTitleAddHouseTitleCOLOR forState:UIControlStateNormal];
        _cancleBtn.frame = CGRectMake(0, _moneyBtn.height, self.width/2, self.height - _moneyBtn.height);
        [_cancleBtn addTarget:self action:@selector(money:) forControlEvents:UIControlEventTouchUpInside];
        _cancleBtn.tag = 3;
        [self addSubview:_cancleBtn];
    }
    return _cancleBtn;
}

-(UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setTitle:@"确定" forState:UIControlStateNormal];
        _finishBtn.backgroundColor = XWColorFromHex(0xfdf086);
        [_finishBtn setTitleColor:kTitleAddHouseTitleCOLOR forState:UIControlStateNormal];
        _finishBtn.frame = CGRectMake(self.width/2, _moneyBtn.height, self.width/2, self.height - _moneyBtn.height);
        [_finishBtn addTarget:self action:@selector(money:) forControlEvents:UIControlEventTouchUpInside];
        _finishBtn.tag = 4;
        [self addSubview:_finishBtn];
    }
    return _finishBtn;
}

-(void)money:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (_SelectedBtn) {
        _SelectedBtn(btn.tag);
    }
}







@end
