//
//  GBModifyAccViewController.m
//  GB_Team
//
//  Created by weilai on 16/9/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBModifyAccViewController.h"
#import "GBLoginTextField.h"

#import "UserRequest.h"

@interface GBModifyAccViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet GBLoginTextField *accountView;
@property (weak, nonatomic) IBOutlet GBLoginTextField *passwordView;
@property (weak, nonatomic) IBOutlet GBLoginTextField *pinView;
@property (weak, nonatomic) IBOutlet GBHightLightButton *okButton;
@property (weak, nonatomic) IBOutlet GBCountDownButton *verifyCodeButton;

@end

@implementation GBModifyAccViewController

#pragma mark - Life Cycle

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
    
    [self checkInputValid];
}

#pragma mark - Delegate

// 字数限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.accountView.textField) {
        if(strlen([textField.text UTF8String]) >= 11 && range.length != 1)return NO;
    }else if (textField == self.passwordView.textField) {
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

// 点击获取验证码
- (IBAction)actionVerifyCodeBtn:(id)sender {
    
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
// 点击OK
- (IBAction)actionPressOKBtn:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString *account = self.accountView.textField.text;
    NSString *newPassword = self.passwordView.textField.text;
    NSString *verifyCode = self.pinView.textField.text;
    
    [self showLoadingToast];
    @weakify(self)
    [UserRequest modifyUserPhone:account password:newPassword verificationCode:verifyCode handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = LS(@"修改账号");
    [self setupBackButtonWithBlock:nil];
    self.accountView.textField.delegate = self;
    self.passwordView.textField.delegate = self;
    self.pinView.textField.delegate = self;
}

- (void)checkInputValid {
    
    BOOL isValidAccount = [self.accountView.textField.text isMobileNumber];
    BOOL isValidPassword = (self.passwordView.textField.text.length >=6 && self.passwordView.textField.text.length <= 17);
    BOOL isValidVerify = (self.pinView.textField.text.length >=4);
    
    self.accountView.correct = isValidAccount;
    self.passwordView.correct = isValidPassword;
    self.pinView.correct = isValidVerify;
    
    self.verifyCodeButton.enabled = isValidAccount && !self.verifyCodeButton.isCountdown;
    self.okButton.enabled = isValidAccount && isValidPassword && isValidVerify;
}

@end
