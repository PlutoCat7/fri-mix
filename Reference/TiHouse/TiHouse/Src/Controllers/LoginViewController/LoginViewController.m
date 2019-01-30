//
//  LoginViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/25.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "LoginViewController.h"
#import "SetUsetInfoViewController.h"
#import "BaseNavigationController.h"
#import "BindPhotoNumbelViewController.h"
#import "ForgetPasViewController.h"
#import "UIViewAnimation.h"
#import "DHGuidePageHUD.h"
#import "UserTextField.h"
#import "AppDelegate.h"
#import "LoginOpenIDOAuthView.h"
#import <WXApiObject.h>
#import <UMSocialCore/UMSocialCore.h>
#import "Login.h"
#import "AnimationBtnLogin.h"
#import <RongIMLib/RongIMLib.h>
#import <RongIMKit/RongIMKit.h>
#import "CaptchaModel.h"
#import "CaptchaViewController.h"
static BOOL IsLogin;
@interface LoginViewController ()

@property (nonatomic, retain) UIImageView *headerView, *arrowsIcon;
@property (nonatomic, retain) UIButton *loginBtn, *registerBtn, *goBtn, *forgetPas;
@property (nonatomic, retain) UserTextField *PhoneNumber, *Password;
@property (nonatomic, retain) LoginOpenIDOAuthView *openIDOAuthView;
@property (nonatomic, retain) Login *myLogin;
@property (nonatomic, retain) AnimationBtnLogin *BtnLogin;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) CaptchaModel *currentCaptcha;
@end

@implementation LoginViewController


#pragma mark - lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self wr_setNavBarBarTintColor:[UIColor clearColor]];
    [self wr_setNavBarTitleColor:kRKBNAVBLACK];
    [self wr_setNavBarTintColor:kRKBNAVBLACK];
    // Do any additional setup after loading the view.
    _BtnLogin= [[AnimationBtnLogin alloc]init];
    // 静态引导页
    if (![Login isFirst]) {
        //        [self setStaticGuidePage];
        [self getStaticGuide];
    }
    self.myLogin = [[Login alloc] init];
    IsLogin = YES;
    [self setup];
    
    //监听微信登录通知返回code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetWXXode:) name:@"GETWXCode" object:nil];
    //监听广告业显示完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xhLaunchAdShowFinish) name:@"xhLaunchAdShowFinish" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xhLaunchAdWillFinish) name:@"xhLaunchAdWillFinish" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [(BaseNavigationController *)self.navigationController  hideNavBottomLine];
    
    if (!IsLogin) {
        [self ClickBtn:_loginBtn];
    }
    
    [self xhLaunchAdShowFinish];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self xhLaunchAdWillFinish];
}


-(void)setup{
    
    [self headerView];
    [self loginBtn];
    [self registerBtn];
    [self arrowsIcon];
    [self PhoneNumber];
    [self Password];
    [self goBtn];
    [self forgetPas];
    [self openIDOAuthView];
    
}

#pragma mark - event response
-(void)ClickBtn:(UIButton *)btn{
    
    IsLogin = !IsLogin;
    if (btn.tag == 10) {//登录
        btn.enabled = NO;
        _registerBtn.enabled = YES;
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:20];
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setUpandDownGoBtnAnimation];
    }else{//注册
        btn.enabled = NO;
        _loginBtn.enabled = YES;
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:20];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setUpandDownGoBtnAnimation];
    }
    [_arrowsIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn.mas_centerX);
        make.bottom.equalTo(_headerView.mas_bottom);
    }];
    
    WEAKSELF
    [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        [weakSelf.headerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        //弹簧动画
        CAKeyframeAnimation *animarion = [CAKeyframeAnimation animation];
        animarion.keyPath = @"transform.scale";
        animarion.values = @[@1.0,@1.2,@0.9,@1.15,@0.95,@1.02,@1];
        animarion.duration = 0.8;
        animarion.calculationMode = kCAAnimationCubic;
        [btn.layer addAnimation:animarion forKey:nil];
    }];
}

