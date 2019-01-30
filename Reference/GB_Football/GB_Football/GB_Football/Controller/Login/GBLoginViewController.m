//
//  GBLoginViewController.m
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/7/11.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBLoginViewController.h"
#import "GBLoginTextField.h"
#import "GBMenuViewController.h"
#import "GBPersonBasicViewController.h"
#import "GBCircleHub.h"
#import "GBHightLightButton.h"
#import "UserRequest.h"
#import "GBFogetPassWordViewController.h"

@interface GBLoginViewController ()<UITextFieldDelegate>
// 账户输入框
@property (weak, nonatomic) IBOutlet GBLoginTextField *accountView;
// 密码输入框
@property (weak, nonatomic) IBOutlet GBLoginTextField *passwordView;
// ok按钮
@property (weak, nonatomic) IBOutlet GBHightLightButton *okButton;
// 忘记密码
@property (weak, nonatomic) IBOutlet UILabel *labelForgot;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@end

@implementation GBLoginViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.accountView.textField.text = [RawCacheManager sharedRawCacheManager].lastAccount;
    self.passwordView.textField.text = [RawCacheManager sharedRawCacheManager].lastPassword;
    [self checkInputValid];
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
    
    UITextField *textField = [notification object];
    if (textField == self.accountView.textField) {
        self.passwordView.textField.text = @"";
        [RawCacheManager sharedRawCacheManager].lastPassword = nil;
    }else if (textField == self.passwordView.textField) {
        [RawCacheManager sharedRawCacheManager].lastPassword = nil;
    }
    [self checkInputValid];
}

#pragma mark - Delegate

// 字数限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.accountView.textField)
    {
        if(strlen([textField.text UTF8String]) >= 11 && range.length != 1)return NO;
    }
    else if (textField == self.passwordView.textField)
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

#pragma mark - Action

// 登陆按钮
- (IBAction)actionOKButton:(id)sender {
    
    [self.view endEditing:YES];
    GBCircleHub *hud = [GBCircleHub showWithTip:LS(@"login.tip.waiting") view:self.navigationController.topViewController.view];
    
    @weakify(self)
    [self performBlock:^{
        NSString *account = self.accountView.textField.text;
        NSString *password = self.passwordView.textField.text;
        [UserRequest userLogin:account password:password handler:^(id result, NSError *error) {
            
            @strongify(self)
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                [RawCacheManager sharedRawCacheManager].lastAccount = account;
                [RawCacheManager sharedRawCacheManager].lastPassword = password;
                //跳转
                if ([LogicManager checkExistUserInfo]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ShowMainView object:nil];
                }else {
                    GBPersonBasicViewController *vc = [[GBPersonBasicViewController alloc]init];
                    vc.isNeedNext = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            //
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hide];
            });
        }];
    } delay:1.5f];
    
}


// 忘记密码按钮
- (IBAction)actionFogetButton:(id)sender {
    
    [self.navigationController pushViewController:[[GBFogetPassWordViewController alloc]init] animated:YES];
}

#pragma mark - Private

-(void)setupUI
{
    self.accountView.textField.delegate  = self;
    self.passwordView.textField.delegate = self;
}

-(void)localizeUI
{
    self.labelForgot.text = LS(@"login.btn.forgot");
    self.versionLabel.text = [NSString stringWithFormat:@"%@ : %@", LS(@"login.lbl.version"), [Utility appVersion]];
}

- (void)checkInputValid {
    
    NSString *text = self.accountView.textField.text;
    BOOL isValidAccount = [text isPureInt] && text.length>0;
    BOOL isValidPassword = (self.passwordView.textField.text.length >=6 && self.passwordView.textField.text.length <= 17);
    self.accountView.correct = isValidAccount;
    self.passwordView.correct = isValidPassword;
    self.okButton.enabled = isValidAccount && isValidPassword;
}

#pragma mark - Getters & Setters


@end
