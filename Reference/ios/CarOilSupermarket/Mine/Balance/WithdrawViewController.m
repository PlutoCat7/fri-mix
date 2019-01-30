//
//  WithdrawViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/21.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "WithdrawViewController.h"

#import "WithdrawViewModel.h"

@interface WithdrawViewController ()
@property (weak, nonatomic) IBOutlet UITextField *bankTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *pointsTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UITextView *tipsTextView;

@property (nonatomic, strong) WithdrawViewModel *viewModel;

@end

@implementation WithdrawViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewModel = [[WithdrawViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    UITextField *textField = notification.object;
    if (textField == self.moneyTextField) {
        static NSInteger const maxIntegerLength=8;//最大整数位
        static NSInteger const maxFloatLength=2;//最大精确到小数位
        NSString *x = self.moneyTextField.text;
        if (x.length) {
            //第一个字符处理
            //第一个字符为0,且长度>1时
            if ([[x substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
                if (x.length>1) {
                    if ([[x substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]) {
                        //如果第二个字符还是0,即"00",则无效,改为"0"
                        textField.text=@"0";
                    }else if (![[x substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"."]){
                        //如果第二个字符不是".",比如"03",清除首位的"0"
                        textField.text=[x substringFromIndex:1];
                    }
                }
            }
            //第一个字符为"."时,改为"0."
            else if ([[x substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"."]){
                textField.text=@"0.";
            }
            
            //2个以上字符的处理
            NSRange pointRange = [x rangeOfString:@"."];
            NSRange pointsRange = [x rangeOfString:@".."];
            if (pointsRange.length>0) {
                //含有2个小数点
                textField.text=[x substringToIndex:x.length-1];
            }
            else if (pointRange.length>0){
                //含有1个小数点时,并且已经输入了数字,则不能再次输入小数点
                if ((pointRange.location!=x.length-1) && ([[x substringFromIndex:x.length-1]isEqualToString:@"."])) {
                    textField.text=[x substringToIndex:x.length-1];
                }
                if (pointRange.location+maxFloatLength<x.length) {
                    //输入位数超出精确度限制,进行截取
                    textField.text=[x substringToIndex:pointRange.location+maxFloatLength+1];
                }
            }
            else{
                if (x.length>maxIntegerLength) {
                    textField.text=[x substringToIndex:maxIntegerLength];
                }
            }
            
        }
    }
    
    NSString *bank = self.bankTextField.text;
    NSString *account = self.accountTextField.text;
    NSString *userName = self.userNameTextField.text;
    NSString *mobile = self.mobileTextField.text;
    NSString *points = self.pointsTextField.text;
    
    self.doneButton.enabled = [_viewModel checkInputVaild:[self.moneyTextField.text floatValue] bank:bank account:account name:userName mobile:mobile points:points];
}

#pragma mark - Action

- (IBAction)actionDone:(id)sender {
    
    NSString *bank = self.bankTextField.text;
    NSString *account = self.accountTextField.text;
    NSString *userName = self.userNameTextField.text;
    NSString *mobile = self.mobileTextField.text;
    NSString *points = self.pointsTextField.text;

    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:self.moneyTextField.text];
    NSString *priceString = multiplierNumber.stringValue;
    
    [self showLoadingToast];
    @weakify(self)
    [_viewModel withdrawWithMoney:priceString bank:bank account:account name:userName mobile:mobile points:points hanlder:^(NSString *errorMsg, BOOL isSuccess, NSString *successTips) {
        
        @strongify(self)
        [self dismissToast];
        if (isSuccess) {
            [RawCacheManager sharedRawCacheManager].userInfo.balance -= self.moneyTextField.text.doubleValue;
            [[UIApplication sharedApplication].keyWindow showToastWithText:successTips];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self showToastWithText:errorMsg];
        }
    }];
}

#pragma mark - Private

- (void)loadData {
    
    [self showLoadingToast];
    @weakify(self)
    [_viewModel getWithdrawInfoWithHanlder:^(NSString *errorMsg) {
        
        @strongify(self)
        [self dismissToast];
        if (errorMsg) {
            [[UIApplication sharedApplication].keyWindow showToastWithText:errorMsg];
            [self.navigationController yh_popViewController:self animated:YES];
        }else {
            [self refreshUI];
        }
    }];
}

- (void)setupUI {
    
    self.title = @"提现申请";
    [self setupBackButtonWithBlock:nil];
    
    self.doneButton.layer.cornerRadius = 5;
    [self.doneButton setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
    [self.doneButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x14b0ff]] forState:UIControlStateNormal];
}

- (void)refreshUI {
    
    self.moneyTextField.placeholder = [_viewModel moneyTextFieldPlaceholder];
    self.tipsTextView.text = [_viewModel tips];
}

@end
