//
//  BudgetDetailsTabbleHeader.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/22.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BudgetDetailsTabbleHeader.h"
#import "MoneyMenu.h"
#import "OneClassMenus.h"
#import "Budgetpro.h"
#import "NSString+Common.h"

@interface BudgetDetailsTabbleHeader()


@property (nonatomic, retain) UIImageView *imageVBg;
@property (nonatomic, retain) UILabel *titleView;
@property (nonatomic, retain) UILabel *moneyIcon;
@property (nonatomic, retain) UILabel *proamountLabelView;
@property (nonatomic, retain) UIView *line;

@property (nonatomic, retain) MoneyMenu *budgetamount;//期望总价
@property (nonatomic, retain) MoneyMenu *proprice;//期望单价价
@property (nonatomic, retain) MoneyMenu *budgetprice;//预算单价价
@property (nonatomic, retain) MoneyMenu *priceDifference;//差值



@end


@implementation BudgetDetailsTabbleHeader
//budgetDetails_TabkeBg

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self imageVBg];
        [self titleView];
        [self proamountLabelView];
        [self moneyIcon];
        
        [self budgetamount];
        [self proprice];
        [self budgetprice];
        [self priceDifference];
        [self oneClassMenus];
        [self line];
        
    }
    return self;
}


-(void)setBudgetpro:(Budgetpro *)budgetpro{
    _budgetpro = budgetpro;
    _oneClassMenus.btnDatas = budgetpro.cateoneList;
    
    _proamountLabelView.text = [NSString strmethodComma:[NSString stringWithFormat:@"%.0f",budgetpro.budgetproamount / 100.0f]];
    [_proamountLabelView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([_proamountLabelView sizeThatFits:CGSizeMake(20, 40)]);
        make.top.equalTo(_titleView.mas_bottom).offset(0);
        make.centerX.equalTo(_titleView.mas_centerX);
    }];
    _budgetamount.moneyView.text = [self moneyFormat:[NSString strmethodComma:[NSString stringWithFormat:@"%.0f",budgetpro.budgetamount / 100.0f]]] ;
    _proprice.moneyView.text = [NSString stringWithFormat:@"%@/m²",[self moneyFormat:[NSString stringWithFormat:@"%.0f",budgetpro.proprice / 100.0f]]];
//    _proprice.moneyView.text = [self moneyFormat:[NSString stringWithFormat:@"%.0f/m²",budgetpro.proprice]] ;
    _budgetprice.moneyView.text = [NSString stringWithFormat:@"%@/m²",[self moneyFormat:[NSString stringWithFormat:@"%.0f",budgetpro.budgetprice / 100.0f]]];
//    _budgetprice.moneyView.text = [self moneyFormat:[NSString stringWithFormat:@"%.0f/m²",budgetpro.budgetprice]] ;
    _priceDifference.moneyView.text = [NSString stringWithFormat:@"¥%@",[NSString strmethodComma:[NSString stringWithFormat:@"%.0f",fabs(budgetpro.priceDifference / 100.0f)]]];
    if (budgetpro.priceDifference < 0) {
        _priceDifference.titleView.backgroundColor = XWColorFromHex(0xee2f2b);
        _priceDifference.titleView.text = @"超支";
    }else{
        _priceDifference.titleView.backgroundColor = XWColorFromHex(0x11c354);
        _priceDifference.titleView.text = @"节省";
    }
    
    
    [_budgetpro addObserver:self forKeyPath:@"budgetproamount" options:(NSKeyValueObservingOptionNew) context:nil];
    [_budgetpro addObserver:self forKeyPath:@"budgetamount" options:(NSKeyValueObservingOptionNew) context:nil];
    [_budgetpro addObserver:self forKeyPath:@"proprice" options:(NSKeyValueObservingOptionNew) context:nil];
    [_budgetpro addObserver:self forKeyPath:@"budgetprice" options:(NSKeyValueObservingOptionNew) context:nil];
    [_budgetpro addObserver:self forKeyPath:@"priceDifference" options:(NSKeyValueObservingOptionNew) context:nil];
    
}
//  KVO 监听值变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    
    if ([keyPath isEqualToString:@"budgetproamount"]) {
        _proamountLabelView.text = [NSString strmethodComma:[NSString stringWithFormat:@"%.0f",[[change valueForKey:NSKeyValueChangeNewKey] floatValue] / 100.0f]];
        [_proamountLabelView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo([_proamountLabelView sizeThatFits:CGSizeMake(20, 40)]);
            make.top.equalTo(_titleView.mas_bottom).offset(0);
            make.centerX.equalTo(_titleView.mas_centerX);
        }];
    }
    if ([keyPath isEqualToString:@"budgetamount"]) {
        _budgetamount.moneyView.text = [self moneyFormat:[NSString strmethodComma:[NSString stringWithFormat:@"%.0f",[[change valueForKey:NSKeyValueChangeNewKey] floatValue] / 100.0f]]];
    }
    if ([keyPath isEqualToString:@"proprice"]) {
        _proprice.moneyView.text = [NSString stringWithFormat:@"%@/m²",[self moneyFormat:[NSString stringWithFormat:@"%.0f",[[change valueForKey:NSKeyValueChangeNewKey] floatValue] / 100.0f]]];
//        _proprice.moneyView.text = [self moneyFormat:[NSString stringWithFormat:@"%.0f/m²",[[change valueForKey:NSKeyValueChangeNewKey] floatValue]]];
    }
    if ([keyPath isEqualToString:@"budgetprice"]) {
        _budgetprice.moneyView.text = [NSString stringWithFormat:@"%@/m²",[self moneyFormat:[NSString stringWithFormat:@"%.0f",[[change valueForKey:NSKeyValueChangeNewKey] floatValue] / 100.0f]] ];
//        _budgetprice.moneyView.text = [self moneyFormat:[NSString stringWithFormat:@"%.0f/m²",[[change valueForKey:NSKeyValueChangeNewKey] floatValue]]] ;
    }
    if ([keyPath isEqualToString:@"priceDifference"]) {
        _priceDifference.moneyView.text = [NSString stringWithFormat:@"¥%@",[NSString strmethodComma:[NSString stringWithFormat:@"%.0f",fabsf([[change valueForKey:NSKeyValueChangeNewKey] floatValue] / 100.0f)]]];
        if ([[change valueForKey:NSKeyValueChangeNewKey] floatValue] < 0) {
            _priceDifference.titleView.backgroundColor = XWColorFromHex(0xee2f2b);
            _priceDifference.titleView.text = @"超支";
        }else{
            _priceDifference.titleView.backgroundColor = XWColorFromHex(0x11c354);
            _priceDifference.titleView.text = @"节省";
        }
    }
}

