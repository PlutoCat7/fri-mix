//
//  BudgetDetailsTabbleHeader.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/22.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BudgetDetailsPreviewTabbleHeader.h"
#import "MoneyMenu.h"
#import "OneClassMenus.h"
#import "Budgetpro.h"

@interface BudgetDetailsPreviewTabbleHeader()


@property (nonatomic, retain) UIImageView *imageVBg;
@property (nonatomic, retain) UILabel *differenceView;
@property (nonatomic, retain) UILabel *warningView;

@property (nonatomic, retain) MoneyMenu *budgetamount;//预算总价
@property (nonatomic, retain) MoneyMenu *proAmount;//期望总价



@end


@implementation BudgetDetailsPreviewTabbleHeader
//budgetDetails_TabkeBg

-(instancetype)init{
    if (self = [super init]) {
        [self imageVBg];
        [self proAmount];
        [self budgetamount];
        [self differenceView];
        [self warningView];
        
    }
    return self;
}


-(void)setBudgetpro:(Budgetpro *)budgetpro{
    _budgetpro = budgetpro;
    
    NSString *originStr = [NSString strmethodComma:[NSString stringWithFormat:@"%.0f",budgetpro.budgetamount / 100.0f]];
    NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"¥%@",originStr]];
    [attributedStr01 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:12] range: NSMakeRange(0, 1)];
    _proAmount.moneyView.attributedText = attributedStr01;
    
    NSString *originStr2 = [NSString strmethodComma:[NSString stringWithFormat:@"%.0f",budgetpro.budgetproamount / 100.0f]];
    NSMutableAttributedString *attributedStr02 = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"¥%@",originStr2]];
    [attributedStr02 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:12] range: NSMakeRange(0, 1)];
    _budgetamount.moneyView.attributedText = attributedStr02;
    
    
    if (budgetpro.priceDifference < 0) {
        _differenceView.backgroundColor = XWColorFromHex(0xee2f2b);
        _differenceView.text = [NSString stringWithFormat:@"%@%@%@",@"超支了",[self moneyFormat:[NSString stringWithFormat:@"%.0f",fabs(budgetpro.priceDifference / 100.0f)]],@"元"];
        ;
        _warningView.text = @"“有数啦”警报！\n理想很丰满，现实很骨感，装修果然是个烧钱货！";
        
    }else{
        _differenceView.backgroundColor = XWColorFromHex(0x11c354);
        _differenceView.text = [NSString stringWithFormat:@"%@%@%@",@"节省了",[self moneyFormat:[NSString stringWithFormat:@"%.0f",budgetpro.priceDifference / 100.0f]], @"元"]
         ;
        _warningView.text = @"“有数啦”给你点赞！\n精打细算，心中不乱，真是个省钱小能手！";
    }
    CGSize size = [_differenceView sizeThatFits:CGSizeMake(20, 20)];
    [_differenceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_budgetamount.mas_bottom).offset(kRKBHEIGHT(17));
        make.size.mas_equalTo(CGSizeMake(size.width+20, size.height+6));
        make.centerX.equalTo(_imageVBg.mas_centerX);
    }];
    
    CGFloat height = [_warningView.text getHeightWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreen_Width-100, 100)];
    [_warningView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-100, height));
        make.centerX.equalTo(_imageVBg.mas_centerX);
        make.top.equalTo(_differenceView.mas_bottom).offset(9);
    }];
    
}

#pragma mark - getters and setters
-(UIImageView *)imageVBg{
    if (!_imageVBg) {
        UIImage *image = [UIImage imageNamed:@"budgetDetailsPr_TabkeBg"];
        _imageVBg = [[UIImageView alloc]init];
        _imageVBg.image = image;
        _imageVBg.clipsToBounds = YES;
        _imageVBg.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageVBg];
        [_imageVBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _imageVBg;
}

-(MoneyMenu *)proAmount{
    
    if (!_proAmount) {
        _proAmount = [[MoneyMenu alloc]initWithTitle:@"期望总价" Money:@"0" ShowLine:YES];
        _proAmount.titleView.backgroundColor = [UIColor clearColor];
        _proAmount.titleView.textColor = kTitleAddHouseCOLOR;
        _proAmount.titleView.font = [UIFont systemFontOfSize:13 weight:10];
        _proAmount.moneyView.font = [UIFont fontWithName:@"Arial-BoldMT" size:23];
        [self addSubview:_proAmount];
        [_proAmount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kScreen_Width/2));
            make.height.equalTo(@(40));
            make.left.equalTo(self);
            if (IphoneX) {
                make.top.equalTo(self.mas_top).offset(kRKBHEIGHT(79));
            } else {
                make.top.equalTo(self.mas_top).offset(kRKBHEIGHT(59));
            }
        }];
    }
    return _proAmount;
}

-(MoneyMenu *)budgetamount{
    
    if (!_budgetamount) {
        _budgetamount = [[MoneyMenu alloc]initWithTitle:@"预算总价" Money:@"0" ShowLine:YES];
        _budgetamount.titleView.backgroundColor = [UIColor clearColor];
        _budgetamount.titleView.textColor = kTitleAddHouseCOLOR;
        _budgetamount.titleView.font = [UIFont systemFontOfSize:13 weight:10];
        _budgetamount.moneyView.font = [UIFont fontWithName:@"Arial-BoldMT" size:23];
        [self addSubview:_budgetamount];
        [_budgetamount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kScreen_Width/2));
            make.height.equalTo(@(40));
            make.left.equalTo(_proAmount.mas_right);
            make.top.equalTo(_proAmount.mas_top);
        }];
    }
    return _budgetamount;
}


-(UILabel *)differenceView{
    if (!_differenceView) {
        _differenceView = [[UILabel alloc]init];
        _differenceView.textAlignment = NSTextAlignmentCenter;
        _differenceView.textColor = XWColorFromHex(0xfbe7d4);
        _differenceView.font = [UIFont systemFontOfSize:13];
        _differenceView.layer.cornerRadius = 5.0f;
        _differenceView.layer.masksToBounds = YES;
        [self addSubview:_differenceView];
        [_differenceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_budgetamount.mas_bottom).offset(kRKBHEIGHT(17));
            make.size.mas_equalTo(CGSizeZero);
            make.centerX.equalTo(_imageVBg.mas_centerX);
        }];
    }
    return _differenceView;
}



-(UILabel *)warningView{
    if (!_warningView) {
        _warningView = [[UILabel alloc]init];
        _warningView.textColor = kTitleAddHouseTitleCOLOR;
        _warningView.textAlignment = NSTextAlignmentCenter;
        _warningView.font = [UIFont systemFontOfSize:12];
        _warningView.numberOfLines = 0;
        [self addSubview:_warningView];
        [_warningView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeZero);
            make.centerX.equalTo(_imageVBg.mas_centerX);
            make.top.equalTo(_differenceView.mas_bottom).offset(9);
        }];
    }
    return _warningView;
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
