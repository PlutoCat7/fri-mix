//
//  BindNewPhoneController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BindNewPhoneController.h"
#import "UserTextField.h"
#import "CaptchaViewController.h"
#import "BindVercodeViewController.h"

@interface BindNewPhoneController ()

@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UserTextField *textField;
@property (nonatomic, strong) UIButton *bindButton;

@end

@implementation BindNewPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑定新手机号码";
    [self label1];
    [self label2];
    [self.textField becomeFirstResponder];
    [self bindButton];
    WEAKSELF
    [[_textField.textField rac_textSignal] subscribeNext:^(id x) {
        
        if ([(NSString *)x length] > 11) {
            weakSelf.textField.textField.text = [weakSelf.textField.textField.text substringToIndex:11];
        } else if ([(NSString *)x length] == 11) {
            weakSelf.bindButton.backgroundColor = kTiMainBgColor;
            weakSelf.bindButton.userInteractionEnabled = YES;
        } else {
            weakSelf.bindButton.backgroundColor = [UIColor colorWithHexString:@"FEF9CF"];
            weakSelf.bindButton.userInteractionEnabled = NO;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters && setters

- (UILabel *)label1 {
    if (!_label1) {
        _label1 = [[UILabel alloc] init];
        [self.view addSubview: _label1];
        _label1.textColor = [UIColor colorWithHexString:@"999999"];
        _label1.font = ZISIZE(13);
        _label1.text = @"为保护账号安全，请绑定手机号码";
        _label1.textAlignment = NSTextAlignmentCenter;
        [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(@(kNavigationBarHeight + 30));
        }];
        
    }
    return _label1;
}

- (UILabel *)label2 {
    if (!_label2) {
        _label2 = [[UILabel alloc] init];
        [self.view addSubview: _label2];
        _label2.textColor = [UIColor colorWithHexString:@"999999"];
        _label2.font = ZISIZE(13);
        _label2.text = @"绑定后，您可以使用该手机号码登录有数啦。";
        _label2.textAlignment = NSTextAlignmentCenter;
        [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_label1.mas_bottom).offset(10);
        }];
    }
    return _label2;
}

- (UserTextField *)textField {
    if (!_textField) {
        _textField = [[UserTextField alloc] initWithPlaceholder:@"请输入手机号" IconImage:nil];
        _textField.textField.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label2.mas_bottom).offset(30);
            make.height.equalTo(@(kRKBHEIGHT(50)));
            make.left.equalTo(@43);
            make.right.equalTo(@-43);
        }];
        _textField.textField.font = ZISIZE(16);
    }
    
    return _textField;
}


- (UIButton *)bindButton {
    if (!_bindButton) {
        _bindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bindButton setTitle:@"绑定" forState:UIControlStateNormal];
        [_bindButton setTitleColor:kLOGINBTNCOLOR forState:UIControlStateNormal];
        _bindButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
        _bindButton.layer.cornerRadius = kRKBHEIGHT(25);
        _bindButton.layer.masksToBounds = YES;
        [_bindButton addTarget:self action:@selector(bind) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_bindButton];
        [_bindButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textField.mas_bottom).offset(kRKBHEIGHT(30));
            make.height.equalTo(@(kRKBHEIGHT(50)));
            make.width.equalTo(_textField);
            make.centerX.equalTo(self.view);
        }];
        _bindButton.backgroundColor = [UIColor colorWithHexString:@"FEF9CF"];
        _bindButton.userInteractionEnabled = NO;
    }
    return _bindButton;
}

#pragma mark - target action
- (void)bind {
//    WEAKSELF;
    BindVercodeViewController *verVC = [[BindVercodeViewController alloc] init];
    //        verVC.verCode = verCode;
    verVC.phoneNumber = self.textField.textField.text;
//    verVC.captchaModel = model;
    [self.navigationController pushViewController:verVC animated:YES];
//    CaptchaViewController *captchaVC = [CaptchaViewController new];
//    [captchaVC setCaptchaCallback:^(CaptchaModel *model) {
//
//    }];
//    captchaVC.phoneNumber = _textField.textField.text;
//    captchaVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    [self presentViewController:captchaVC animated:YES completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
