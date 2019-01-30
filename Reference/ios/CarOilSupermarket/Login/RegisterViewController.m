//
//  RegisterViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/1.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "RegisterViewController.h"
#import "SupplementViewController.h"
#import "GBWebBrowserViewController.h"

#import "GBCountDownButton.h"
#import "TracticsSelectView.h"
#import "UIButton+WebCache.h"

#import "CommonRequest.h"
#import "UserRequest.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *imageCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTextField;

@property (weak, nonatomic) IBOutlet UIView *fromMobileView;
@property (weak, nonatomic) IBOutlet UITextField *fromMobileTextField;
// 验证码倒计时按钮
@property (weak, nonatomic) IBOutlet GBCountDownButton *verifyCodeButton;
// 图形验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *imageCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *userTypeName;
@property (weak, nonatomic) IBOutlet UIImageView *turnImageView;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (strong, nonatomic) TracticsSelectView *tracticsSelectView;

//图形验证码信息
@property (nonatomic, strong) CaptchaInfo *captchaInfo;

@property (nonatomic, strong) NSArray<NSString *> *items;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self actionImageCode:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.tracticsSelectView dismiss];
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
    
    [CommonRequest getRegisterImageCodeWithHandler:^(id result, NSError *error) {
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
    [CommonRequest getRegisterSMSCodeWithMobile:phoneNo captcha:self.captchaInfo handler:^(id result, NSError *error) {
        
        if (error == nil) {
            [self.verifyCodeButton startCountDown:60];
        } else {
            [self.verifyCodeButton setButtonEnable:YES];
        }
        NSString *tips = error?error.domain:@"验证码获取成功，请注意查收。";
        [self showToastWithText:tips];
    }];
}

- (IBAction)actionUserStyle:(id)sender {
    
    @weakify(self)
    self.tracticsSelectView = [TracticsSelectView showWithTopY:self.inputView.bottom-1-self.fromMobileView.height entries:self.items selectIndex:self.currentIndex cancel:^{
        
        @strongify(self)
        [self rotateArrow:0];
    } complete:^(NSInteger index) {
        
        @strongify(self)
        self.currentIndex = index;
        self.userTypeName.text = [self.items objectAtIndex:index];
        [self rotateArrow:0];
    }];
    [self rotateArrow:M_PI];
}

//点击用户手册
- (IBAction)actionHandbook:(id)sender {
    
    GBWebBrowserViewController *vc = [[GBWebBrowserViewController alloc] initWithTitle:@"用户手册" url:[RawCacheManager sharedRawCacheManager].config.agreement];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)registerAction:(id)sender {
    
    NSString *phoneNo = [self.accountTextField.text removeSpace];
    NSString *smsCode = [self.smsCodeTextField.text removeSpace];
    NSString *typeId = [RawCacheManager sharedRawCacheManager].config.memberGroup[self.currentIndex].memberId;
    NSString *fromMobile = [self.fromMobileTextField.text removeSpace];
    [self showLoadingToastWithText:@"登录中..."];
    [UserRequest userRegister:phoneNo code:smsCode registerType:typeId fromMobile:fromMobile handler:^(id result, NSError *error) {
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Has_Login_In object:nil];
            if ([RawCacheManager sharedRawCacheManager].userInfo.needProfile) {
                //进入完善信息界面
                NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                [viewControllers removeLastObject];
                [viewControllers removeLastObject];
                SupplementViewController *vc = [SupplementViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [viewControllers addObject:vc];
                [self.navigationController setViewControllers:[viewControllers copy] animated:YES];
            }else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }];
}

#pragma mark - Delegate

// Done键盘回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Private

- (void)loadData {
    
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:1];
    for (COSConfigMemberInfo *memberInfo in [RawCacheManager sharedRawCacheManager].config.memberGroup) {
        [titles addObject:memberInfo.name];
    }
    self.items = [titles copy];
}

- (void)setupUI {
    
    self.title = @"注册";
    [self setupBackButtonWithBlock:nil];
    self.registerButton.layer.cornerRadius = 8;
    [self.registerButton setBackgroundImage:[UIImage imageWithColor:[ColorManager styleColor]] forState:UIControlStateNormal];
    [self.registerButton setBackgroundImage:[UIImage imageWithColor:[ColorManager buttonDisableColor]] forState:UIControlStateDisabled];
    
    [self checkButtonEnable];
}

- (void)rotateArrow:(float)degrees {
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.turnImageView.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
    } completion:NULL];
}

- (void)checkButtonEnable {
    
    NSString *phoneNo = [self.accountTextField.text removeSpace];
    NSString *smsCode = [self.smsCodeTextField.text removeSpace];
    BOOL enbale = [LogicManager isPhoneBumber:phoneNo] && [LogicManager isValidInputCode:smsCode];
    self.registerButton.enabled = enbale;
    
    [self.verifyCodeButton setButtonEnable:[LogicManager isPhoneBumber:phoneNo]];
}

@end
