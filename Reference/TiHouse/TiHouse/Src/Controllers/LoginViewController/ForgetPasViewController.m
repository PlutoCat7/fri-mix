//
//  LoginViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/25.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "ForgetPasViewController.h"
#import "UserTextField.h"
#import "UIViewAnimation.h"
#import "BaseNavigationController.h"
#import "HXPhotoPicker.h"

#import "TOCropViewController.h"
#import "CaptchaViewController.h"
#import "CaptchaModel.h"

@interface ForgetPasViewController ()
{
    int _secondsCountDown; //倒计时总时长
    NSTimer *_countDownTimer;
}
@property (nonatomic, retain) UIButton *goBtn, *messageBtn;
@property (nonatomic, retain) UserTextField *messageCode, *phone;
@property (nonatomic, assign) BOOL isSetNewPas;
@property (nonatomic, retain) UIView *coverView, *loginAnimView;//蒙板当用户点击注册或下一步的时候用于遮挡
@property (nonatomic,strong) CAShapeLayer *shapeLayer;//登录转圈的那条白线所在的layer

@end

@implementation ForgetPasViewController


#pragma mark - lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _isSetNewPas = NO;
    [self wr_setNavBarBarTintColor:XWColorFromHex(0xfcfcfc)];
    self.title = @"忘记密码";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self setup];
    
    _myLogin = [[Login alloc]init];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [(BaseNavigationController *)self.navigationController  showNavBottomLine];
}

-(void)setup{
    
    [self phone];
    [self messageCode];
    [self messageBtn];
    [self goBtn];
}

#pragma mark - UITableViewDelegate

#pragma mark - CustomDelegate

#pragma mark - event response

#pragma mark 短信验证码按钮事件
-(void)SecurityCodeBtnClick
{
    
//    CaptchaViewController *captchaVC = [[CaptchaViewController alloc] init];
//    captchaVC.phoneNumber = _phone.textField.text;
//    captchaVC.isRegister = YES;
//    captchaVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    [self presentViewController:captchaVC animated:YES completion:nil];
//    [captchaVC setCaptchaCallback:^(CaptchaModel *model) {
//        _secondsCountDown = 60;
//        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
//        [_messageBtn setTitle:[NSString stringWithFormat:@"短信验证(%d)",_secondsCountDown] forState:UIControlStateNormal];
//        _messageBtn.enabled = NO;
//
//        _myLogin.phone = _phone.textField.text;
//        NSMutableDictionary *dic = [NSMutableDictionary new];
//        [dic setValue:_myLogin.phone forKey:@"mobile"];
//        [dic setValue:model.picturecodevalue forKey:@"picturecodevalue"];
//        [dic setValue:@(model.picturecodeid) forKey:@"picturecodeid"];
//        [[TiHouse_NetAPIManager sharedManager] request_MesssgeCodeWithPath:@"api/outer/sms/sendWhenForget" Params:dic Block:^(id data, NSError *error) {
//            if (!data) {
//                [_countDownTimer invalidate];
//                [_messageBtn setTitle:@"重新获取" forState:UIControlStateNormal];
//                _messageBtn.enabled = YES;
//                [_countDownTimer invalidate];
//                _countDownTimer = nil;
//            }
//        }];
//    }];
    _secondsCountDown = 60;
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    [_messageBtn setTitle:[NSString stringWithFormat:@"短信验证(%d)",_secondsCountDown] forState:UIControlStateNormal];
    _messageBtn.enabled = NO;
    
    _myLogin.phone = _phone.textField.text;
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:_myLogin.phone forKey:@"mobile"]; 
    [[TiHouse_NetAPIManager sharedManager] request_MesssgeCodeWithPath:@"api/outer/sms/sendWhenForget" Params:dic Block:^(id data, NSError *error) {
        if (!data) {
            [_countDownTimer invalidate];
            [_messageBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            _messageBtn.enabled = YES;
            [_countDownTimer invalidate];
            _countDownTimer = nil;
        }
    }];
}

