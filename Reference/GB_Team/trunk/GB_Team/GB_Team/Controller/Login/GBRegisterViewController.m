//
//  GBRegisterViewController.m
//  GB_Team
//
//  Created by weilai on 16/9/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBRegisterViewController.h"
#import "GBWebBrowserViewController.h"
#import "GBLoginViewController.h"
#import "GBLoginTextField.h"

#import "UserRequest.h"

@interface GBRegisterViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet GBLoginTextField *accountView;
@property (weak, nonatomic) IBOutlet GBLoginTextField *passwordView;
@property (weak, nonatomic) IBOutlet GBLoginTextField *confirmView;
@property (weak, nonatomic) IBOutlet GBLoginTextField *pinView;
@property (weak, nonatomic) IBOutlet GBHightLightButton *okButton;
@property (weak, nonatomic) IBOutlet GBCountDownButton *verifyCodeButton;

@end

@implementation GBRegisterViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBLoginViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - NSNotification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    [self checkInputValid];
}

#pragma mark - Delegate

// 字数限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.accountView.textField) {
        if(strlen([textField.text UTF8String]) >= 11 && range.length != 1)return NO;
    }else if (textField == self.passwordView.textField) {
        if(strlen([textField.text UTF8String]) >= 17 && range.length != 1)return NO;
    }else if (textField == self.confirmView.textField) {
        if(strlen([textField.text UTF8String]) >= 17 && range.length != 1)return NO;
    }else if (textField == self.pinView.textField) {
        if(strlen([textField.text UTF8String]) >= 6 && range.length != 1)return NO;
    }
    
    return YES;
}

// Done键盘回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Action

- (IBAction)actionRegistOK:(id)sender {
    
    [GBCircleHub showWithTip:LS(@"正在注册 请稍候") view:self.navigationController.topViewController.view];
    
    @weakify(self)
    [self performBlock:^{
        NSString *account = self.accountView.textField.text;
        NSString *password = self.passwordView.textField.text;
        NSString *verifyCode = self.pinView.textField.text;
        [UserRequest userRegister:account password:password verificationCode:verifyCode handler:^(id result, NSError *error) {
            
            @strongify(self)
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                
                [RawCacheManager sharedRawCacheManager].lastAccount = account;
                [RawCacheManager sharedRawCacheManager].lastPassword = password;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ShowMainView object:nil];
                
            }
            //
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [GBCircleHub hide];
            });
        }];
    } delay:1.5f];
}

- (IBAction)actionVerifyCode:(id)sender {
    
    NSString *phoneNo = self.accountView.textField.text;
    if (![phoneNo isMobileNumber]) {
        [self showToastWithText:LS(@"请输入正确的手机号码")];
        return;
    }
    
    [self showLoadingToastWithText:LS(@"正在获取验证码")];
    
    @weakify(self)
    [UserRequest pushVerificationCode:self.accountView.textField.text handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        
        if (error == nil) {
            [self.verifyCodeButton startCountDown:60];
        }
        
        NSString *tips = error?error.domain:LS(@"验证码获取成功，请注意查收。");
        [self showToastWithText:tips];
    }];
}

- (IBAction)actionServiceTerms:(id)sender {
    
    [self.navigationController pushViewController:[[GBWebBrowserViewController alloc]initWithTitle:LS(@"用户协议") url:Tgoal_User_Agreement] animated:YES];
}

#pragma mark - Private

-(void)setupUI {
    
    self.title = LS(@"注册账号");
    [self setupBackButtonWithBlock:nil];
    
    self.accountView.textField.delegate = self;
    self.passwordView.textField.delegate = self;
    self.confirmView.textField.delegate = self;
    self.pinView.textField.delegate = self;
}

- (void)checkInputValid {
    
    BOOL isValidAccount = [self.accountView.textField.text isMobileNumber];
    BOOL isValidPassword = (self.passwordView.textField.text.length >=6 && self.confirmView.textField.text.length <= 17);
    BOOL isValidPasswordAgain = [self.passwordView.textField.text isEqualToString:self.confirmView.textField.text] && isValidPassword;
    BOOL isValidVerify = (self.pinView.textField.text.length >=4);
    
    self.accountView.correct = isValidAccount;
    self.passwordView.correct = isValidPassword;
    self.confirmView.correct = isValidPasswordAgain;
    self.pinView.correct = isValidVerify;
    
    self.verifyCodeButton.enabled = isValidAccount && !self.verifyCodeButton.isCountdown;
    self.okButton.enabled = isValidAccount && isValidPassword && isValidVerify && isValidPasswordAgain;
}


@end
