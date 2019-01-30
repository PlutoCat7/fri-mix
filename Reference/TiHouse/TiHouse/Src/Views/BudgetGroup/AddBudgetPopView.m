//
//  screenPopView.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AddBudgetPopView.h"
#import "BottomBtnView.h"
#import "Budgetpro.h"
#import "AddBudgetTopView.h"
#import "RemarksView.h"
#import "BudgetThreeClass.h"

#import "TopBottomTitleView.h"
#import "TopBottomTitleViewModel.h"

@interface AddBudgetPopView()<UITextFieldDelegate,UITextViewDelegate,TopBottomTitleViewDelegate>
{
    BOOL isNewBudet;
    BOOL selectedBuy;
    BOOL selectedMoney;
    NSString *_tempArea;
    NSString *_tempPrice;
    NSString *_tempAllMoney;
}
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) BottomBtnView *bottomBtnView;
@property (nonatomic, retain) RemarksView *remarksView;
@property (nonatomic, retain) UIView *thintB;
@property (nonatomic, retain) UIButton *closeThinB;


@property (nonatomic, retain) AddBudgetTopView *topView;
@property (nonatomic, retain) UITextField *nowTextfield;
@property (nonatomic, retain) UITextField *areaView;
@property (nonatomic, retain) UITextField *priceView;
@property (nonatomic, retain) UIView *shortcutKeys;
@property (nonatomic, retain) UIView *bagView;

@end

@implementation AddBudgetPopView

-(instancetype)initWithBudgetThreeClass:(BudgetThreeClass *)threeClass{
    
    if (self = [super initWithFrame:kScreen_Bounds]) {
        self.threeClass = threeClass;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self contentView];
        [self bottomBtnView];
        [self remarksView];
        [self thintB];
        [self shortcutKeys];
        [self priceView];
        [self areaView];
        [self topView];
        [self bagView];
        
        if (!_threeClass.catethreestatus) {
            [_thintB mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(0));
            }];
            
            [_shortcutKeys mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(0));
            }];
            
            [_priceView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(0));
            }];
            
            [_areaView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(0));
            }];
        }
        
        
        isNewBudet = YES;
        selectedMoney = NO;
        selectedBuy = NO;
        
        _bottomBtnView.threeClass = threeClass;
        _remarksView.threeClass = threeClass;
        _topView.titleField.text = threeClass.proname;
        _tempAllMoney =  _topView.allMoney.text = [NSString stringWithFormat:@"%.2f",threeClass.amountzj / 100.0f];
        _tempPrice =  _priceView.text = [NSString stringWithFormat:@"%.2f",(float)threeClass.proamountunit / 100.0f];
        
        if ([_threeClass.catethreeunit isEqualToString:@"平米"] || [_threeClass.catethreeunit isEqualToString:@"延米"]) {
            _areaView.text = [NSString stringWithFormat:@"%.2f",threeClass.pronum];
        }
        else if ([_threeClass.catethreeunit isEqualToString:@"米"]) {
            _areaView.text = [NSString stringWithFormat:@"%.1f",threeClass.pronum];
        } else {
            _areaView.text = [NSString stringWithFormat:@"%.f", threeClass.pronum];
        }
//        _areaView.text = [_threeClass.catethreeunit isEqualToString:@"平米"] || [_threeClass.catethreeunit isEqualToString:@"延米"] ? [NSString stringWithFormat:@"%.2f",threeClass.pronum] : [NSString stringWithFormat:@"%.f",threeClass.pronum];
        
        selectedMoney = threeClass.protypeyg;
        selectedBuy = threeClass.protypexb;
        if (threeClass) {
            _topView.titleField.userInteractionEnabled = NO;
        }
        //键盘通知
        [self registerForKeyboardNotifications];
    }
    return self;
}