-(void)dealloc{
    [_budgetpro removeObserver:self forKeyPath:@"budgetamount" context:nil];
    [_budgetpro removeObserver:self forKeyPath:@"budgetproamount" context:nil];
    [_budgetpro removeObserver:self forKeyPath:@"proprice" context:nil];
    [_budgetpro removeObserver:self forKeyPath:@"budgetprice" context:nil];
    [_budgetpro removeObserver:self forKeyPath:@"priceDifference" context:nil];

}





#pragma mark - getters and setters
-(UILabel *)titleView{
    if (!_titleView) {
        _titleView = [[UILabel alloc]init];
        _titleView.text = @"预算总价";
        _titleView.textAlignment = NSTextAlignmentCenter;
        _titleView.textColor = kTitleAddHouseTitleCOLOR;
        _titleView.font = [UIFont systemFontOfSize:14 weight:10];
        [self addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            if (IphoneX) {
                make.top.equalTo(self).offset(73);
            } else {
                make.top.equalTo(self).offset(43);
            }
            make.height.equalTo(@(20));
        }];
    }
    return _titleView;
}



-(UILabel *)proamountLabelView{
    if (!_proamountLabelView) {
        _proamountLabelView = [[UILabel alloc]init];
        _proamountLabelView.text = @"5442898989797979762";
        _proamountLabelView.textColor = XWColorFromHex(0x44444b);
        _proamountLabelView.textAlignment = NSTextAlignmentCenter;
        _proamountLabelView.font = [UIFont systemFontOfSize:25 weight:10];
        [self addSubview:_proamountLabelView];
        [_proamountLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo([_proamountLabelView sizeThatFits:CGSizeMake(20, 40)]);
            make.top.equalTo(_titleView.mas_bottom).offset(0);
            make.centerX.equalTo(_titleView.mas_centerX);
        }];
    }
    return _titleView;
}


-(UILabel *)moneyIcon{
    if (!_moneyIcon) {
        _moneyIcon = [[UILabel alloc]init];
        _moneyIcon.text = @"544262";
        _moneyIcon.textColor = XWColorFromHex(0x44444b);
        _moneyIcon.textAlignment = NSTextAlignmentCenter;
        _moneyIcon.font = [UIFont systemFontOfSize:18];
        _moneyIcon.text = @"¥";
        [_moneyIcon sizeToFit];
        [self addSubview:_moneyIcon];
        [_moneyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_proamountLabelView.mas_left).offset(-3);
            make.bottom.equalTo(_proamountLabelView.mas_bottom).offset(0);
            make.size.mas_equalTo(_moneyIcon.size);
        }];
    }
    return _moneyIcon;
}


