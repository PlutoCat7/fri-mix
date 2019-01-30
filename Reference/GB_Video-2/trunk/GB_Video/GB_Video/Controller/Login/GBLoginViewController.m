//
//  GBLoginViewController.m
//  GB_Video
//
//  Created by gxd on 2018/1/30.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBLoginViewController.h"
#import "GBRegistViewController.h"

#import "GBLoginTextField.h"

#import "UserRequest.h"

@interface GBLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet GBLoginTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet GBLoginTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;

@end

@implementation GBLoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLayoutSubviews {
    self.loginButton.layer.cornerRadius = self.loginButton.height/2;
    
    self.registButton.layer.cornerRadius = self.loginButton.height/2;
    self.registButton.layer.borderColor = [[UIColor colorWithHex:0xcdd4d4] CGColor];
    self.registButton.layer.borderWidth = 1.f;
}

#pragma mark - Action

- (IBAction)actionCancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)actionLogin:(id)sender {
    NSString *phoneNo = [self.phoneTextField.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.passwordTextField.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![phoneNo isMobileNumber]) {
        [self showToastWithText:@"请输入正确的手机号码"];
        return;
    }
    
    if ([NSString stringIsNullOrEmpty:password]) {
        [self showToastWithText:@"请填写密码"];
        return;
    }
    
    [self showLoadingToastWithText:LS(@"login.tip.waiting")];
    @weakify(self)
    [UserRequest userLogin:phoneNo password:password handler:^(id result, NSError *error) {
        
        @strongify(self)
        if (error != nil) {
            [self showToastWithText:error.domain];
            
        } else {
            [self dismissToast];
            
            [RawCacheManager sharedRawCacheManager].lastAccount = phoneNo;
            [RawCacheManager sharedRawCacheManager].lastPassword = password;
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Login object:nil];
        }
    }];
}

- (IBAction)actionRegist:(id)sender {
    [self.navigationController pushViewController:[GBRegistViewController new] animated:YES];
}

- (IBAction)actonForgetPassword:(id)sender {
}
- (IBAction)actionWeibo:(id)sender {
}
- (IBAction)actionWeixin:(id)sender {
}
- (IBAction)actionQQ:(id)sender {
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    UITextField *textField = [notification object];
    if (textField == self.phoneTextField.textField) {
        self.passwordTextField.textField.text = @"";
        [RawCacheManager sharedRawCacheManager].lastPassword = nil;
    }else if (textField == self.passwordTextField.textField) {
        [RawCacheManager sharedRawCacheManager].lastPassword = nil;
    }
}

// 字数限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneTextField.textField)
    {
        if(strlen([textField.text UTF8String]) >= 11 && range.length != 1)return NO;
    }
    else if (textField == self.passwordTextField.textField)
    {
        if(strlen([textField.text UTF8String]) >= 17 && range.length != 1)return NO;
    }
    return YES;
}

// Done键盘回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - private

-(void)setupUI {
    self.phoneTextField.textField.text = [RawCacheManager sharedRawCacheManager].lastAccount;
    self.passwordTextField.textField.text = [RawCacheManager sharedRawCacheManager].lastPassword;
    
    self.phoneTextField.textField.delegate  = self;
    self.passwordTextField.textField.delegate = self;
}

@end