-(void)setThreeClass:(BudgetThreeClass *)threeClass{
    _threeClass = threeClass;
    _bottomBtnView.threeClass = threeClass;
    _remarksView.threeClass = threeClass;
    _topView.titleField.text = threeClass.proname;
    _priceView.text = [NSString stringWithFormat:@"%.2f",threeClass.proamountunit / 100.0f];
//    _areaView.text = [_threeClass.catethreeunit isEqualToString:@"平米"] || [_threeClass.catethreeunit isEqualToString:@"延米"] ? [NSString stringWithFormat:@"%.2f",threeClass.pronum] : [NSString stringWithFormat:@"%.f",threeClass.pronum];
    if ([_threeClass.catethreeunit isEqualToString:@"平米"] || [_threeClass.catethreeunit isEqualToString:@"延米"]) {
        _areaView.text = [NSString stringWithFormat:@"%.2f",threeClass.pronum];
    }
    else if ([_threeClass.catethreeunit isEqualToString:@"米"]) {
        _areaView.text = [NSString stringWithFormat:@"%.1f",threeClass.pronum];
    }
    _topView.allMoney.text = [NSString stringWithFormat:@"%.2f",threeClass.amountzj / 100.0f];
    selectedMoney = threeClass.protypeyg;
    selectedBuy = threeClass.protypexb;
    if (threeClass) {
        _topView.titleField.userInteractionEnabled = NO;
    }
}




-(UIView *)contentView{
    
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width,kScreen_Height)];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
        
        UIView *bgV = [[UIView alloc]init];
        bgV.backgroundColor = XWColorFromHex(0xf8f8f8);
        bgV.frame = CGRectMake(0, _contentView.height-250, _contentView.width, 250);
        [_contentView addSubview:bgV];
    }
    return _contentView;
}

-(BottomBtnView *)bottomBtnView{
    if (!_bottomBtnView) {
        _bottomBtnView = [[BottomBtnView alloc]initWithFrame:CGRectMake(0, _contentView.height-kRKBHEIGHT(110), _contentView.width, kRKBHEIGHT(110))];
        WEAKSELF
        _bottomBtnView.SelectedBtn = ^(NSInteger tag) {
            if (tag == 1) {
                [weakSelf selectbuyORmoney:YES];
            }
            if (tag == 2) {
                [weakSelf selectbuyORmoney:NO];
            }
            if (tag == 3) {
                [weakSelf close];
            }
            if (tag == 4) {
                [weakSelf finish];
            }
            
        };
        [_contentView addSubview:_bottomBtnView];
    }
    return _bottomBtnView;
}

-(RemarksView *)remarksView{
    if (!_remarksView) {
        _remarksView = [[RemarksView alloc]initWithFrame:CGRectMake(0, 0, _contentView.width, kRKBHEIGHT(50))];
        _remarksView.bottom = _bottomBtnView.y - kRKBHEIGHT(5);
        [_contentView addSubview:_remarksView];
        _remarksView.TextView.delegate = self;
    }
    return _remarksView;
}

-(UIView *)thintB{
    if (!_thintB) {
        
        _thintB = [[UIView alloc]init];
        _thintB.backgroundColor = XWColorFromHex(0xfff9e6);
        _thintB.layer.borderColor = kLineColer.CGColor;
        _thintB.layer.borderColor = kLineColer.CGColor;
        _thintB.layer.borderWidth = 0.5f;
        _thintB.clipsToBounds = YES;
        
        UILabel *hitn = [[UILabel alloc]init];
        hitn.text = _threeClass.catethreetipb;
        hitn.font = [UIFont systemFontOfSize:10];
        hitn.numberOfLines = 0;
        hitn.textColor = XWColorFromHex(0xf13838);
        CGFloat hitnH = [hitn.text getHeightWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(_contentView.width-36, 200)];
        [_thintB addSubview:hitn];
        [_contentView addSubview:_thintB];
        [_thintB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_remarksView.mas_top).offset(0.5);
            make.right.left.equalTo(_contentView);
            if (hitnH > 0)
            {
                make.height.equalTo(@(hitnH + 18));
            }
            else
            {
                make.height.equalTo(@(0));
            }
        }];
        [hitn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(_contentView.width-36, hitnH));
            make.top.equalTo(_thintB).offset(9);
            make.left.equalTo(_thintB.mas_left).offset(18);
        }];
        
    }
    return _thintB;
}