-(UIImageView *)imageVBg{
    if (!_imageVBg) {
        UIImage *image = [UIImage imageNamed:@"budgetDetails_TabkeBg"];
        _imageVBg = [[UIImageView alloc]init];
        _imageVBg.image = image;
        _imageVBg.contentMode = UIViewContentModeScaleAspectFill;
        
        
        UIImage *imageBt = [UIImage imageNamed:@"budgetDetails_TabkeBgBt"];
        UIImageView *imageVBgBt = [[UIImageView alloc]init];
        imageVBgBt.image = imageBt;
        imageVBgBt.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageVBg];
        [_imageVBg addSubview:imageVBgBt];
        [imageVBgBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_imageVBg);
            make.bottom.equalTo(_imageVBg.mas_bottom);
            make.height.equalTo(@(imageBt.size.height));
        }];
        [_imageVBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.equalTo(@(kRKBHEIGHT(170)));
        }];
    }
    return _imageVBg;
}



-(MoneyMenu *)budgetamount{
    
    if (!_budgetamount) {
        _budgetamount = [[MoneyMenu alloc]initWithTitle:@"期望总价" Money:@"0" ShowLine:YES];
        _budgetamount.titleView.backgroundColor = [UIColor clearColor];
        _budgetamount.titleView.textColor = kTitleAddHouseCOLOR;
        [self addSubview:_budgetamount];
        [_budgetamount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kScreen_Width/4));
            make.height.equalTo(@(35));
            make.left.equalTo(self);
            make.bottom.equalTo(_imageVBg.mas_bottom).offset(-25);
        }];
    }
    return _budgetamount;
}
-(MoneyMenu *)proprice{
    
    if (!_proprice) {
        _proprice = [[MoneyMenu alloc]initWithTitle:@"期望单价" Money:@"0" ShowLine:YES];
        _proprice.titleView.backgroundColor = [UIColor clearColor];
        _proprice.titleView.textColor = kTitleAddHouseCOLOR;
        [self addSubview:_proprice];
        [_proprice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kScreen_Width/4));
            make.height.equalTo(@(35));
            make.left.equalTo(_budgetamount.mas_right);
            make.bottom.equalTo(_imageVBg.mas_bottom).offset(-25);
        }];
    }
    return _proprice;
}
-(MoneyMenu *)budgetprice{
    
    if (!_budgetprice) {
        _budgetprice = [[MoneyMenu alloc]initWithTitle:@"预算单价" Money:@"0" Icon:[UIImage imageNamed:@"Bui_icon"] ShowLine:YES];
        _budgetprice.titleView.backgroundColor = [UIColor clearColor];
        _budgetprice.titleView.textColor = kTitleAddHouseCOLOR;
        [self addSubview:_budgetprice];
        [_budgetprice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kScreen_Width/4));
            make.height.equalTo(@(35));
            make.left.equalTo(_proprice.mas_right);
            make.bottom.equalTo(_imageVBg.mas_bottom).offset(-25);
        }];
    }
    return _budgetprice;
}
-(MoneyMenu *)priceDifference{
    
    if (!_priceDifference) {
        _priceDifference = [[MoneyMenu alloc]initWithTitle:@"超支" Money:@"0" ShowLine:NO];
        _priceDifference.titleView.backgroundColor = XWColorFromHex(0xee2f2b);
        _priceDifference.titleView.textColor = XWColorFromHex(0xfbe7d4);
        [self addSubview:_priceDifference];
        [_priceDifference mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kScreen_Width/4));
            make.height.equalTo(@(35));
            make.left.equalTo(_budgetprice.mas_right);
            make.bottom.equalTo(_imageVBg.mas_bottom).offset(-25);
        }];
    }
    return _priceDifference;
}


-(OneClassMenus *)oneClassMenus{
    
    if (!_oneClassMenus) {
        _oneClassMenus = [[OneClassMenus alloc]init];
        _oneClassMenus.frame = CGRectMake(15, kRKBHEIGHT(173), kScreen_Width-30, kRKBHEIGHT(90));
        [self addSubview:_oneClassMenus];
    }
    return _oneClassMenus;
}

-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = XWColorFromHex(0xdbdbdb);
        [self addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(@(0.5));
        }];
    }
    return _line;
}



// 千分位有小数点
- (NSString *)moneyFormat:(NSString *)money{
    NSArray *moneys = [money componentsSeparatedByString:@"."];
    if (moneys.count > 2) {
        return money;
    }
    else if (moneys.count < 2) {
        return [self stringFormatToThreeBit:money];
    }
    else {
        NSString *frontMoney = [self stringFormatToThreeBit:moneys[0]];
        if([frontMoney isEqualToString:@""]){
            frontMoney = @"0";
        }
        return [NSString stringWithFormat:@"%@.%@", frontMoney,moneys[1]];
    }
}

// 千分位无小数点
- (NSString *)stringFormatToThreeBit:(NSString *)string{
    if (string.length <= 0) {
        return @"".mutableCopy;
    }
    
    NSString *tempRemoveD = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSMutableString *stringM = [NSMutableString stringWithString:tempRemoveD];
    NSInteger n = 2;
    for (NSInteger i = tempRemoveD.length - 3; i > 0; i--) {
        n++;
        if (n == 3) {
            [stringM insertString:@"," atIndex:i];
            n = 0;
        }
    }
    
    return stringM;
}

@end
