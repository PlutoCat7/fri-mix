//
//  GBModifyPwdViewController.m
//  GB_Football
//
//  Created by weilai on 16/8/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBModifyPwdViewController.h"
#import "GBLoginTextField.h"
#import "GBMenuViewController.h"

#import "UserRequest.h"

@interface GBModifyPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet GBLoginTextField *oldPwdView;
@property (weak, nonatomic) IBOutlet GBLoginTextField *firstPwdView;
@property (weak, nonatomic) IBOutlet GBLoginTextField *againPwdView;

@property (weak, nonatomic) IBOutlet UIButton *okButton;
@end

@implementation GBModifyPwdViewController


#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(strlen([textField.text UTF8String]) >= 17 && range.length != 1)return NO;
    return YES;
}

// Done键盘回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Action

// 点击OK
- (IBAction)actionPressOK:(id)sender{
    
    [self.view endEditing:YES];
    
    NSString *oldPasswor = self.oldPwdView.textField.text;
    NSString *newPassword = self.firstPwdView.textField.text;
    
    [self showLoadingToast];
    @weakify(self)
    [UserRequest updateLoginPassword:oldPasswor newPassword:newPassword handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            //更新密码
            [RawCacheManager sharedRawCacheManager].lastPassword = newPassword;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

#pragma mark - Private

-(void)setupUI
{
    self.title = LS(@"setting.label.passord");
    [self setupBackButtonWithBlock:nil];
    self.oldPwdView.textField.delegate = self;
    self.firstPwdView.textField.delegate = self;
    self.againPwdView.textField.delegate = self;
}

- (void)checkInputValid {
    
    BOOL isValidOld = (self.oldPwdView.textField.text.length >=6 && self.oldPwdView.textField.text.length <= 17);
    BOOL isValidNew = (self.firstPwdView.textField.text.length >=6 && self.firstPwdView.textField.text.length <= 17);
    BOOL isValidAgain = [self.againPwdView.textField.text isEqualToString:self.firstPwdView.textField.text] && isValidNew;
    
    self.oldPwdView.correct = isValidOld;
    self.firstPwdView.correct = isValidNew;
    self.againPwdView.correct = isValidAgain;
    
    self.okButton.enabled = isValidOld && isValidNew && isValidAgain;
}


@end
