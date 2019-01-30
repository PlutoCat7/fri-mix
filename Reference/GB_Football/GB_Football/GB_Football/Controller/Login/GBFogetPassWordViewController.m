//
//  GBFogetPassWordViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBFogetPassWordViewController.h"
#import "GBWelComeViewController.h"
#import "GBLoginTextField.h"
#import "GBCountDownButton.h"
#import "GBHightLightButton.h"
#import "UserRequest.h"
#import "UIComboBox.h"

@interface GBFogetPassWordViewController ()<UITextFieldDelegate,UIComboBoxDelegate>
// 国家选择条
@property (weak, nonatomic) IBOutlet UIView *contryBar;
// 国家组合框
@property (weak, nonatomic) IBOutlet UIComboBox *contryComboBox;
// 账户
@property (weak, nonatomic) IBOutlet GBLoginTextField *accountView;
// 密码
@property (weak, nonatomic) IBOutlet GBLoginTextField *passwordView;
// 确认密码
@property (weak, nonatomic) IBOutlet GBLoginTextField *confirmView;
// 验证码
@property (weak, nonatomic) IBOutlet GBLoginTextField *pinView;
// 注册确认按钮
@property (weak, nonatomic) IBOutlet GBHightLightButton *okButton;
// 验证码倒计时按钮
@property (weak, nonatomic) IBOutlet GBCountDownButton *verifyCodeButton;

@property (nonatomic, assign) AreaType areaType;

@end

@implementation GBFogetPassWordViewController


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
    if ([self.navigationController.topViewController isMemberOfClass:[GBWelComeViewController class]]) {
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
    if (textField == self.accountView.textField)
    {
        if(strlen([textField.text UTF8String]) >= 11 && range.length != 1)return NO;
    }
    else if (textField == self.passwordView.textField)
    {
        if(strlen([textField.text UTF8String]) >= 17 && range.length != 1)return NO;
    }
    else if (textField == self.confirmView.textField)
    {
        if(strlen([textField.text UTF8String]) >= 17 && range.length != 1)return NO;
    }
    else if (textField == self.pinView.textField)
    {
        if(strlen([textField.text UTF8String]) >= 6 && range.length != 1)return NO;
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

// 点击获取验证码
- (IBAction)actionVerifyCode:(id)sender {
    
    NSString *phoneNo = self.accountView.textField.text;
    
    [self.verifyCodeButton setButtonEnable:NO];
    [self showLoadingToastWithText:LS(@"modify.tip.waiting")];
    
    @weakify(self)
    [UserRequest pushVerificationCode:phoneNo areaType:self.areaType handler:^(id result, NSError *error) {
        
        @strongify(self)
        if (error == nil) {
            [self.verifyCodeButton startCountDown:60];
        } else {
            [self.verifyCodeButton setButtonEnable:YES];
        }
        
        NSString *tips = error?error.domain:LS(@"login.tip.vercode.check");
        [self showToastWithText:tips];
    }];
}
// 点击OK
- (IBAction)actionPressOK:(id)sender{
    
    [self.view endEditing:YES];

    [self showLoadingToast];
    @weakify(self)
   
        NSString *account = self.accountView.textField.text;
        NSString *newPassword = self.passwordView.textField.text;
        NSString *verifyCode = self.pinView.textField.text;
        [UserRequest resetLoginPassword:account newPassword:newPassword verificationCode:verifyCode handler:^(id result, NSError *error) {
            
            @strongify(self)
            [self dismissToast];
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                [RawCacheManager sharedRawCacheManager].lastAccount = account;
                [RawCacheManager sharedRawCacheManager].lastPassword = nil;
                
                [self showToastWithText:LS(@"modify.tip.suceess")];
                [self performBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                } delay:1.5f];
            }
        }];
}

#pragma mark - Private

- (void)loadData {
    
    self.areaType = AreaType_China;
}

-(void)setupUI
{
    self.title = LS(@"forgot.nav.title");
    [self setupBackButtonWithBlock:nil];
    self.accountView.textField.delegate = self;
    self.passwordView.textField.delegate = self;
    self.confirmView.textField.delegate = self;
    self.pinView.textField.delegate = self;
    [self.verifyCodeButton setButtonEnable:NO];
    [self setupContryUI];
}

-(void)localizeUI
{
    [self.verifyCodeButton setTitle:LS(@"signup.btn.getcode") forState:UIControlStateNormal];
}

- (void)checkInputValid {
    
    BOOL isValidAccount = [self.accountView.textField.text isPureInt] && self.accountView.textField.text.length>0;
    BOOL isValidPassword = (self.passwordView.textField.text.length >=6 && self.passwordView.textField.text.length <= 17);
    BOOL isValidPasswordAgain = [self.passwordView.textField.text isEqualToString:self.confirmView.textField.text] && isValidPassword;
    BOOL isValidVerify = (self.pinView.textField.text.length >=4);
    
    self.accountView.correct = isValidAccount;
    self.passwordView.correct = isValidPassword;
    self.confirmView.correct = isValidPasswordAgain;
    self.pinView.correct = isValidVerify;
    
    [self.verifyCodeButton setButtonEnable:isValidAccount];
    self.okButton.enabled = isValidAccount && isValidPassword && isValidVerify && isValidPasswordAgain;
}


// 国家选择器设置
-(void)setupContryUI
{
    self.contryComboBox.delegate = self;
    [self.contryComboBox setComboBoxPlaceholder:LS(@"countroy.name.china") color:[UIColor whiteColor]];
    self.contryComboBox.entries = @[LS(@"countroy.name.china"),LS(@"countroy.name.hongkong"),LS(@"countroy.name.macao")];
    self.contryComboBox.font = FONT_ADAPT(15.f);
}

// 返回选择项
- (void) comboBox:(UIComboBox *)comboBox selected:(int)selected
{
    if (selected == 0) {
        self.areaType = AreaType_China;
    }else if (selected == 1) {
        self.areaType = AreaType_HongKong;
    }else if (selected == 2) {
        self.areaType = AreaType_Macao;
    }
    [self checkInputValid];
}

// 折叠和收起
-(void)comboBox:(UIComboBox *)comboBox expand:(BOOL)expand
{
    self.contryBar.backgroundColor = expand ? [UIColor colorWithHex:0x252525]: [UIColor colorWithHex:0x2E2E2E];
}
@end