// -- 忘记密码
-(void)forgetPasClick{
    
    [self.navigationController pushViewController:[ForgetPasViewController new] animated:YES];
}


-(void)getStaticGuide{
//    WEAKSELF
//    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/outer/guide/listStatus1" withParams:nil withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
//        if ([data[@"is"] intValue]) {
//            NSArray *dataArr = data[@"data"];
//            NSMutableArray *urlArr = [NSMutableArray new];
//            for (int i = 0; i<dataArr.count; i++) {
//                NSDictionary *dic = dataArr[i];
//                [urlArr addObject:dic[@"urlpic"]];
//            }
//            [weakSelf setStaticGuidePage:urlArr];
//        }else{
//        }
//
//    }];
    if (kDevice_Is_iPhoneX) {
        [self setStaticGuidePage:@[@"boot_page1_1125",@"boot_page2_1125", @"boot_page3_1125"]];
    } else if (kDevice_Is_iPhone6Plus){
        [self setStaticGuidePage:@[@"boot_page1_1080",@"boot_page2_1080", @"boot_page3_1080"]];
    } else if (kDevice_Is_iPhone6) {
        [self setStaticGuidePage:@[@"boot_page1_750",@"boot_page2_750", @"boot_page3_750"]];
    } else {
        [self setStaticGuidePage:@[@"boot_page1_640",@"boot_page2_640", @"boot_page3_640"]];
    }
}


