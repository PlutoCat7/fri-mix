//
//  LoginViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/1.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "SupplementViewController.h"

#import "GBCountDownButton.h"
#import "UIButton+WebCache.h"

#import "CommonRequest.h"
#import "UserRequest.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *imageCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
// 验证码倒计时按钮
@property (weak, nonatomic) IBOutlet GBCountDownButton *verifyCodeButton;
// 图形验证码按钮
@property (weak, nonatomic) IBOutlet GBCountDownButton *imageCodeButton;

@property (nonatomic, strong) CaptchaInfo *captchaInfo;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self actionImageCode:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    [self checkButtonEnable];
}


#pragma mark - Action
- (IBAction)actionImageCode:(id)sender {

    [CommonRequest getLoginImageCodeWithHandler:^(id result, NSError *error) {
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            self.captchaInfo = result;
            [self.imageCodeButton sd_setImageWithURL:[NSURL URLWithString:self.captchaInfo.url] forState:UIControlStateNormal];
        }
    }];
}

// 点击获取验证码
- (IBAction)actionVerifyCode:(id)sender {
    
    NSString *phoneNo = [self.accountTextField.text removeSpace];
    self.captchaInfo.imageCode = [self.imageCodeTextField.text removeSpace];
    
    [self.verifyCodeButton setButtonEnable:NO];
    [self showLoadingToastWithText:@"验证码获取中..."];
    [CommonRequest getLoginSMSCodeWithMobile:phoneNo captcha:self.captchaInfo handler:^(id result, NSError *error) {
        
        if (error == nil) {
            [self.verifyCodeButton startCountDown:60];
            [self.passwordTextField becomeFirstResponder];
        } else {
            [self.verifyCodeButton setButtonEnable:YES];
        }
        NSString *tips = error?error.domain:@"验证码获取成功，请注意查收。";
        [self showToastWithText:tips];
    }];
}

- (IBAction)loginAction:(id)sender {
    
    NSString *phoneNo = [self.accountTextField.text removeSpace];
    NSString *smsCode = [self.passwordTextField.text removeSpace];
    [self showLoadingToastWithText:@"登录中..."];
    [UserRequest userLogin:phoneNo code:smsCode handler:^(id result, NSError *error) {
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Has_Login_In object:nil];
            if ([RawCacheManager sharedRawCacheManager].userInfo.needProfile) {
                //进入完善信息界面
                NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                [viewControllers removeLastObject];
                SupplementViewController *vc = [SupplementViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [viewControllers addObject:vc];
                [self.navigationController setViewControllers:[viewControllers copy] animated:YES];
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

- (IBAction)registerAction:(id)sender {
    
    [self.navigationController pushViewController:[RegisterViewController new] animated:YES];
}

#pragma mark - Delegate

// Done键盘回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = @"登录";
    [self setupBackButtonWithBlock:nil];
    
    self.loginButton.layer.cornerRadius = 8;
    [self.loginButton setBackgroundImage:[UIImage imageWithColor:[ColorManager styleColor]] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage imageWithColor:[ColorManager buttonDisableColor]] forState:UIControlStateDisabled];
    
    [self checkButtonEnable];
}

- (void)checkButtonEnable {
    
    NSString *phoneNo = [self.accountTextField.text removeSpace];
    NSString *smsCode = [self.passwordTextField.text removeSpace];
    BOOL enbale = [LogicManager isPhoneBumber:phoneNo] && [LogicManager isValidInputCode:smsCode];
    self.loginButton.enabled = enbale;
    
    [self.verifyCodeButton setButtonEnable:[LogicManager isPhoneBumber:phoneNo]];
}

@end
