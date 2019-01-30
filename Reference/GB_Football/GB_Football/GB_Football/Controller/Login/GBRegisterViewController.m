//
//  GBRegisterViewController.m
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/7/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBRegisterViewController.h"
#import "GBLoginTextField.h"
#import "GBHightLightButton.h"
#import "GBPersonBasicViewController.h"
#import "GBCountDownButton.h"
#import "GBCircleHub.h"
#import "GBWebBrowserViewController.h"
#import "UserRequest.h"
#import "UIComboBox.h"

@interface GBRegisterViewController ()<UITextFieldDelegate,UIComboBoxDelegate>
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
// 服务条款图片
@property (weak, nonatomic) IBOutlet UIImageView *termStImageView;

@property (nonatomic, assign) AreaType areaType;

@end

@implementation GBRegisterViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
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
// 点击注册
- (IBAction)actionRegistOK:(id)sender{
    
    [self.view endEditing:YES];
    [GBCircleHub showWithTip:LS(@"login.tip.waiting") view:self.navigationController.topViewController.view];
    
    @weakify(self)
    [self performBlock:^{
        NSString *account = self.accountView.textField.text;
        NSString *password = self.passwordView.textField.text;
        NSString *verifyCode = self.pinView.textField.text;
        [UserRequest userRegister:account areaType:self.areaType password:password verificationCode:verifyCode handler:^(id result, NSError *error) {
            
            @strongify(self)
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                [RawCacheManager sharedRawCacheManager].lastAccount = account;
                [RawCacheManager sharedRawCacheManager].lastPassword = password;
                //跳转
                GBPersonBasicViewController *vc = [[GBPersonBasicViewController alloc]init];
                vc.isNeedNext = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
                //清空
                self.accountView.textField.text = @"";
                self.passwordView.textField.text = @"";
                self.confirmView.textField.text = @"";
                self.pinView.textField.text = @"";
                [self checkInputValid];
            }
            
            //
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [GBCircleHub hideAll];
            });
        }];
    } delay:1.5f];
}
- (IBAction)actionServiceTerms:(id)sender {
    
    NSDictionary *urlDic = @{@(LanguageItemType_Hans):@"https://t-goal.oss-cn-hangzhou.aliyuncs.com/web-page/xy.html",
                             @(LanguageItemType_English):@"http://t-goal.oss-cn-hangzhou.aliyuncs.com/web-page/xy_en.html",
                             @(LanguageItemType_Hant):@"http://t-goal.oss-cn-hangzhou.aliyuncs.com/web-page/xy_fan.html"};
    
    NSString *helpUrl = urlDic[@([[LanguageManager sharedLanguageManager] getCurrentAppLanguage].languageType)];
    [self.navigationController pushViewController:[[GBWebBrowserViewController alloc]initWithTitle:LS(@"term.nav.title") url:helpUrl] animated:YES];
}

#pragma mark - Private

- (void)loadData {
    
    self.areaType = AreaType_China;
}

-(void)setupUI
{
    self.accountView.textField.delegate = self;
    self.passwordView.textField.delegate = self;
    self.confirmView.textField.delegate = self;
    self.pinView.textField.delegate = self;
    [self.verifyCodeButton setButtonEnable:NO];
    [self setupContryUI];
}

-(void)localizeUI
{
    BOOL isEnglish = [[LanguageManager sharedLanguageManager] isEnglish];
    self.termStImageView.image = [UIImage imageNamed:isEnglish?@"terms_en":@"terms"];
    [self.verifyCodeButton setTitle:LS(@"signup.btn.getcode") forState:UIControlStateNormal];
}

- (void)checkInputValid {
    
    BOOL isValidAccount = [self.accountView.textField.text isPureInt] && self.accountView.textField.text.length>0;
    BOOL isValidPassword = (self.passwordView.textField.text.length >=6 && self.confirmView.textField.text.length <= 17);
    BOOL isValidPasswordAgain = [self.passwordView.textField.text isEqualToString:self.confirmView.textField.text] && isValidPassword;
    BOOL isValidVerify = (self.pinView.textField.text.length >=4);
    
    self.accountView.correct = isValidAccount;
    self.passwordView.correct = isValidPassword;
    self.confirmView.correct = isValidPasswordAgain;
    self.pinView.correct = isValidVerify;
    
    [self.verifyCodeButton setButtonEnable:isValidAccount];
    self.okButton.enabled = isValidAccount && isValidPassword && isValidVerify && isValidPasswordAgain;
}

#pragma mark 国家选择组合框

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