#pragma mark - 设置APP静态图片引导页
- (void)setStaticGuidePage:(NSArray *)imageNameArray {
    //    NSArray *imageNameArray = @[@"yindao1",@"yindao2"];
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.view.frame imageNameArray:imageNameArray buttonIsHidden:NO];
    WEAKSELF
    guidePage.HiddenBlock = ^{
        [weakSelf.openIDOAuthView showItems];
    };
    guidePage.lastImageBlock = ^{
        [weakSelf.openIDOAuthView hideItems];
    };
    guidePage.slideInto = YES;
    [self.navigationController.view addSubview:guidePage];
}
#pragma mark - private methods 私有方法
// -- 登录 and 注册  --动画效果
-(void)setUpandDownGoBtnAnimation{
    
    if (IsLogin) {
        [_goBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_goBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_Password.mas_bottom).offset(kRKBHEIGHT(40));
            make.height.equalTo(@(kRKBHEIGHT(50)));
            make.width.equalTo(_Password);
            make.centerX.equalTo(_Password);
        }];
        WEAKSELF
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.Password.alpha = 1;
            weakSelf.forgetPas.alpha = 1;
            [weakSelf.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            weakSelf.Password.hidden = NO;
            weakSelf.forgetPas.hidden = NO;
        }];
    }else{
        [_goBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_goBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_PhoneNumber.mas_bottom).offset(kRKBHEIGHT(40));
            make.height.equalTo(@(kRKBHEIGHT(50)));
            make.width.equalTo(_Password);
            make.centerX.equalTo(self.view);
        }];
        WEAKSELF
        [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
            weakSelf.Password.alpha = 0;
            weakSelf.forgetPas.alpha = 0;
            [weakSelf.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            weakSelf.Password.hidden = YES;
            weakSelf.forgetPas.hidden = YES;
        }];
    }
    
}
#pragma mark -- 获取数据
-(void)goClick{
    [self.view endEditing:YES];
    WEAKSELF
    if (IsLogin) {
        _myLogin.phone = _PhoneNumber.textField.text;
        _myLogin.password = _Password.textField.text;
        _myLogin.goToPath = GoToPathTypeLogin;
        [_BtnLogin AnimationBtnLoginWithTagView:_goBtn];
        [[TiHouse_NetAPIManager sharedManager] request_OpenIDOAuthLoginWithPath:[_myLogin toPath] Params:[_myLogin toParams] Block:^(id data, NSError *error) {
            if (data) {
                //移除蒙版
                [_BtnLogin RemoveAnimationBtnLogin];
                //跳转到另一个控制器
                AppDelegate *appledate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                [appledate setupTabViewController];
                [Login doLogin:data];
                
                User *user = [Login curLoginUser];
                [[RCIM sharedRCIM] connectWithToken:user.rongcloudToken success:^(NSString *userId) {
                    NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                } error:^(RCConnectErrorCode status) {
                    NSLog(@"登陆的错误码为:%ld", (long)status);
                } tokenIncorrect:^{
                    NSLog(@"token错误");
                }];
            }else{
                [_BtnLogin LoginFail];
            }
        }];
        
    } else {
        if ([self.PhoneNumber.textField.text isPhoneNo] && self.PhoneNumber.textField.text.length == 11) {
            
//            // 图形验证码
//            CaptchaViewController *captchaVC = [[CaptchaViewController alloc] init];
//            captchaVC.phoneNumber = _PhoneNumber.textField.text;
//            captchaVC.isRegister = YES;
//            captchaVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//            [self presentViewController:captchaVC animated:YES completion:nil];
//            weakSelf.goBtn.hidden = NO;
//            [_BtnLogin RemoveAnimationBtnLogin];
//            [captchaVC setCaptchaCallback:^(CaptchaModel *model) {
//                weakSelf.myLogin.phone = self.PhoneNumber.textField.text ;
//                weakSelf.myLogin.goToPath = GoToPathTypeRegister;
//                weakSelf.myLogin.picturecodevalue = model.picturecodevalue;
//                weakSelf.myLogin.picturecodeid = model.picturecodeid;
//
//                [[TiHouse_NetAPIManager sharedManager] request_MesssgeCodeWithPath:[_myLogin toMessagePath] Params:[_myLogin toMessageParams] Block:^(id data, NSError *error) {
//                    if (!data) {
//                        [_BtnLogin LoginFail];
//                    }else{
//                        weakSelf.goBtn.hidden = NO;
//                        [_BtnLogin RemoveAnimationBtnLogin];
//                        SetUsetInfoViewController *SetuserInfo = [[SetUsetInfoViewController alloc]init];
//                        SetuserInfo.myLogin = weakSelf.myLogin;
//                        [self.navigationController pushViewController:SetuserInfo animated:YES];
//                    }
//                }];
//
//            }];
            [[TiHouse_NetAPIManager sharedManager] request_checkMobileHasBeenRegistedWithMobile:self.PhoneNumber.textField.text completedUsing:^(id data, NSError *error) {
                if (data)
                {
                    SetUsetInfoViewController *SetuserInfo = [[SetUsetInfoViewController alloc]init];
                    self.myLogin.phone = self.PhoneNumber.textField.text;
                    self.myLogin.goToPath = GoToPathTypeRegister;
                    SetuserInfo.myLogin = self.myLogin;
                    [self.navigationController pushViewController:SetuserInfo animated:YES];
                }
            }];
        }else{
            [_BtnLogin LoginFail];
        }
    }
}

