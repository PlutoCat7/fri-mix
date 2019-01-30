//
//  GBLoginViewController.m
//  GB_Team
//
//  Created by weilai on 16/9/9.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBLoginViewController.h"
#import "GBLoginTextField.h"
#import "GBRegisterViewController.h"
#import "GBForgetPwdViewController.h"
#import "UserRequest.h"

@interface GBLoginViewController () <
UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet GBLoginTextField *accountField;
@property (weak, nonatomic) IBOutlet GBLoginTextField *passwordField;
@property (weak, nonatomic) IBOutlet GBHightLightButton *okButton;

@end

@implementation GBLoginViewController

#pragma mark -
#pragma mark Memory

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    self.accountField.textField.text = [RawCacheManager sharedRawCacheManager].lastAccount;
    self.passwordField.textField.text = [RawCacheManager sharedRawCacheManager].lastPassword;
    [self checkInputValid];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - Action
- (IBAction)actionLogin:(id)sender {
    
    [GBCircleHub showWithTip:LS(@"正在登录 请稍候") view:self.navigationController.topViewController.view];
    
    @weakify(self)
    [self performBlock:^{
        NSString *account = self.accountField.textField.text;
        NSString *password = self.passwordField.textField.text;
        [UserRequest userLogin:account password:password handler:^(id result, NSError *error) {
            
            @strongify(self)
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                [self showToastWithText:LS(@"登录成功")];
                
                [RawCacheManager sharedRawCacheManager].isLastLogined = YES;
                [RawCacheManager sharedRawCacheManager].lastAccount = account;
                [RawCacheManager sharedRawCacheManager].lastPassword = password;
                //跳转
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ShowMainView object:nil];
            }
            //
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [GBCircleHub hide];
            });
        }];
    } delay:1.5f];
}

- (IBAction)actionRegister:(id)sender {
    
    [self.navigationController pushViewController:[[GBRegisterViewController alloc]init] animated:YES];
}

- (IBAction)actionForget:(id)sender {
    
    [self.navigationController pushViewController:[[GBForgetPwdViewController alloc]init] animated:YES];
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    UITextField *textField = [notification object];
    if (textField == self.accountField.textField) {
        self.passwordField.textField.text = @"";
        [RawCacheManager sharedRawCacheManager].lastPassword = nil;
    }else if (textField == self.passwordField.textField) {
        [RawCacheManager sharedRawCacheManager].lastPassword = nil;
    }
    [self checkInputValid];
}

#pragma mark - Private

- (void)setupUI {
    
    self.accountField.textField.delegate  = self;
    self.passwordField.textField.delegate = self;
}

- (void)checkInputValid {
    
    NSString *text = self.accountField.textField.text;
    BOOL isValidAccount = [text isMobileNumber];
    BOOL isValidPassword = (self.passwordField.textField.text.length >=6 && self.passwordField.textField.text.length <= 17);
    self.accountField.correct = isValidAccount;
    self.passwordField.correct = isValidPassword;
    self.okButton.enabled = isValidAccount && isValidPassword;
}

@end
