//
//  screenPopView.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScreenPopView.h"
#import "Budgetpro.h"
@interface ScreenPopView()

@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIView *line;
@property (nonatomic, retain) UILabel *titleView;
@property (nonatomic, retain) UIButton *buyBtn;
@property (nonatomic, retain) UIButton *moneyBtn;
@property (nonatomic, retain) UIButton *resetBtn;
@property (nonatomic, retain) UIButton *goBtn;
@property (nonatomic, retain) UIImageView *buyBtnImage;
@property (nonatomic, retain) UIImageView *moneyBtnImage;
@property (nonatomic, assign) BOOL selectBuy;
@property (nonatomic, assign) BOOL selectMoney;

@end

@implementation ScreenPopView

-(instancetype)init{
    
    if (self = [super initWithFrame:kScreen_Bounds]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self contentView];
        [self goBtn];
        [self resetBtn];
        [self titleView];
        [self line];
        [self moneyBtn];
        [self buyBtn];
        _selectBuy = NO;
        _selectMoney = NO;
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


-(void)setBudgetpro:(Budgetpro *)budgetpro{
    _budgetpro = budgetpro;
    _buyBtnImage.hidden = !budgetpro.selectBuy;
    if (_buyBtnImage.hidden) {
        _buyBtn.layer.borderColor = XWColorFromHex(0xa5a4a4).CGColor;
        [_buyBtn setTitleColor:XWColorFromHex(0xa5a4a4) forState:UIControlStateNormal];
        [_buyBtn setImage:[UIImage imageNamed:@"buyIcon_nu"] forState:UIControlStateNormal];
    }else{
        _buyBtn.layer.borderColor = XWColorFromHex(0xfec00c).CGColor;
        [_buyBtn setTitleColor:XWColorFromHex(0xfec00c) forState:UIControlStateNormal];
        [_buyBtn setImage:[UIImage imageNamed:@"buyIcon"] forState:UIControlStateNormal];
    }
    _buyBtn.selected = budgetpro.selectBuy;
    _moneyBtnImage.hidden = !budgetpro.selectMoney;
    _buyBtnImage.hidden = !budgetpro.selectBuy;
    if (_moneyBtnImage.hidden) {
        _moneyBtn.layer.borderColor = XWColorFromHex(0xa5a4a4).CGColor;
        [_moneyBtn setTitleColor:XWColorFromHex(0xa5a4a4) forState:UIControlStateNormal];
        [_moneyBtn setImage:[UIImage imageNamed:@"moey_icon_nu"] forState:UIControlStateNormal];
    }else{
        _moneyBtn.layer.borderColor = XWColorFromHex(0x11c354).CGColor;
        [_moneyBtn setTitleColor:XWColorFromHex(0x11c354) forState:UIControlStateNormal];
        [_moneyBtn setImage:[UIImage imageNamed:@"moey_icon"] forState:UIControlStateNormal];
    }
    _moneyBtn.selected = budgetpro.selectMoney;
}




-(UIView *)contentView{
    
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 200)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
    }
    return _contentView;
}


-(UIButton *)resetBtn{
    if (!_resetBtn) {
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        _resetBtn.frame = CGRectMake(0, _contentView.height-50, _contentView.width/2, 50);
        [_resetBtn setTitleColor:XWColorFromHex(0x606060) forState:UIControlStateNormal];
        _resetBtn.backgroundColor = XWColorFromHex(0xa5a4a4);
        [_resetBtn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_resetBtn];
    }
    return _resetBtn;
}

-(UILabel *)titleView{
    if (!_titleView) {
        _titleView = [[UILabel alloc]init];
        _titleView.textColor = kColor333;
        _titleView.text = @"筛选";
        _titleView.textAlignment = NSTextAlignmentCenter;
        _titleView.font = [UIFont systemFontOfSize:18 weight:20];
        _titleView.frame = CGRectMake(0, 0, self.width, 50);
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 50, self.width, 0.5)];
        line.backgroundColor = kLineColer;
        [_titleView addSubview:line];
        [_contentView addSubview:_titleView];
    }
    return _titleView;
}


-(UIButton *)goBtn{
    if (!_goBtn) {
        _goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goBtn setTitle:@"确定" forState:UIControlStateNormal];
        _goBtn.frame = CGRectMake(_contentView.width/2, _contentView.height-50, _contentView.width/2, 50);
        [_goBtn setTitleColor:XWColorFromHex(0x606060) forState:UIControlStateNormal];
        _goBtn.backgroundColor = XWColorFromHex(0xfdf086);
        [_goBtn addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_goBtn];
    }
    return _goBtn;
}

-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(_contentView.width/2, CGRectGetMaxY(_titleView.frame)+30, 0.5, 40)];
        _line.backgroundColor = kLineColer;
        [_contentView addSubview:_line];
    }
    return _line;
}


-(UIButton *)buyBtn{
    if (!_buyBtn) {
        UIImage *image = [UIImage imageNamed:@"buyIcon"];
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyBtn setImage:image forState:UIControlStateNormal];
        [_buyBtn setTitle:@"显示所有星标项目" forState:UIControlStateNormal];
        _buyBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_buyBtn setTitleColor:XWColorFromHex(0xfec00c) forState:UIControlStateNormal];
        _buyBtn.frame = CGRectMake(0, CGRectGetMaxY(_titleView.frame)+30, kRKBWIDTH(130), 40);
        _buyBtn.imageEdgeInsets = UIEdgeInsetsMake(13, _buyBtn.imageView.x+5, 12, 100);
        _buyBtn.right = _contentView.width/2-25;
        _buyBtn.titleLabel.textColor = kColor333;
        _buyBtn.layer.cornerRadius = 3;
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _buyBtn.backgroundColor = XWColorFromHex(0xfcfcfc);
        _buyBtn.layer.borderColor = XWColorFromHex(0xfec00c).CGColor;
        _buyBtn.layer.borderWidth = 1;
        _buyBtn.selected = NO;
        [_buyBtn addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_buyBtn];
        [self buyBtnImage];
    }
    return _buyBtn;
}