-(void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //    req.openID = @"wx80adb0396c4f846d";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

#pragma mark -- qq 微博登录回调信息
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    WEAKSELF
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        if (error) {
            [NSObject hideHUDQuery];
            _isLogin = NO;
        }else{
            UMSocialUserInfoResponse *resp = result;
            // 授权数据
            weakSelf.myLogin.access_token = resp.accessToken;
            //            weakSelf.myLogin.openid = resp.openid;
            [weakSelf getOpenIDOAuthUserInfoWithAccessToken];
        }
    }];
}
//获取第三方用户信息
-(void)getOpenIDOAuthUserInfoWithAccessToken{
    
    if (!_myLogin.isOpenIDOAuth) {
        return;
    }
    if (_myLogin.access_token.length<= 0 && _myLogin.code.length <= 0) {
        return;
    }
    [NSObject showHUDQueryStr:nil];
    WEAKSELF
    NSLog(@"唤醒微信");
    [[TiHouse_NetAPIManager sharedManager] request_OpenIDOAuthUserInfoWithPath:[_myLogin toPath] Params:[_myLogin toParams] Block:^(id data, NSError *error) {
        _isLogin = NO;
        
        if (!data) {
            [NSObject hideHUDQuery];
            return;
        }
        if ([data isKindOfClass:[Login class]]) {
            Login *login = (Login *)data;
            BindPhotoNumbelViewController *BindPhotoVC = [BindPhotoNumbelViewController new];
            BindPhotoVC.myLogin = login;
            login.goToPath = _myLogin.goToPath;
            [weakSelf.navigationController pushViewController:BindPhotoVC animated:YES];
            [NSObject hideHUDQuery];
        }
        if ([data isKindOfClass:[User class]]) {
            [NSObject hideHUDQuery];
            //跳转到另一个控制器
            AppDelegate *appledate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [appledate setupTabViewController];
        }
        
    }];
    
}

//微信回调code
-(void)GetWXXode:(NSNotification *)notification{
    NSLog(@"微信回调");
    NSDictionary *dic = notification.userInfo;
    _myLogin.code = dic[@"code"];
    [self getOpenIDOAuthUserInfoWithAccessToken];
}

-(void)xhLaunchAdShowFinish{
    [self.openIDOAuthView showItems];
}
-(void)xhLaunchAdWillFinish{
    [self.openIDOAuthView hideItems];
}

#pragma mark - getters and setters
-(UIImageView *)headerView{
    if (!_headerView) {
        _headerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LoginHeader_image"]];
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.userInteractionEnabled = YES;
        [self.view addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(@(kRKBHEIGHT(200)));
        }];
    }
    return _headerView;
}

-(UIImageView *)arrowsIcon{
    if (!_arrowsIcon) {
        _arrowsIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrows"]];
        _arrowsIcon.contentMode = UIViewContentModeScaleAspectFill;
        _arrowsIcon.userInteractionEnabled = YES;
        [_headerView addSubview:_arrowsIcon];
        [_arrowsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_headerView).offset(1);
            make.size.mas_equalTo(CGSizeMake(16, 10));
            make.centerX.equalTo(_loginBtn.mas_centerX);
        }];
    }
    return _headerView;
}

-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:kLOGINBTNCOLOR forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:20];
        _loginBtn.tag = 10;
        _loginBtn.enabled = NO;
        [_loginBtn addTarget:self action:@selector(ClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:_loginBtn];
        [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView).offset(70);
            make.bottom.equalTo(_headerView.mas_bottom);
            make.height.equalTo(@(kRKBHEIGHT(40)));
            make.width.equalTo(@(50));
        }];
    }
    return _loginBtn;
}

-(UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:kLOGINBTNCOLOR forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _registerBtn.tag = 20;
        _registerBtn.enabled = YES;
        [_registerBtn addTarget:self action:@selector(ClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:_registerBtn];
        [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headerView).offset(-70);
            make.bottom.equalTo(_headerView);
            make.height.equalTo(@(kRKBHEIGHT(40)));
            make.width.equalTo(@(50));
        }];
    }
    return _loginBtn;
}