-(UIView *)shortcutKeys{
    if (!_shortcutKeys) {
        _shortcutKeys = [[UIView alloc]init];
        _shortcutKeys.backgroundColor = [UIColor whiteColor];
        _shortcutKeys.layer.borderColor = kLineColer.CGColor;
        _shortcutKeys.clipsToBounds = YES;
        _shortcutKeys.layer.borderWidth = 0.5f;
        [_contentView addSubview:_shortcutKeys];
        [_shortcutKeys mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_thintB.mas_top).offset(0.5);
            make.right.left.equalTo(_contentView);
            if (_threeClass.cateoneid != 5)
            {
                make.height.equalTo(@(55));
            }
            else
            {
                make.height.equalTo(@(0));
            }
        }];
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        TopBottomTitleViewModel *viewModel = nil;
        
        viewModel = [[TopBottomTitleViewModel alloc] init];
        viewModel.topTitle = @"经济型";
        viewModel.bottomTitle = [NSString stringWithFormat:@"￥%.0f",_threeClass.catethreepricelow/100.0];
        viewModel.cellBackgroundColor = XWColorFromHex(0xd3cfb0);
        viewModel.dataModel = @(_threeClass.catethreepricelow/100.0);
        [tmpArray addObject:viewModel];
        
        viewModel = [[TopBottomTitleViewModel alloc] init];
        viewModel.topTitle = @"舒适型";
        viewModel.bottomTitle = [NSString stringWithFormat:@"￥%.0f",_threeClass.catethreepricelowmid/100.0];
        viewModel.cellBackgroundColor = XWColorFromHex(0x8dbcc0);
        viewModel.dataModel = @(_threeClass.catethreepricelowmid/100.0);
        [tmpArray addObject:viewModel];
        
        viewModel = [[TopBottomTitleViewModel alloc] init];
        viewModel.topTitle = @"品质型";
        viewModel.bottomTitle = [NSString stringWithFormat:@"￥%.0f",_threeClass.catethreepricemid/100.0];
        viewModel.cellBackgroundColor = XWColorFromHex(0x8691bd);
        viewModel.dataModel = @(_threeClass.catethreepricemid/100.0);
        [tmpArray addObject:viewModel];
        
        viewModel = [[TopBottomTitleViewModel alloc] init];
        viewModel.topTitle = @"轻奢型";
        viewModel.bottomTitle = [NSString stringWithFormat:@"￥%.0f",_threeClass.catethreepricehig/100.0];
        viewModel.cellBackgroundColor = XWColorFromHex(0xbda170);
        viewModel.dataModel = @(_threeClass.catethreepricehig/100.0);
        [tmpArray addObject:viewModel];
        
        float xSpace = 17;
        for (TopBottomTitleViewModel *tmpViewModel in tmpArray)
        {
            CGFloat topWidth = [tmpViewModel.topTitle getWidthWithFont:[UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:10]] constrainedToSize:CGSizeMake(200, 44)];
            CGFloat bottomWidth = [tmpViewModel.bottomTitle getWidthWithFont:[UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:10]] constrainedToSize:CGSizeMake(200, 44)];
            CGFloat realFirstWidth = topWidth > bottomWidth ? topWidth + 20: bottomWidth + 20;
            TopBottomTitleView *tmpView = [[TopBottomTitleView alloc] init];
            tmpView.delegate = self;
            [tmpView resetViewWithViewModel:tmpViewModel];
            [_shortcutKeys addSubview:tmpView];
            [tmpView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_shortcutKeys.mas_centerY);
                make.top.equalTo(_shortcutKeys).offset(11);
                make.left.equalTo(_shortcutKeys).offset(xSpace);
                make.width.equalTo(@(realFirstWidth));
                make.height.equalTo(@(44));
            }];
            xSpace += realFirstWidth;
            xSpace += 5;
        }
        
