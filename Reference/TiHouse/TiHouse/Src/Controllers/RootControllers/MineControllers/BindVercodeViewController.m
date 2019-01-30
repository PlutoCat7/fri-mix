//
//  BindVercodeViewController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BindVercodeViewController.h"
#import "UserTextField.h"
#import "Login.h"

@interface BindVercodeViewController () {
    int _secondsCountDown; //倒计时总时长
    NSTimer *_countDownTimer;
}
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, retain) UserTextField *messageCode;
@property (nonatomic, retain) UIButton *messageBtn;
@property (nonatomic, strong) UIButton *bindButton;

@end
NSString * const editMobileSuccessNotification = @"editMobileSuccessNotification";

@implementation BindVercodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑定新手机号码";
    [self label1];
    [self label2];
    [self messageCode];
    [self messageBtn];
    [self bindButton];
    
    WEAKSELF
    [[_messageCode.textField rac_textSignal] subscribeNext:^(id x) {
        
        if ([(NSString *)x length] > 6) {
            weakSelf.messageCode.textField.text = [weakSelf.messageCode.textField.text substringToIndex:6];
        } else if ([(NSString *)x length] == 6) {
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
        _label1.text = @"验证码短信已经发送到";
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
        _label2.text = _phoneNumber;
        _label2.textAlignment = NSTextAlignmentCenter;
        [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(_label1.mas_bottom).offset(10);
        }];
    }
    return _label2;
}

-(UserTextField *)messageCode{
    if (!_messageCode) {
        _messageCode = [[UserTextField alloc]initWithPlaceholder:@"请输入验证码" IconImage:nil];
        _messageCode.textFieldInsets = UIEdgeInsetsMake(0, 0, 0, -100);
        [self.view addSubview:_messageCode];
        [_messageCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(43);
            make.right.equalTo(self.view).offset(-43);
            make.top.equalTo(_label2.mas_bottom).offset(40);
            make.height.equalTo(@(kRKBHEIGHT(35)));
        }];
        _messageCode.textField.font = ZISIZE(14);
    }
    return _messageCode;
}

-(UIButton *)messageBtn{
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [_messageBtn setTitleColor:kLOGINBTNCOLOR forState:UIControlStateNormal];
        _messageBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _messageBtn.backgroundColor = kTiMainBgColor;
        _messageBtn.enabled = YES;
        _messageBtn.layer.cornerRadius = 4.0f;
        _messageBtn.layer.masksToBounds = YES;
        [_messageBtn addTarget:self action:@selector(SecurityCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_messageCode addSubview:_messageBtn];
        [_messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.top.equalTo(_messageCode);
            make.height.equalTo(@(kRKBHEIGHT(30)));
            make.width.equalTo(@(100));
        }];
    }
    return _messageBtn;
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
            make.top.equalTo(_messageCode.mas_bottom).offset(kRKBHEIGHT(30));
            make.height.equalTo(@(kRKBHEIGHT(50)));
            make.width.equalTo(_messageCode);
            make.centerX.equalTo(self.view);
        }];
        _bindButton.backgroundColor = [UIColor colorWithHexString:@"FEF9CF"];
        _bindButton.userInteractionEnabled = NO;
    }
    return _bindButton;
}

#pragma mark - target action
- (void)bind {
    WEAKSELF
    User *user = [Login curLoginUser];
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/user/editMobile" withParams:@{@"uid": @(user.uid), @"mobile": _phoneNumber, @"smscode": _messageCode.textField.text} withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            [NSObject showHudTipStr:data[@"msg"]];
            user.mobile = _phoneNumber;
            [[NSNotificationCenter defaultCenter] postNotificationName:editMobileSuccessNotification object:nil];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *loginData = [defaults objectForKey:@"user_dict"];
            NSMutableDictionary *newLoginData = [NSMutableDictionary dictionaryWithDictionary:loginData];
            newLoginData[@"mobile"] = _phoneNumber;
            [defaults setObject:newLoginData forKey:@"user_dict"];
            [defaults synchronize];
            
            [self.navigationController popToViewController:weakSelf.navigationController.viewControllers[2] animated:YES];
            
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
}

-(void)SecurityCodeBtnClick
{
    _secondsCountDown = 60;
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    //    [_messageBtn setTitle:[NSString stringWithFormat:@"短信验证(%d)",_secondsCountDown] forState:UIControlStateNormal];
    [_messageBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)",_secondsCountDown] forState:UIControlStateNormal];
    
    _messageBtn.enabled = NO;
    
//    _myLogin.phone = _phone.textField.text;
//    NSMutableDictionary *dic = [NSMutableDictionary new];
//    [dic setValue:_myLogin.phone forKey:@"mobile"];
    [[TiHouse_NetAPIManager sharedManager] request_MesssgeCodeWithPath:@"api/inter/sms/sendWhenRemobile" Params:@{@"mobile": _phoneNumber} Block:^(id data, NSError *error) {
        if (!data) {
            [_countDownTimer invalidate];
            [_messageBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            _messageBtn.enabled = YES;
            [_countDownTimer invalidate];
            _countDownTimer = nil;
        }
    }];
}

-(void)timeFireMethod{
    //倒计时-1
    _secondsCountDown--;
    //修改倒计时标签现实内容
    [_messageBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)",_secondsCountDown] forState:UIControlStateNormal];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(_secondsCountDown==0 || _secondsCountDown < 0){
        [_countDownTimer invalidate];
        [_messageBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        _messageBtn.enabled = YES;
        [_countDownTimer invalidate];
        _countDownTimer = nil;
    }
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
