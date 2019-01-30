//
//  BindPhotoNumbelViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/29.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "BindPhotoNumbelViewController.h"
#import "UserTextField.h"
#import "UIViewAnimation.h"
#import "CaptchaViewController.h"
#import "CaptchaModel.h"

@interface BindPhotoNumbelViewController ()<UITextFieldDelegate>
{
    int _secondsCountDown; //倒计时总时长
    NSTimer *_countDownTimer;
}
@property (nonatomic, retain) UILabel *headerVTitle;
@property (nonatomic, retain) UIImageView *headerIcon;
@property (nonatomic, retain) UserTextField *messageCode, *photoNumbel;
@property (nonatomic, retain) UIButton *goBtn, *messageBtn;
@property (nonatomic, retain) UIView *coverView, *loginAnimView;//蒙板当用户点击注册或下一步的时候用于遮挡
@property (nonatomic,strong) CAShapeLayer *shapeLayer;//登录转圈的那条白线所在的layer
@end

@implementation BindPhotoNumbelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机号";
    // Do any additional setup after loading the view.
    
    [self headerIcon];
    [_headerIcon sd_setImageWithURL:[NSURL URLWithString:_myLogin.urlhead]];
    [self headerVTitle];
    _headerVTitle.text = _myLogin.nickname;
    [self photoNumbel];
    [self messageCode];
    [self messageBtn];
    [self goBtn];
}

// -- 登录 and 下一步Click
-(void)goClick{
    
//    if (self.myLogin.picturecodevalue.length == 0) {
//        CaptchaViewController *captchaVC = [[CaptchaViewController alloc] init];
//        captchaVC.phoneNumber = _photoNumbel.textField.text;
//        captchaVC.isRegister = YES;
//        captchaVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//        [self presentViewController:captchaVC animated:YES completion:nil];
//        [captchaVC setCaptchaCallback:^(CaptchaModel *model) {
//            self.myLogin.picturecodevalue = model.picturecodevalue;
//            self.myLogin.picturecodeid = model.picturecodeid;
//            [self goLogin];
//        }];
//    } else {
//        [self goLogin];
//    }
    
    [self goLogin];
}

#pragma mark -- 获取数据
-(void)goLogin{
    
    [self.view endEditing:YES];
    WEAKSELF
    //盖住view，以屏蔽掉点击事件
    _coverView = [[UIView alloc]initWithFrame:self.view.bounds];
    _coverView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:_coverView];
    
    //执行登录按钮转圈动画的view
    _loginAnimView = [[UIView alloc] initWithFrame:_goBtn.frame];
    _loginAnimView.layer.cornerRadius = kRKBHEIGHT(25);
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
        //让圆转圈，实现"加载中"的效果
        CABasicAnimation* baseAnimation = [UIViewAnimation getRotateAnimation];
        [_loginAnimView.layer addAnimation:baseAnimation forKey:nil];
    }];

    if (_messageCode.hidden) {
        [self SecurityCodeBtnClick:self.messageBtn];
    }else{
        _myLogin.messageCode = _messageCode.textField.text;
        [[TiHouse_NetAPIManager sharedManager] request_OpenIDOAuthLoginWithPath:[_myLogin toPath] Params:[_myLogin toParams] Block:^(id data, NSError *error) {

            if (data) {
                [Login doLogin:data];
                AppDelegate *appledate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                [appledate setupTabViewController];
            }else{
                [weakSelf GoFail];
            }
            
        }];
        
    }
    
}

/** 失败 */
- (void)GoFail
{
    //把蒙版、动画view等隐藏，把真正的login按钮显示出来
    if (_coverView) {
        _goBtn.hidden = NO;
        [_coverView removeFromSuperview];
        [_loginAnimView removeFromSuperview];
        [_loginAnimView.layer removeAllAnimations];
    }
    
    //给按钮添加左右摆动的效果(路径动画)
    CAKeyframeAnimation *keyFrame = [UIViewAnimation getSwingAnimationWithPoint:_loginAnimView.layer.position IsX:YES];
    [_goBtn.layer addAnimation:keyFrame forKey:keyFrame.keyPath];
}

/** 成功 */
- (void)GoSuccess
{
    if (!_messageCode.hidden) {
        return;
    }
    _messageCode.hidden = NO;
    [_goBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_goBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_messageCode.mas_bottom).offset(kRKBHEIGHT(40));
        make.height.equalTo(@(kRKBHEIGHT(50)));
        make.width.equalTo(_messageCode);
        make.centerX.equalTo(_messageCode);
    }];
    WEAKSELF
    [UIView animateWithDuration:0.2 animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
    //移除蒙版
    _goBtn.hidden = NO;
    [_coverView removeFromSuperview];
    [_loginAnimView removeFromSuperview];
    [_loginAnimView.layer removeAllAnimations];
}

