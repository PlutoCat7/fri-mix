//
//  oneMuneBtn.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/25.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "oneMuneBtn.h"
@interface oneMuneBtn()

@end
@implementation oneMuneBtn

-(instancetype)init{
    
    if (self = [super init]) {
        
        [self iconViw];
        [self titleView];
        [self moneyView];
    }
    return self;
}

-(void)layoutSubview{
    [super layoutSubviews];
    
//    [_iconViw mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(self.width, self.width));
//    }];
//
//    [_titleView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_iconViw.mas_bottom).offset(0);
//        make.centerX.equalTo(@(self.width/2));
//        make.size.mas_equalTo(_titleView.size);
//    }];
//
//    [_moneyView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_titleView.mas_bottom).offset(0);
//        make.centerX.equalTo(_titleView.mas_centerX);
//        make.size.mas_equalTo(_moneyView.size);
//    }];
    
//    [self layoutIfNeeded];

}

-(void)setOneClass:(BudgetOneClass *)OneClass{
    _OneClass = OneClass;
    _titleView.text = [NSString stringWithFormat:@"%@%0.f%%",OneClass.cateonename,OneClass.percentage*100];
    [_titleView sizeToFit];
    _moneyView.text = [NSString stringWithFormat:@"¥%.1f万",OneClass.oneAmount/10000 / 100.0f];
    [_moneyView sizeToFit];
    [_iconViw sd_setImageWithURL:[NSURL URLWithString:_OneClass.urlicon] placeholderImage:[UIImage imageNamed:@"88"]];
    
    [_OneClass addObserver:self forKeyPath:@"percentage" options:(NSKeyValueObservingOptionNew) context:nil];
    [_OneClass addObserver:self forKeyPath:@"oneAmount" options:(NSKeyValueObservingOptionNew) context:nil];

    
    XWLog(@"%@======mmmm======%@",OneClass,_OneClass);
    
    [self layoutSubviews];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"percentage"]) {
        _titleView.text = [NSString stringWithFormat:@"%@%0.f%%",_OneClass.cateonename,[[change valueForKey:NSKeyValueChangeNewKey] floatValue]*100];
    }
    if ([keyPath isEqualToString:@"oneAmount"]) {
        _moneyView.text = [NSString stringWithFormat:@"¥%.1f万",[[change valueForKey:NSKeyValueChangeNewKey] floatValue]/10000 / 100.0f];
    }
    
}


-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        _titleView.textColor = XWColorFromHex(0xfec00c);
        _moneyView.textColor = XWColorFromHex(0xfec00c);
    }else{
        _titleView.textColor = kColor666;
        _moneyView.textColor = kColor333;
    }
}


-(UIImageView *)iconViw{
    if (!_iconViw) {
        _iconViw = [[UIImageView alloc]init];
        _iconViw.contentMode = UIViewContentModeScaleAspectFit;
        _iconViw.image = [UIImage imageNamed:@"88"];
        _iconViw.clipsToBounds = YES;
        [self addSubview:_iconViw];
        [_iconViw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kRKBWIDTH(50), kRKBWIDTH(50)));
        }];
    }
    return _iconViw;
}

-(UILabel *)titleView{
    if (!_titleView) {
        _titleView = [[UILabel alloc]init];
        _titleView.textColor = kColor666;
        _titleView.font = [UIFont systemFontOfSize:10];
        _titleView.adjustsFontSizeToFitWidth = YES;
        _titleView.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_iconViw.mas_bottom).offset(3);
            make.centerX.equalTo(@(self.width/2));
            make.size.mas_equalTo(CGSizeMake(kRKBWIDTH(50), 15));
        }];
    }
    return _titleView;
}

-(UILabel *)moneyView{
    if (!_moneyView) {
        _moneyView = [[UILabel alloc]init];
        _moneyView.font = [UIFont systemFontOfSize:11 weight:10];
        _moneyView.textColor = kColor333;
        _moneyView.adjustsFontSizeToFitWidth = YES;
        _moneyView.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_moneyView];
        [_moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleView.mas_bottom).offset(0);
            make.centerX.equalTo(@(self.width/2));
            make.size.mas_equalTo(CGSizeMake(kRKBWIDTH(50), 15));
        }];
    }
    return _moneyView;
}


-(void)dealloc{
    [_OneClass removeObserver:self forKeyPath:@"percentage" context:nil];
    [_OneClass removeObserver:self forKeyPath:@"oneAmount" context:nil];
}


@end