//        UIButton * oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        oneBtn.backgroundColor = XWColorFromHex(0xd3cfb0);
//        oneBtn.tag = 10;
//        NSString *oneBtnStr = [NSString stringWithFormat:@"经济型¥%.0f",_threeClass.catethreepricelow/100.0];
//        [oneBtn setTitle:oneBtnStr forState:UIControlStateNormal];
//        [oneBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
//        [_shortcutKeys addSubview:oneBtn];
//        oneBtn.layer.cornerRadius = 5.0f;
//        oneBtn.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:10]];
//        CGFloat oneBtnW = [oneBtnStr getWidthWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(200, 50)];
//        [oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_shortcutKeys).offset(11);
//            make.left.equalTo(_shortcutKeys).offset(17);
//            make.bottom.equalTo(_shortcutKeys).offset(-11);
//            make.width.equalTo(@(oneBtnW + 20));
//        }];
//
//        UIButton * twoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        twoButton.backgroundColor = XWColorFromHex(0x8dbcc0);
//        twoButton.tag = 11;
//        NSString *twoBtnStr = [NSString stringWithFormat:@"舒适型¥%.0f",_threeClass.catethreepricelowmid/100.0];
//        [twoButton setTitle:twoBtnStr forState:UIControlStateNormal];
//        [twoButton addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
//        [_shortcutKeys addSubview:twoButton];
//        twoButton.layer.cornerRadius = 5.0f;
//        twoButton.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:10]];
//        CGFloat twoBtn = [twoBtnStr getWidthWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(200, 50)];
//        [twoButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_shortcutKeys).offset(11);
//            make.left.equalTo(oneBtn.mas_right).offset(5);
//            make.bottom.equalTo(_shortcutKeys).offset(-11);
//            make.width.equalTo(@(twoBtn+20));
//        }];
//
//        UIButton * threeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        threeBtn.backgroundColor = XWColorFromHex(0x8691bd);
//        threeBtn.tag = 12;
//        threeBtn.layer.cornerRadius = 5.0f;
//        threeBtn.titleLabel.font = [UIFont systemFontOfSize:10];
//        NSString *threeBtnStr = [NSString stringWithFormat:@"品质型¥%.0f",_threeClass.catethreepricemid/100.0];
//        [threeBtn setTitle:threeBtnStr forState:UIControlStateNormal];
//        CGFloat threebtnWidth = [twoBtnStr getWidthWithFont:[UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:10]] constrainedToSize:CGSizeMake(200, 50)];
//        [threeBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
//        [_shortcutKeys addSubview:threeBtn];
//        [threeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_shortcutKeys).offset(11);
//            make.left.equalTo(twoButton.mas_right).offset(5);
//            make.bottom.equalTo(_shortcutKeys).offset(-11);
//            make.width.equalTo(@(threebtnWidth+20));
//        }];
//
//        UIButton * forBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        forBtn.backgroundColor = XWColorFromHex(0xbda170);
//        forBtn.tag = 13;
//        forBtn.layer.cornerRadius = 5.0f;
//        forBtn.titleLabel.font = [UIFont systemFontOfSize:10];
//        NSString *forBtnStr = [NSString stringWithFormat:@"轻奢型¥%.0f",_threeClass.catethreepricehig/100.0];
//        [forBtn setTitle:forBtnStr forState:UIControlStateNormal];
//        [forBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
//        CGFloat forBtnW = [forBtnStr getWidthWithFont:[UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:10]] constrainedToSize:CGSizeMake(200, 50)];
//        [_shortcutKeys addSubview:forBtn];
//        [forBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_shortcutKeys).offset(11);
//            make.left.equalTo(threeBtn.mas_right).offset(5);
//            make.bottom.equalTo(_shortcutKeys).offset(-11);
//            make.width.equalTo(@(forBtnW+20));
//        }];
        
        [self closeThinB];
        
    }
    return _shortcutKeys;
}

-(UIButton *)closeThinB{
    if (!_closeThinB) {
        _closeThinB = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeThinB setImage:[UIImage imageNamed:@"sanjiaob"] forState:UIControlStateNormal];
        [_closeThinB setImage:[UIImage imageNamed:@"shanjiaobd"] forState:UIControlStateSelected];
        _closeThinB.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
        [_closeThinB addTarget:self action:@selector(ThinBClick:) forControlEvents:UIControlEventTouchUpInside];
        _closeThinB.selected = NO;
        [_shortcutKeys addSubview:_closeThinB];
        [_closeThinB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_shortcutKeys.mas_centerY);
            make.right.equalTo(_shortcutKeys).offset(-27);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
    }
    return _closeThinB;
}
-(void)ThinBClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    CGFloat hitnH = [_threeClass.catethreetipb getHeightWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(_contentView.width-36, 200)];
    if (btn.selected) {
        [_thintB mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_remarksView.mas_top).offset(0.5);
            make.right.left.equalTo(_contentView);
            make.height.equalTo(@(0));
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            [_thintB.superview layoutIfNeeded];
        }];
        
    }else{
        [_thintB mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_remarksView.mas_top).offset(0.5);
            make.right.left.equalTo(_contentView);
            make.height.equalTo(@(hitnH + 18));
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [_thintB.superview layoutIfNeeded];
        }];
    }
}