-(UIButton *)moneyBtn{
    if (!_moneyBtn) {
        UIImage *image = [UIImage imageNamed:@"moey_icon"];
        
        _moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moneyBtn setImage:image forState:UIControlStateNormal];
        [_moneyBtn setTitle:@"显示所有已购项目" forState:UIControlStateNormal];
        [_moneyBtn setTitleColor:XWColorFromHex(0x11c354) forState:UIControlStateNormal];
        _moneyBtn.frame = CGRectMake(_contentView.width/2+25, CGRectGetMaxY(_titleView.frame)+30, kRKBWIDTH(130), 40);
        _moneyBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _moneyBtn.imageEdgeInsets = UIEdgeInsetsMake(13, _moneyBtn.imageView.x+5, 12, 100);
        _moneyBtn.selected = NO;
        _moneyBtn.layer.cornerRadius = 3;
        _moneyBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _moneyBtn.backgroundColor = XWColorFromHex(0xfcfcfc);
        _moneyBtn.layer.borderColor = XWColorFromHex(0x11c354).CGColor;
        _moneyBtn.layer.borderWidth = 1;
        [_moneyBtn addTarget:self action:@selector(money:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_moneyBtn];
        [self moneyBtnImage];
    }
    return _moneyBtn;
}

-(UIImageView *)buyBtnImage{
    if (!_buyBtnImage) {
        UIImage *image = [UIImage imageNamed:@"buy_right"];
        _buyBtnImage = [[UIImageView alloc]init];
        _buyBtnImage.image = image;
        _buyBtnImage.hidden = YES;
        _buyBtnImage.contentMode = UIViewContentModeScaleAspectFit;
        [_buyBtn addSubview:_buyBtnImage];
        [_buyBtnImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_buyBtn.mas_right);
            make.bottom.equalTo(_buyBtn.mas_bottom);
            make.size.mas_equalTo(image.size);
        }];
    }
    return _buyBtnImage;
}

-(UIImageView *)moneyBtnImage{
    if (!_moneyBtnImage) {
        UIImage *image = [UIImage imageNamed:@"money_right"];
        _moneyBtnImage = [[UIImageView alloc]init];
        _moneyBtnImage.image = image;
        _moneyBtnImage.hidden = YES;
        _moneyBtnImage.contentMode = UIViewContentModeScaleAspectFit;
        _moneyBtnImage.size = image.size;
        _moneyBtnImage.bottom = _moneyBtn.height;
        _moneyBtnImage.right = _moneyBtn.width;
        [_moneyBtn addSubview:_moneyBtnImage];
    }
    return _moneyBtnImage;
}


#pragma mark - event response
-(void)go{
    if (_finishSelectde) {
        _finishSelectde(_selectBuy,_selectMoney);
    }
    [self close];
}

-(void)reset{
    _budgetpro.selectMoney = NO;
    _budgetpro.selectBuy = NO;
    self.budgetpro = _budgetpro;
}
-(void)buy:(UIButton *)btn{
    _budgetpro.selectBuy =_selectBuy = btn.selected = !btn.selected;
    if (btn.selected) {
        _buyBtnImage.hidden = NO;
    }else{
        _buyBtnImage.hidden = YES;
    }
    if (_buyBtnImage.hidden) {
        _buyBtn.layer.borderColor = XWColorFromHex(0xa5a4a4).CGColor;
        [_buyBtn setTitleColor:XWColorFromHex(0xa5a4a4) forState:UIControlStateNormal];
        [_buyBtn setImage:[UIImage imageNamed:@"buyIcon_nu"] forState:UIControlStateNormal];
    }else{
        _buyBtn.layer.borderColor = XWColorFromHex(0xfec00c).CGColor;
        [_buyBtn setTitleColor:XWColorFromHex(0xfec00c) forState:UIControlStateNormal];
        [_buyBtn setImage:[UIImage imageNamed:@"buyIcon"] forState:UIControlStateNormal];
    }
    
}
-(void)money:(UIButton *)btn{
   _budgetpro.selectMoney =_selectMoney = btn.selected = !btn.selected;
    if (btn.selected) {
        _moneyBtnImage.hidden = NO;
    }else{
        _moneyBtnImage.hidden = YES;
    }
    if (_moneyBtnImage.hidden) {
        _moneyBtn.layer.borderColor = XWColorFromHex(0xa5a4a4).CGColor;
        [_moneyBtn setTitleColor:XWColorFromHex(0xa5a4a4) forState:UIControlStateNormal];
        [_moneyBtn setImage:[UIImage imageNamed:@"moey_icon_nu"] forState:UIControlStateNormal];
    }else{
        _moneyBtn.layer.borderColor = XWColorFromHex(0x11c354).CGColor;
        [_moneyBtn setTitleColor:XWColorFromHex(0x11c354) forState:UIControlStateNormal];
        [_moneyBtn setImage:[UIImage imageNamed:@"moey_icon"] forState:UIControlStateNormal];
    }
}


#pragma mark - private methods 私有方法
-(void)Show{
    
    [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        _contentView.y = kScreen_Height-200;
    } completion:nil];
    
}

-(void)close{
    [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        _contentView.y = kScreen_Height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