//定时器用于短信验证
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

#pragma mark - private methods 私有方法
#pragma mark -- 登录 and 下一步Click
-(void)goClick{
    
    [self.view endEditing:YES];
    WEAKSELF
    //盖住view，以屏蔽掉点击事件
    _coverView = [[UIView alloc]initWithFrame:self.view.bounds];
    _coverView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:_coverView];
    
    //执行登录按钮转圈动画的view
    _loginAnimView = [[UIView alloc] initWithFrame:_goBtn.frame];
    _loginAnimView.layer.cornerRadius = 25;
    _loginAnimView.layer.masksToBounds = YES;
    _loginAnimView.backgroundColor = _goBtn.backgroundColor;
    [self.view addSubview:_loginAnimView];
    _goBtn.hidden = YES;
    //把view从宽的样子变圆
    CGPoint centerPoint = self.loginAnimView.center;
    CGFloat radius = MIN(self.loginAnimView.frame.size.width, self.loginAnimView.frame.size.height);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.loginAnimView.frame = CGRectMake(0, 0, radius, radius);
        weakSelf.loginAnimView.center = centerPoint;
        weakSelf.loginAnimView.layer.cornerRadius = radius/2;
        weakSelf.loginAnimView.layer.masksToBounds = YES;
    }completion:^(BOOL finished) {
        //给圆加一条不封闭的白色曲线
        weakSelf.shapeLayer = [UIViewAnimation getCircleWithRadius:radius BackgroundColor:weakSelf.loginAnimView.backgroundColor];
        [_loginAnimView.layer addSublayer:self.shapeLayer];
        [weakSelf.loginAnimView.layer addSublayer:weakSelf.shapeLayer];
        //让圆转圈，实现"加载中"的效果
        CABasicAnimation* baseAnimation = [UIViewAnimation getRotateAnimation];
        [_loginAnimView.layer addAnimation:baseAnimation forKey:nil];
    }];
    [self goLogin];
}