-(UITextField *)priceView{
    if (!_priceView) {
        
        UILabel *leftView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 50)];
        leftView.font = [UIFont systemFontOfSize:13];
        leftView.text = @"    单价";
        leftView.textAlignment = NSTextAlignmentLeft;
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(60, 0, 0.5, 50)];
        line.backgroundColor = kLineColer;
        [leftView addSubview:line];
        UILabel *rightView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 50)];
        rightView.text = [NSString stringWithFormat:@"元/%@",_threeClass.catethreeunit];
        rightView.textColor = XWColorFromHex(0xbfbfbf);
        rightView.font = [UIFont systemFontOfSize:12];
        
        _priceView = [[UITextField alloc]init];
        _priceView.clipsToBounds = YES;
        _priceView.keyboardType = UIKeyboardTypeDecimalPad;
        _priceView.leftView = leftView;
        _priceView.backgroundColor = [UIColor whiteColor];
        _priceView.leftViewMode = UITextFieldViewModeAlways;
        _priceView.rightView = rightView;
        _priceView.delegate = self;
        _priceView.rightViewMode = UITextFieldViewModeAlways;
        _priceView.font = [UIFont systemFontOfSize:13];
        _priceView.layer.borderColor = kLineColer.CGColor;
        _priceView.layer.borderWidth = 0.5f;
        _priceView.placeholder = @"请填写单价或点击下方市场参考价";
        [_priceView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_contentView addSubview:_priceView];
        [_priceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_shortcutKeys.mas_top).offset(0.5);
            make.right.left.equalTo(_contentView);
            make.height.equalTo(@(50));
        }];
        
    }
    return _priceView;
}


-(UITextField *)areaView{
    if (!_areaView) {
        
        UILabel *leftView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 50)];
        leftView.font = [UIFont systemFontOfSize:13];
//        if ([_threeClass.catethreeunit isEqualToString:@"平米"] || [_threeClass.catethreeunit isEqualToString:@"延米"] || [_threeClass.catethreeunit isEqualToString:@"米"]) {
//            leftView.text = @"    面积";
//        }else{
//            leftView.text = @"    数量";
//        }
        leftView.text = [NSString stringWithFormat:@"    %@", _threeClass.catethreeunitname];
        leftView.textAlignment = NSTextAlignmentLeft;
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(60, 0, 0.5, 50)];
        line.backgroundColor = kLineColer;
        [leftView addSubview:line];
        UILabel *rightView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
        rightView.text = _threeClass.catethreeunit;
        //        rightView.textAlignment = NSTextAlignmentRight;
        rightView.textColor = XWColorFromHex(0xbfbfbf);
        rightView.font = [UIFont systemFontOfSize:12];
        
        _areaView = [[UITextField alloc]init];
        _areaView.leftView = leftView;
        _areaView.clipsToBounds = YES;
        _areaView.backgroundColor = [UIColor whiteColor];
        _areaView.leftViewMode = UITextFieldViewModeAlways;
        _areaView.rightView = rightView;
        _areaView.delegate = self;
        _areaView.rightViewMode = UITextFieldViewModeAlways;
        _areaView.font = [UIFont systemFontOfSize:13];
        _areaView.layer.borderColor = kLineColer.CGColor;
        _areaView.layer.borderWidth = 0.5f;
        _areaView.keyboardType = UIKeyboardTypeDecimalPad;
        [_areaView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_contentView addSubview:_areaView];
        [_areaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_priceView.mas_top).offset(0.5);
            make.right.left.equalTo(_contentView);
            make.height.equalTo(@(50));
        }];
        
    }
    return _areaView;
}



-(AddBudgetTopView *)topView{
    if (!_topView) {
        _topView = [[AddBudgetTopView alloc]initWithThreeClass:_threeClass];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.allMoney.delegate = self;
        [_topView.allMoney addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        [_contentView addSubview:_topView];
        _topView.allMoney.delegate = self;
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_areaView.mas_top).offset(0.5);
            make.right.left.equalTo(_contentView);
            make.height.equalTo(@(-_topView.titleField.y + 20));
        }];
    }
    return _topView;
}


