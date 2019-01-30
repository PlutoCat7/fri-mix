//
//  RechargeViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/20.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "RechargeViewController.h"
#import "RechargePayViewController.h"

#import "BalanceRequest.h"

@interface RechargeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextView *tipsTextView;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;

@property (nonatomic, strong) RechargeOptionInfo *rechargeOptionInfo;

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.rechargeButton.layer.cornerRadius = 5.0f;
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
    
    if (notification.object == self.moneyTextField) {
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.roundingMode = NSNumberFormatterRoundFloor;
        formatter.maximumFractionDigits = 2;
        CGFloat price = [formatter numberFromString:self.moneyTextField.text].floatValue;
        self.rechargeButton.enabled = ((price>=self.rechargeOptionInfo.opt.min)&&(price<=self.rechargeOptionInfo.opt.max));
    }
}

#pragma mark - Action

- (IBAction)actionRecharge:(id)sender {
    
    CGFloat price = [self.moneyTextField.text floatValue];
    RechargePayViewController *vc = [[RechargePayViewController alloc] initWithPrice:price paymentOpt:self.rechargeOptionInfo.paymentOpt];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private

- (void)loadData {
    
    [self showLoadingToast];
    @weakify(self)
    [BalanceRequest getRechargeOptionWithHandler:^(id result, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if(error) {
            [self showToastWithText:error.domain];
        }else {
            self.rechargeOptionInfo = result;
            [self refreshUI];
        }
    }];
}

- (void)setupUI {
    
    self.title = @"余额充值";
    [self setupBackButtonWithBlock:nil];
    
    [self.rechargeButton setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
    [self.rechargeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x14b0ff]] forState:UIControlStateNormal];
}

- (void)refreshUI {
    
    self.titleLabel.text = self.rechargeOptionInfo.opt.label;
    self.moneyTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.rechargeOptionInfo.opt.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}];
    self.tipsTextView.text = self.rechargeOptionInfo.opt.info;
}

@end