#pragma mark -- 获取数据
-(void)goLogin{
    WEAKSELF
    
    if (_isSetNewPas) {
        
        if (![_messageCode.textField.text isEqualToString:_phone.textField.text]) {
            [NSObject showHudTipStr:@"两个密码不一样！"];
            [self loginFail];
            return;
        }
        if (_messageCode.textField.text.length < 6) {
            [NSObject showHudTipStr:@"密码不能低于六位！"];
            [self loginFail];
            return;
        }
        _myLogin.password = [[_messageCode.textField.text md5Str] uppercaseString];
        [[TiHouse_NetAPIManager sharedManager] request_MesssgeCodeWithPath:@"api/outer/user/editPassWhenForget" Params:@{@"mobile":_myLogin.phone ,@"password":_myLogin.password ,@"smsCode":_myLogin.messageCode} Block:^(id data, NSError *error) {
            if (data) {
                [weakSelf loginSuccess];
                [NSObject showHudTipStr:@"修改成功！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //跳转到另一个控制器
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [weakSelf loginFail];
                
                _isSetNewPas = NO;
                _goBtn.hidden = NO;
                [_coverView removeFromSuperview];
                [_loginAnimView removeFromSuperview];
                [_loginAnimView.layer removeAllAnimations];
                
                [_goBtn setTitle:@"下一步" forState:UIControlStateNormal];
                _messageCode.textFieldInsets = UIEdgeInsetsMake(0, 0, 0, -100);
                _messageCode.textField.placeholder = @"请输入验证码";
                _messageCode.textField.text = @"";
                _messageCode.textField.secureTextEntry = NO;
                _phone.textField.placeholder = @"请输入手机号";
                _phone.textField.text = _myLogin.phone;
                _messageBtn.hidden = NO;
                _phone.textField.secureTextEntry = NO;
                _phone.textField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
            }
            
        }];
    }else{
        
        _myLogin.messageCode = _messageCode.textField.text;
        _myLogin.phone = _phone.textField.text;
        if (_myLogin.messageCode.length == 0) {
            [NSObject showHudTipStr:@"请输入短信验证码"];
            [self loginFail];
            return;
        }
        
        _isSetNewPas = YES;
        _goBtn.hidden = NO;
        [_coverView removeFromSuperview];
        [_loginAnimView removeFromSuperview];
        [_loginAnimView.layer removeAllAnimations];
        
        [_goBtn setTitle:@"提交" forState:UIControlStateNormal];
        _messageCode.textFieldInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _messageCode.textField.placeholder = @"请确认新密码";
        _messageCode.textField.text = @"";
        _messageCode.textField.secureTextEntry = YES;
        _phone.textField.placeholder = @"请输入新密码";
        _phone.textField.text = @"";
        _messageBtn.hidden = YES;
        _phone.textField.secureTextEntry = YES;
        _phone.textField.keyboardType = UIKeyboardTypeDefault;
        
        
        
    }
    
    
    

    
}

/** 登录失败 */
- (void)loginFail
{
    //把蒙版、动画view等隐藏，把真正的login按钮显示出来
    _goBtn.hidden = NO;
    [_coverView removeFromSuperview];
    [_loginAnimView removeFromSuperview];
    [_loginAnimView.layer removeAllAnimations];
    
    //给按钮添加左右摆动的效果(路径动画)
    CAKeyframeAnimation *keyFrame = [UIViewAnimation getSwingAnimationWithPoint:_loginAnimView.layer.position IsX:YES];
    [_goBtn.layer addAnimation:keyFrame forKey:keyFrame.keyPath];
}

/** 登录成功 */
- (void)loginSuccess
{
    //移除蒙版
    _goBtn.hidden = NO;
    [_coverView removeFromSuperview];
    [_loginAnimView removeFromSuperview];
    [_loginAnimView.layer removeAllAnimations];
}


#pragma mark - getters and setters

-(UserTextField *)phone{
    if (!_phone) {
        _phone = [[UserTextField alloc]initWithPlaceholder:@"请输入手机号" IconImage:nil];
        _phone.textField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
        [self.view addSubview:_phone];
        [_phone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(43);
            make.right.equalTo(self.view).offset(-43);
            make.top.equalTo(self.view).offset(60 + (kDevice_Is_iPhoneX ? 88 : 64));
            make.height.equalTo(@(kRKBHEIGHT(35)));
        }];
    }
    return _phone;
}

-(UserTextField *)messageCode{
    if (!_messageCode) {
        _messageCode = [[UserTextField alloc]initWithPlaceholder:@"请输入验证码" IconImage:nil];
        _messageCode.textFieldInsets = UIEdgeInsetsMake(0, 0, 0, -100);
        [self.view addSubview:_messageCode];
        [_messageCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(43);
            make.right.equalTo(self.view).offset(-43);
            make.top.equalTo(_phone.mas_bottom).offset(40);
            make.height.equalTo(@(kRKBHEIGHT(35)));
        }];
    }
    return _messageCode;
}

-(UIButton *)messageBtn{
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
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


-(UIButton *)goBtn{
    if (!_goBtn) {
        _goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_goBtn setTitleColor:kLOGINBTNCOLOR forState:UIControlStateNormal];
        _goBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:20];
        _goBtn.backgroundColor = kTiMainBgColor;
        _goBtn.layer.cornerRadius = kRKBHEIGHT(25);
        _goBtn.layer.masksToBounds = YES;
        [_goBtn addTarget:self action:@selector(goClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_goBtn];
        [_goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_messageCode.mas_bottom).offset(40);
            make.height.equalTo(@(kRKBHEIGHT(50)));
            make.width.equalTo(_messageCode);
            make.centerX.equalTo(_messageCode);
        }];
    }
    return _goBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
