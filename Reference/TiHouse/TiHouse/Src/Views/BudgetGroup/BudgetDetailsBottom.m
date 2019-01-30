//
//  BudgetDetailsBottom.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BudgetDetailsBottom.h"
#import "Budgetpro.h"
@interface BudgetDetailsBottom()

@property (nonatomic, retain) UILabel *titleView;
@property (nonatomic, retain) UILabel *moneyIcon;

@end

@implementation BudgetDetailsBottom


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = XWColorFromHex(0x44444b);
        [self titleView];
        [self moneyIcon];
        [self moneyView];
        [self savesBtn];
    }
    return self;
}




#pragma mark - getters and setters

-(void)setBudgetpro:(Budgetpro *)budgetpro{
    _budgetpro = budgetpro;
    _moneyView.text = [NSString strmethodComma:[NSString stringWithFormat:@"%.0f",budgetpro.budgetproamount / 100.0f]];
    [_budgetpro addObserver:self forKeyPath:@"budgetproamount" options:(NSKeyValueObservingOptionNew) context:nil];
    CGSize size = [_moneyView sizeThatFits:CGSizeMake(20, 20)];
    [_moneyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_moneyIcon.mas_right);
        make.top.equalTo(_titleView.mas_bottom).offset(0);
        make.size.mas_equalTo(size);
    }];
    
}
//  KVO 监听值变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"budgetproamount"]) {
        _moneyView.text = [NSString strmethodComma:[NSString stringWithFormat:@"%.0f",[[change valueForKey:NSKeyValueChangeNewKey] floatValue] / 100.0f]];
        CGSize size = [_moneyView sizeThatFits:CGSizeMake(20, 20)];
        [_moneyView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_moneyIcon.mas_right);
            make.top.equalTo(_titleView.mas_bottom).offset(0);
            make.size.mas_equalTo(size);
        }];
    }
}


-(void)dealloc{
    [_budgetpro removeObserver:self forKeyPath:@"budgetproamount" context:nil];
}


-(UIButton *)savesBtn{
    if (!_savesBtn) {
        _savesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _savesBtn.backgroundColor = XWColorFromHex(0xfdf086);
        [_savesBtn setTitle:@"完成编辑" forState:UIControlStateNormal];
        [_savesBtn setTitleColor:XWColorFromHex(0x44444b) forState:UIControlStateNormal];
        _savesBtn.titleLabel.font = [UIFont systemFontOfSize:20 weight:10];
        [self addSubview:_savesBtn];
        [_savesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
            make.height.equalTo(@(50));
            make.width.equalTo(@(140));
        }];
    }
    return _savesBtn;
}


-(UILabel *)titleView{
    if (!_titleView) {
        _titleView = [[UILabel alloc]init];
        _titleView.textColor = XWColorFromHex(0x909090);
        _titleView.font = [UIFont systemFontOfSize:11];
        _titleView.text = @"当前预算总价";
        [_titleView sizeToFit];
        [self addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(8);
            make.top.equalTo(self).offset(10);
            make.height.equalTo(@(40));
            make.size.mas_equalTo(_titleView.size);
        }];
    }
    return _titleView;
}
-(UILabel *)moneyIcon{
    if (!_moneyIcon) {
        _moneyIcon = [[UILabel alloc]init];
        _moneyIcon.textColor = [UIColor whiteColor];
        _moneyIcon.text = @"¥";
        _moneyIcon.font = [UIFont systemFontOfSize:11];
        [_moneyIcon sizeToFit];
        [self addSubview:_moneyIcon];
        [_moneyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(_titleView.mas_bottom).offset(0);
            make.size.mas_equalTo(_moneyIcon.size);
        }];
    }
    return _moneyView;
}

-(UILabel *)moneyView{
    if (!_moneyView) {
        _moneyView = [[UILabel alloc]init];
        _moneyView.textColor = [UIColor whiteColor];
        _moneyView.text = @"1";
        _moneyView.font = [UIFont systemFontOfSize:20 weight:10];
        [_moneyView sizeToFit];
        [self addSubview:_moneyView];
        [_moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_moneyIcon.mas_right);
            make.top.equalTo(_titleView.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(_titleView.size.width, _titleView.size.height+6));
        }];
        [_moneyIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.bottom.equalTo(_moneyView.mas_bottom).offset(-2);
            make.size.mas_equalTo(_moneyIcon.size);
        }];
    }
    return _moneyView;
}


@end
