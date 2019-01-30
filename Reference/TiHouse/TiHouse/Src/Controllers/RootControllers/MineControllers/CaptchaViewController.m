//
//  CaptchaViewController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CaptchaViewController.h"
#import "UserTextField.h"
#import "BindVercodeViewController.h"
#import "CaptchaModel.h"

@interface CaptchaViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *verCodeImgv;
@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UserTextField *textField;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) CaptchaModel *currentCaptcha;

@end

@implementation CaptchaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self backView];
    [self titleLabel];
    [self verCodeImgv];
    [self getVerCode];
    [self refreshLabel];
    [self textField];
    [self line];
    [self closeButton];
    [self checkButton];
    
    WEAKSELF
    [[_textField.textField rac_textSignal] subscribeNext:^(id x) {
        
        if ([(NSString *)x length] > 4) {
            weakSelf.textField.textField.text = [weakSelf.textField.textField.text substringToIndex:4];
        } else if ([(NSString *)x length] == 4) {
            weakSelf.checkButton.backgroundColor = kTiMainBgColor;
            weakSelf.checkButton.userInteractionEnabled = YES;
        } else {
            weakSelf.checkButton.backgroundColor = [UIColor colorWithHexString:@"FEF9CF"];
            weakSelf.checkButton.userInteractionEnabled = NO;
        }
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

#pragma mark - getters & setters
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.height.equalTo(@(kRKBHEIGHT(320)));
            make.width.equalTo(@(kRKBWIDTH(280)));
            make.top.equalTo(@(138));
        }];
        _backView.layer.cornerRadius = kRKBWIDTH(10);
    }
    return _backView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"请输入下图中的验证码";
        _titleLabel.font = ZISIZE(15);
        [_backView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_backView);
            make.top.equalTo(@(kRKBHEIGHT(48)));
        }];
    }
    return _titleLabel;
}

- (UIImageView *)verCodeImgv {
    if (!_verCodeImgv) {
        _verCodeImgv = [[UIImageView alloc] init];
        [_backView addSubview:_verCodeImgv];
        [_verCodeImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_titleLabel.mas_bottom).offset(kRKBHEIGHT(20));
            make.height.equalTo(@(kRKBHEIGHT(35)));
            make.width.equalTo(@(kRKBWIDTH(110)));
        }];
        UITapGestureRecognizer *reloadTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getVerCode)];
        _verCodeImgv.userInteractionEnabled = YES;
        [_verCodeImgv addGestureRecognizer:reloadTap];
    }
    return _verCodeImgv;
}

- (UILabel *)refreshLabel {
    if (!_refreshLabel) {
        _refreshLabel = [[UILabel alloc] init];
        [_backView addSubview:_refreshLabel];
        [_refreshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_verCodeImgv.mas_bottom).offset(kRKBHEIGHT(10));
            make.centerX.equalTo(_backView);
        }];
        _refreshLabel.text = @"看不清楚？点击刷新";
        _refreshLabel.font = ZISIZE(11);
        _refreshLabel.textColor = kColor999;
    }
    return _refreshLabel;
}

- (UserTextField *)textField {
    if (!_textField) {
        _textField = [[UserTextField alloc] initWithPlaceholder:@"请输入图中的验证码" IconImage:nil];
        _textField.textField.textAlignment = NSTextAlignmentCenter;
        [_textField.textField becomeFirstResponder];
        [_backView addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_refreshLabel.mas_bottom).offset(kRKBHEIGHT(30));
            make.height.equalTo(@(kRKBHEIGHT(40)));
            make.left.equalTo(@(kRKBWIDTH(20)));
            make.right.equalTo(@(kRKBWIDTH(-20)));
        }];
        _textField.textField.font = ZISIZE(14);
        _textField.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    return _textField;
}

- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setTitle:@"确定" forState:UIControlStateNormal];
        [_checkButton setTitleColor:kLOGINBTNCOLOR forState:UIControlStateNormal];
        _checkButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
        _checkButton.layer.cornerRadius = kRKBHEIGHT(25);
        _checkButton.layer.masksToBounds = YES;
        [_checkButton addTarget:self action:@selector(checkVerCode) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_checkButton];
        [_checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textField.mas_bottom).offset(kRKBHEIGHT(25));
            make.height.equalTo(@(kRKBHEIGHT(50)));
            make.centerX.equalTo(_backView);
            make.left.equalTo(@(kRKBWIDTH(40)));
        }];
        _checkButton.backgroundColor = [UIColor colorWithHexString:@"FEF9CF"];
        _checkButton.userInteractionEnabled = NO;
    }
    return _checkButton;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        [self.view addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_backView.mas_bottom);
            make.width.equalTo(@1);
            make.height.equalTo(@(kRKBHEIGHT(40)));
            make.centerX.equalTo(self.view);
        }];
        _line.backgroundColor = [UIColor whiteColor];
    }
    return _line;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [self.view addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_line.mas_bottom);
            make.centerX.equalTo(self.view);
            make.size.equalTo(@(kRKBHEIGHT(30)));
        }];
        [_closeButton setImage:[UIImage imageNamed:@"mine_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

#pragma mark - target action
- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)checkVerCode {
    WEAKSELF
    if (!_isRegister) {
        [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/sms/sendWhenRemobile" withParams:@{@"mobile": _phoneNumber, @"picturecodevalue": _textField.textField.text, @"picturecodeid": @(_currentCaptcha.picturecodeid)} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
            if ([data[@"is"] intValue]) {
                [NSObject showHudTipStr:data[@"msg"]];
                [weakSelf dismissViewControllerAnimated:NO completion:^{
                    _currentCaptcha.picturecodevalue = _textField.textField.text;
                    weakSelf.captchaCallback(_currentCaptcha);
                }];
            } else {
                [weakSelf dismissViewControllerAnimated:NO completion:nil];
                [NSObject showHudTipStr:data[@"msg"]];
            }
        }];

    } else {
        [weakSelf dismissViewControllerAnimated:NO completion:^{
            _currentCaptcha.picturecodevalue = _textField.textField.text;
            weakSelf.captchaCallback(_currentCaptcha);
        }];
    }
}

#pragma mark - private method
- (void)getVerCode {
    WEAKSELF
    if (!_isRegister) {
        [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/outer/picturecode/get" withParams:nil withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
            if ([data[@"is"] intValue]) {
                _currentCaptcha = [CaptchaModel mj_objectWithKeyValues:data[@"data"]];
                [weakSelf.verCodeImgv sd_setImageWithURL:[NSURL URLWithString:_currentCaptcha.picturecodeurl]];
            } else {
                [NSObject showHudTipStr:data[@"msg"]];
            }
        }];
    } else {
        [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/outer/picturecode/get" withParams:nil withMethodType:Get autoShowError:NO andBlock:^(id data, NSError *error) {
            if ([data[@"is"] intValue]) {
                _currentCaptcha = [CaptchaModel mj_objectWithKeyValues:data[@"data"]];
                [weakSelf.verCodeImgv sd_setImageWithURL:[NSURL URLWithString:_currentCaptcha.picturecodeurl]];
            } else {
                [NSObject showHudTipStr:data[@"msg"]];
            }
        }];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:_backView]) {
        return NO;
    }
    return YES;
}
@end