#pragma mark 短信验证码按钮事件
-(void)SecurityCodeBtnClick:(UIButton *)btn
{
    
    _secondsCountDown = 60;
    
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    
    [_messageBtn setTitle:[NSString stringWithFormat:@"短信验证(%d)",_secondsCountDown] forState:UIControlStateNormal];
    
    _messageBtn.enabled = NO;
    
    WEAKSELF

    [[TiHouse_NetAPIManager sharedManager] request_MesssgeCodeWithPath:[_myLogin toMessagePath] Params:[_myLogin toMessageParams] Block:^(id data, NSError *error) {
        if (data) {
            [self GoSuccess];
        }else{
            [self GoFail];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendMessageCode{
    
    [[TiHouse_NetAPIManager sharedManager] request_MesssgeCodeWithPath:[_myLogin toMessagePath] Params:[_myLogin toMessageParams] Block:^(id data, NSError *error) {
        if (data) {
            
        }
    }];
    
}





#pragma mark - UITextFieldDelegate
-(void)valueChanged:(UITextField *)textField{
    
    if ([textField.text isPhoneNo] && textField.text.length == 11) {
        _goBtn.enabled = YES;
        _goBtn.alpha = 1;
    }else{
        _goBtn.enabled = NO;
        _goBtn.alpha = 0.5;
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.textColor = [UIColor blackColor];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    textField.textColor = [UIColor grayColor];
    textField.textAlignment = NSTextAlignmentLeft;
    _myLogin.phone = textField.text;
    return YES;
}

#pragma mark - getters and setters
-(UIImageView *)headerIcon{
    if (!_headerIcon) {
        _headerIcon = [[UIImageView alloc]init];
        _headerIcon.layer.cornerRadius = kRKBHEIGHT(40);
        _headerIcon.layer.masksToBounds = YES;
        _headerIcon.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_headerIcon];
        [_headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(30 + kDevice_Is_iPhoneX ? 88 : 64);
            make.size.mas_equalTo(CGSizeMake(kRKBHEIGHT(80), kRKBHEIGHT(80)));
            make.centerX.equalTo(self.view);
        }];
    }
    return _headerIcon;
}
-(UILabel *)headerVTitle{
    if (!_headerVTitle) {
        _headerVTitle = [[UILabel alloc]init];
        _headerVTitle.font = [UIFont systemFontOfSize:13];
        _headerVTitle.textColor = [UIColor blackColor];
        _headerVTitle.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_headerVTitle];
        [_headerVTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerIcon.mas_bottom).offset(kRKBHEIGHT(10));
            make.size.mas_equalTo(CGSizeMake(self.view.width, kRKBHEIGHT(20)));
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }
    return _headerVTitle;
}
-(UserTextField *)photoNumbel{
    if (!_photoNumbel) {
        _photoNumbel = [[UserTextField alloc]initWithPlaceholder:@"请输入手机号码" IconImage:nil];
        _photoNumbel.textField.textAlignment = NSTextAlignmentCenter;
        _photoNumbel.textField.delegate = self;
        _photoNumbel.textField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
        [_photoNumbel.textField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
        [self.view addSubview:_photoNumbel];
        [_photoNumbel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(43);
            make.right.equalTo(self.view).offset(-43);
            make.top.equalTo(_headerVTitle.mas_bottom).offset(kRKBHEIGHT(63));
            make.height.equalTo(@(kRKBHEIGHT(35)));
        }];
    }
    return _photoNumbel;
}
-(UserTextField *)messageCode{
    if (!_messageCode) {
        _messageCode = [[UserTextField alloc]initWithPlaceholder:@"填写验证码" IconImage:nil];
        _messageCode.textFieldInsets = UIEdgeInsetsMake(0, 0, 0, -100);
        [self.view addSubview:_messageCode];
        [_messageCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(43);
            make.right.equalTo(self.view).offset(-43);
            make.top.equalTo(_photoNumbel.mas_bottom).offset(kRKBHEIGHT(40));
            make.height.equalTo(@(kRKBHEIGHT(35)));
        }];
    }
    return _messageCode;
}

-(UIButton *)messageBtn{
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setTitle:@"重新获取(60)" forState:UIControlStateNormal];
        [_messageBtn setTitleColor:kLOGINBTNCOLOR forState:UIControlStateNormal];
        _messageBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _messageBtn.backgroundColor = kTiMainBgColor;
        _messageBtn.enabled = NO;
        _messageBtn.layer.cornerRadius = 4.0f;
        _messageBtn.layer.masksToBounds = YES;
        [_messageBtn addTarget:self action:@selector(SecurityCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_messageCode addSubview:_messageBtn];
        [_messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.top.equalTo(_messageCode);
            make.height.equalTo(@(kRKBHEIGHT(30)));
            make.width.equalTo(@(100));
        }];
        _messageCode.hidden = YES;
    }
    return _messageBtn;
}
-(UIButton *)goBtn{
    if (!_goBtn) {
        _goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_goBtn setTitleColor:kLOGINBTNCOLOR forState:UIControlStateNormal];
        _goBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:20];
        _goBtn.backgroundColor = kTiMainBgColor;
        _goBtn.layer.cornerRadius = kRKBHEIGHT(25);
        _goBtn.layer.masksToBounds = YES;
        _goBtn.enabled = NO;
        _goBtn.alpha = 0.5;
        [_goBtn addTarget:self action:@selector(goClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_goBtn];
        [_goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_photoNumbel.mas_bottom).offset(kRKBHEIGHT(40));
            make.height.equalTo(@(kRKBHEIGHT(50)));
            make.width.equalTo(_photoNumbel);
            make.centerX.equalTo(_photoNumbel);
        }];
    }
    return _goBtn;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