-(UIView *)bagView{
    if (!_bagView) {
        _bagView = [[UIView alloc]init];
        _bagView.backgroundColor = [UIColor clearColor];
        _bagView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
        [_bagView addGestureRecognizer:tap];
        [self addSubview:_bagView];
        [_bagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.left.equalTo(_contentView);
            make.bottom.equalTo(_topView.mas_top);
        }];
    }
    return _bagView;
}







#pragma mark - private methods 私有方法
-(void)finish{
    
    if (_topView.titleField.text.length<=0) {
        [NSObject showHudTipStr:@"信息填写完整才能添加或修改哦！"];
        return;
    }
    
    if (_threeClass.budgetproid) {
        _threeClass.proname = _topView.titleField.text;
        _threeClass.amountzj = [_topView.allMoney.text floatValue] * 100;
        _threeClass.proremark = _remarksView.TextView.text;
        _threeClass.protypeyg = (int)selectedMoney;
        _threeClass.protypexb = (int)selectedBuy;
        _threeClass.pronum = [_areaView.text floatValue];
        _threeClass.proamountunit = [_priceView.text longLongValue] * 100;
        _threeClass.catethreestatus = _threeClass.catethreestatus;
        if (_finishSelectde) {
            _finishSelectde(_threeClass, NO);
        }
    }else{
        _threeClass.proname = _topView.titleField.text;
        _threeClass.amountzj = [_topView.allMoney.text floatValue] * 100;
        _threeClass.proremark = _remarksView.TextView.text;
        _threeClass.protypeyg = (int)selectedMoney;
        _threeClass.protypexb = (int)selectedBuy;
        _threeClass.pronum = [_areaView.text floatValue];
        _threeClass.proamountunit = [_priceView.text longLongValue] * 100;
        if (_finishSelectde) {
            _finishSelectde(_threeClass, YES);
        }
    }
    [self close];
}

-(void)selectbuyORmoney:(BOOL)isbuy{
    if (isbuy) {
        selectedBuy = !selectedBuy;
    }else{
        selectedMoney = !selectedMoney;
    }
}

-(void)Click:(UIButton *)btn{
    
    
    CGFloat price = 0.0;
    if (btn.tag == 10) {
        price = _threeClass.catethreepricelow/100.0;
    }else if (btn.tag == 11) {
        price = _threeClass.catethreepricelowmid/100.0;
    }else if (btn.tag == 12)
    {
        price = _threeClass.catethreepricemid/100.0;
    }
    else{
        price = _threeClass.catethreepricehig/100.0;
    }
    _priceView.text = [NSString stringWithFormat:@"%.0f",price];
    _topView.allMoney.text = [NSString stringWithFormat:@"%.2f",[_areaView.text floatValue]*price];
}


-(void)Show{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        _contentView.y = kScreen_Height-_contentView.height;
    } completion:nil];
    
}

-(void)close{
    [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        _contentView.y = kScreen_Height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
}


//注册键盘的通知
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowna:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHiddena:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
//当键盘隐藏的时候
- (void)keyboardWillBeHiddena:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    }];
}

//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    _nowTextfield = textView;
//    return YES;
//}
//#pragma mark - UITextFieldDelegate
//-(void)textViewDidBeginEditing:(UITextView *)textView
//{
//    if ([textView.text isEqualToString:@"您可以在此记录品牌型号信息等信息"]) {
//        textView.text = @"";
//        textView.textColor = kRKBHomeBlackColor;
//    }
//}
//
//-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
//
//    return YES;
//}
//
//-(void)textViewDidChange:(UITextView *)textView{
//    textView.textColor = [UIColor blackColor];
//}
//
//#pragma mark - UITextFieldDelegate
//-(void)textViewDidEndEditing:(UITextView *)textView
//{
//    if ([textView.text isEqualToString:@""]) {
//        textView.text = @"您可以在此记录品牌型号信息等信息";
//        textView.textColor = kRKBNOTELABELCOLOR;
//    }
//}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _areaView || textField == _priceView) {
        _topView.allMoney.text = [NSString stringWithFormat:@"%.2f",[_areaView.text floatValue] * [_priceView.text floatValue]];
    } else if (textField == _topView.allMoney) {
        _priceView.text =  [NSString stringWithFormat:@"%.2f",[_topView.allMoney.text floatValue] / [_areaView.text floatValue]];
    }
    _tempArea = _areaView.text;
    _tempPrice = _priceView.text;
    _tempAllMoney = _topView.allMoney.text;
}

