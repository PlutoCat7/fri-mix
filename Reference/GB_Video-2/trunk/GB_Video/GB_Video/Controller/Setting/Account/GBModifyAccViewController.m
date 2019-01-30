//
//  GBModifyAccViewController.m
//  GB_Video
//
//  Created by gxd on 2018/2/1.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBModifyAccViewController.h"

#import "GBLoginTextField.h"
#import "GBCountDownButton.h"
#import "UserRequest.h"

@interface GBModifyAccViewController ()

@property (weak, nonatomic) IBOutlet GBLoginTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet GBLoginTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet GBLoginTextField *verifyTextField;
@property (weak, nonatomic) IBOutlet GBCountDownButton *verifyButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@end

@implementation GBModifyAccViewController

#pragma mark - Action

- (IBAction)actionVerify:(id)sender {
    NSString *phoneNo = [self.phoneTextField.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![phoneNo isMobileNumber]) {
        [self showToastWithText:@"请输入正确的手机号码"];
        return;
    }
    
    [self showLoadingToastWithText:LS(@"forgot.tip.waiting")];
    @weakify(self)
    [UserRequest getVerificationCodeWithPhone:phoneNo handler:^(id result, NSError *error) {
        
        @strongify(self)
        if (error == nil) {
            [self.verifyButton startCountDown:60];
        }
        
        NSString *tips = error?error.domain:LS(@"login.tip.vercode.check");
        [self showToastWithText:tips];
    }];
}

- (IBAction)actionOk:(id)sender {
    NSString *phoneNo = [self.phoneTextField.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.passwordTextField.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *verifyCode = [self.verifyTextField.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![phoneNo isMobileNumber]) {
        [self showToastWithText:@"请输入正确的手机号码"];
        return;
    }
    
    if ([NSString stringIsNullOrEmpty:password] || [NSString stringIsNullOrEmpty:verifyCode]) {
        [self showToastWithText:@"请填写所有项信息"];
        return;
    }
    
    [self showLoadingToastWithText:LS(@"login.tip.waiting")];
    @weakify(self)
    [UserRequest modifyUserPhone:phoneNo password:password verificationCode:verifyCode handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (error != nil) {
            [self showToastWithText:error.domain];
            
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_User_BaseInfo object:nil];
        }
        
        
    }];
}

#pragma mark - Private

-(void)setupUI {
    self.title = LS(@"setting.label.account");
    [self setupBackButtonWithBlock:nil];
}

@end
