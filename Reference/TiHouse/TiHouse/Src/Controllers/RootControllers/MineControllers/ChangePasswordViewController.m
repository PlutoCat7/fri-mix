//
//  ChangePasswordViewController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UserTextField.h"
#import "Login.h"
#import "NSString+Common.h"

@interface ChangePasswordTextField()

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation ChangePasswordTextField

- (instancetype)init {
    if (self = [super init]) {
        [self bottomLine];
        self.font = ZISIZE(13);
        self.secureTextEntry = YES;
    }
    return self;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = kColor999;
        [self addSubview:_bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return _bottomLine;
}

@end

@interface ChangePasswordViewController ()

@property (nonatomic, strong) UserTextField *originPassword;
@property (nonatomic, strong) UserTextField *currentPassword;
@property (nonatomic, strong) UserTextField *reCurrentPassword;
@property (nonatomic, strong) UIButton *changeButton;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    [self originPassword];
    [self currentPassword];
    [self reCurrentPassword];
    [self changeButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - getters && setters
- (UserTextField *)originPassword {
    if (!_originPassword) {
        _originPassword = [[UserTextField alloc] initWithPlaceholder:@"请输入原密码" IconImage:nil];
        [self.view addSubview:_originPassword];
        [_originPassword mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(kNavigationBarHeight + 30));
            make.height.equalTo(@(kRKBHEIGHT(50)));
            make.left.equalTo(@43);
            make.right.equalTo(@-43);
        }];
        _originPassword.textField.secureTextEntry = YES;
    }
    return _originPassword;
}

- (UserTextField *)currentPassword {
    if (!_currentPassword) {
        _currentPassword = [[UserTextField alloc] initWithPlaceholder:@"请输入新密码" IconImage:nil];
        [self.view addSubview:_currentPassword];
        [_currentPassword mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_originPassword.mas_bottom).offset(10);
            make.left.right.height.equalTo(_originPassword);
        }];
        _currentPassword.textField.secureTextEntry = YES;
    }
    return _currentPassword;
}

- (UserTextField *)reCurrentPassword {
    if (!_reCurrentPassword) {
        _reCurrentPassword = [[UserTextField alloc] initWithPlaceholder:@"请确认新密码" IconImage:nil];
        [self.view addSubview:_reCurrentPassword];
        [_reCurrentPassword mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_currentPassword.mas_bottom).offset(10);
            make.left.right.height.equalTo(_originPassword);
        }];
        _reCurrentPassword.textField.secureTextEntry = YES;
    }
    return _reCurrentPassword;
}

- (UIButton *)changeButton {
    if (!_changeButton) {
        _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeButton setTitle:@"确认修改密码" forState:UIControlStateNormal];
        [_changeButton setTitleColor:kLOGINBTNCOLOR forState:UIControlStateNormal];
        _changeButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
        _changeButton.backgroundColor = kTiMainBgColor;
        _changeButton.layer.cornerRadius = kRKBHEIGHT(25);
        _changeButton.layer.masksToBounds = YES;
        [_changeButton addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_changeButton];
        [_changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_reCurrentPassword.mas_bottom).offset(kRKBHEIGHT(30));
            make.height.equalTo(@(kRKBHEIGHT(50)));
            make.width.equalTo(_originPassword);
            make.centerX.equalTo(self.view);
        }];
    }
    return _changeButton;
}
         
 - (void)change {
     
     if (_originPassword.textField.text.length == 0) {
         [NSObject showHudTipStr:@"原密码不能为空"];
         return;
     }
     
     if (_currentPassword.textField.text.length == 0) {
         [NSObject showHudTipStr:@"新密码不能为空"];
         return;
     }
     
     if (_reCurrentPassword.textField.text.length == 0) {
         [NSObject showHudTipStr:@"密码确认不能为空"];
         return;
     }
     
     if (![_currentPassword.textField.text isEqualToString:_reCurrentPassword.textField.text]) {
         [NSObject showHudTipStr:@"两次输入的新密码不一致"];
         return;
     }
     
     
     NSString *md5OldPassword = [[_originPassword.textField.text md5Str] uppercaseString];
     NSString *md5NewPassword = [[_currentPassword.textField.text md5Str] uppercaseString];
     
     WEAKSELF
     [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/user/editPass" withParams:@{@"uid": [NSNumber numberWithLong:[[Login curLoginUser] uid]], @"oldpassword": md5OldPassword, @"newpassword": md5NewPassword} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
         if ([data[@"is"] intValue]) {
             [NSObject showHudTipStr:data[@"msg"]];
             [weakSelf.navigationController popViewControllerAnimated:YES];
         } else {
             [NSObject showHudTipStr:data[@"msg"]];
         }
     }];
     
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