//限制输入长度
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField == _remarksView.TextView) {
//        if (textField.text.length > 15) return NO;
//    }
//    return YES;
//}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView == _remarksView.TextView) {
        if (textView.text.length > 59) {
            textView.text = [textView.text substringToIndex:59];
        };
    }
    return YES;
}

//
#pragma mark - textFieldDelegate
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    if (textField == _priceView) {
//        _topView.allMoney.text = [NSString stringWithFormat:@"%.2f",[_areaView.text floatValue]*[_priceView.text floatValue]];
//    }
//    return YES;
//}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _priceView) {
        _tempPrice = textField.text;
    }
    if (textField == _areaView) {
        _tempArea = textField.text;
    }
    

    if (textField == _topView.allMoney) {
        _tempAllMoney = textField.text;
    }
    
    _nowTextfield = textField;
    textField.text = @"";
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _priceView) {
        _priceView.text = _tempPrice;
    }
    if (textField == _areaView) {
        if ([_tempArea floatValue] == 0) {
            _areaView.text = _tempArea =  @"1";
            NSString *remindText;
//            if ([_threeClass.catethreeunit isEqualToString:@"平米"] || [_threeClass.catethreeunit isEqualToString:@"延米"] || [_threeClass.catethreeunit isEqualToString:@"米"]) {
//                remindText = @"面积";
//            }else{
//                remindText = @"数量";
//            }
            remindText = _threeClass.catethreeunitname;
            [NSObject showHudTipStr: [NSString stringWithFormat:@"%@不能为空", remindText]];
        } else {
            _areaView.text = _tempArea;
        }
        _topView.allMoney.text = [NSString stringWithFormat:@"%.2f",[_areaView.text floatValue] * [_priceView.text floatValue]];
    }
    
    if (textField == _topView.allMoney) {
        _priceView.text = _tempPrice;
        _topView.allMoney.text = _tempAllMoney;
    }
}

#pragma mark -  键盘事件
//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWillShowna:(NSNotification*)aNotification
{
    if ([_nowTextfield isFirstResponder]) {
        UITextField *field = _nowTextfield;
        CGRect rc = [field.superview convertRect:field.frame toView:self];
        NSDictionary* info = [aNotification userInfo];
        //kbSize即為鍵盤尺寸 (有width, height)
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
        if ((kScreen_Height-kbSize.height)>(CGRectGetMaxY(rc))) {
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(0, (kScreen_Height-kbSize.height)-CGRectGetMaxY(rc)-10, kScreen_Width,  kScreen_Height);
            }];
            
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(0, (kScreen_Height-kbSize.height)-CGRectGetMaxY(rc)-10, kScreen_Width,  kScreen_Height);
            }];
        }
        return;
    }
    
    RemarksView *field = _remarksView;
    CGRect rc = [field.superview convertRect:field.frame toView:self];
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    
    if (![_remarksView.TextView isFirstResponder]) {
        return;
    }
    
    if ((kScreen_Height-kbSize.height)>(CGRectGetMaxY(rc))) {
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, (kScreen_Height-kbSize.height)-CGRectGetMaxY(rc)-10, kScreen_Width,  kScreen_Height);
        }];

    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, (kScreen_Height-kbSize.height)-CGRectGetMaxY(rc)-10, kScreen_Width,  kScreen_Height);
        }];
    }
}

- (BaseViewModel *)topBottomTitleViewModelWithTopTitle:(NSString *)topTitle bottomTitle:(NSString *)bottomTitle
{
    TopBottomTitleViewModel *viewModel = [[TopBottomTitleViewModel alloc] init];
    viewModel.topTitle = topTitle;
    viewModel.bottomTitle = bottomTitle;
    return viewModel;
}

#pragma mark TopBottomTitleViewDelegate
- (void)topBottomTitleView:(TopBottomTitleView *)view clickViewWithViewModel:(TopBottomTitleViewModel *)viewModel;
{
    CGFloat price = [viewModel.dataModel floatValue];
    _priceView.text = [NSString stringWithFormat:@"%.0f",price];
    _topView.allMoney.text = [NSString stringWithFormat:@"%.2f",[_areaView.text floatValue]*price];
}

@end