-(UserTextField *)PhoneNumber{
    if (!_PhoneNumber) {
        _PhoneNumber = [[UserTextField alloc]initWithPlaceholder:@"手机号" IconImage:@"phone_icon"];
        _PhoneNumber.textField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
        [_PhoneNumber.textField setValue:XWColorFromHex(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        [self.view addSubview:_PhoneNumber];
        [_PhoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(43);
            make.right.equalTo(self.view).offset(-43);
            make.top.equalTo(_headerView.mas_bottom).offset(kRKBHEIGHT(44));
            make.height.equalTo(@(kRKBHEIGHT(35)));
        }];
    }
    return _PhoneNumber;
}


-(UserTextField *)Password{
    if (!_Password) {
        _Password = [[UserTextField alloc]initWithPlaceholder:@"密码" IconImage:@"lock_icon"];
        [_Password.textField setValue:XWColorFromHex(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        _Password.textField.secureTextEntry = YES;
        [self.view addSubview:_Password];
        [_Password mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(43);
            make.right.equalTo(self.view).offset(-43);
            make.top.equalTo(_PhoneNumber.mas_bottom).offset(kRKBHEIGHT(33));
            make.height.equalTo(@(kRKBHEIGHT(35)));
        }];
    }
    return _Password;
}

-(UIButton *)goBtn{
    if (!_goBtn) {
        _goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_goBtn setTitleColor:kLOGINBTNCOLOR forState:UIControlStateNormal];
        _goBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:20];
        _goBtn.backgroundColor = kTiMainBgColor;
        _goBtn.layer.cornerRadius = kRKBHEIGHT(25);
        _goBtn.layer.masksToBounds = YES;
        [_goBtn addTarget:self action:@selector(goClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_goBtn];
        [_goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_Password.mas_bottom).offset(kRKBHEIGHT(40));
            make.height.equalTo(@(kRKBHEIGHT(50)));
            make.width.equalTo(_Password);
            make.centerX.equalTo(_Password);
        }];
    }
    return _goBtn;
}

-(UIButton *)forgetPas{
    if (!_forgetPas) {
        _forgetPas = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPas setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPas setTitleColor:XWColorFromHex(0x5186aa) forState:UIControlStateNormal];
        _forgetPas.titleLabel.font = [UIFont systemFontOfSize:13 weight:20];
        [_forgetPas addTarget:self action:@selector(forgetPasClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_forgetPas];
        [_forgetPas sizeToFit];
        [_forgetPas mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_goBtn.mas_bottom).offset(kRKBHEIGHT(20));
            make.centerX.equalTo(_goBtn);
            make.size.mas_equalTo(_forgetPas.size);
        }];
    }
    return _forgetPas;
}

-(LoginOpenIDOAuthView *)openIDOAuthView{
    if (!_openIDOAuthView) {
        _openIDOAuthView = [[LoginOpenIDOAuthView alloc]initWithFrame:CGRectMake(0, kScreen_Height - kRKBHEIGHT(125), kScreen_Width, kRKBHEIGHT(125))];
        [self.view addSubview:_openIDOAuthView];
        _myLogin.isOpenIDOAuth = YES;
        WEAKSELF
        _openIDOAuthView.click = ^(NSInteger itemIndex) {
            if (weakSelf.isLogin) {
                return ;
            }
            if (itemIndex == 0) {
                if (![WXApi isWXAppInstalled]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"你未安装微信，请使用其他方式登录！" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil,nil];
                    [alert show];
                    return;
                }
                weakSelf.isLogin = YES;
                weakSelf.myLogin.goToPath = GoToPathTypeWechat;
                [weakSelf sendAuthRequest];
            }
            if (itemIndex == 1){
                if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_Sina)]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"你未安装微博，请使用其他方式登录！" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil,nil];
                    [alert show];
                    return;
                }
                weakSelf.isLogin = YES;
                weakSelf.myLogin.goToPath = GoToPathTypeWeibo;
                [weakSelf getUserInfoForPlatform:UMSocialPlatformType_Sina];
            }
            if (itemIndex == 2) {
                if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_QQ)]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"你未安装QQ，请使用其他方式登录！" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil,nil];
                    [alert show];
                    return;
                }
                weakSelf.isLogin = YES;
                weakSelf.myLogin.goToPath = GoToPathTypeQQ;
                [weakSelf getUserInfoForPlatform:UMSocialPlatformType_QQ];
            }
        };
    }
    return _openIDOAuthView;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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


