//
//  GBScanViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/17.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBScanViewController.h"
#import "GBMenuViewController.h"
#import "GBFindWristViewController.h"
#import "GBMallViewController.h"
#import "GBLoginTextField.h"
#import "GBHightLightButton.h"
#import "GBScanQRView.h"
#import "GBCircleHub.h"
#import "SystemRequest.h"
#import "GBBluetoothManager.h"
#import "RawCacheManager.h"
#import "RTLabel.h"

@interface GBScanViewController ()
// 产品序列号输入框
@property (weak, nonatomic) IBOutlet GBLoginTextField *serialNoTextField;
// 扫描中显示标签
@property (weak, nonatomic) IBOutlet RTLabel *scanningLabel;
// 扫描ok显示标签
@property (weak, nonatomic) IBOutlet UILabel *scanOkLabel;
// 显示结果层
@property (weak, nonatomic) IBOutlet UIView *detailView;
// 相机层
@property (weak, nonatomic) IBOutlet GBScanQRView *cameraView;
// 显示结果
@property (weak, nonatomic) IBOutlet UILabel *resultNumberLabel;
// 确认按钮
@property (weak, nonatomic) IBOutlet GBHightLightButton *okButton;
// 商城购买
@property (weak, nonatomic) IBOutlet UILabel *shopLabel;

// 静态国际化标签
@property (weak, nonatomic) IBOutlet UILabel *succeedStLabel;
@property (weak, nonatomic) IBOutlet UILabel *keepStLabel;
@property (weak, nonatomic) IBOutlet RTLabel *instrStLabel;
@property (weak, nonatomic) IBOutlet UILabel *tapOkStLabel;

@end

@implementation GBScanViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{

    [_cameraView stopCameraScan];
}

-(void)localizeUI
{
    self.succeedStLabel.text = LS(@"scan.label.succeed");
    self.keepStLabel.text = LS(@"scan.label.keep");
    self.instrStLabel.text = LS(@"scan.label.instruction");
    self.instrStLabel.textAlignment = RTTextAlignmentCenter;
    self.tapOkStLabel.text = LS(@"scan.label.finish");
    self.shopLabel.text = LS(@"pair.lable.buy");
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self.cameraView startCameraScan];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    if (notification.object != self.serialNoTextField.textField) {
        return;
    }
    [self checkInputValid];
}

#pragma mark - Delegate

#pragma mark - Action

- (IBAction)actionPressOK:(id)sender {
    
    [UMShareManager event:Analy_Click_Bind_Code];
    
    GBCircleHub *hud = [GBCircleHub showWithTip:LS(@"device.tip.connecting") view:nil];
    @weakify(self)
    NSString *number = [self.serialNoTextField.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [SystemRequest bindWristband:number handler:^(id result, NSError *error) {
        @strongify(self)
        if (error) {
            [hud hide];
            [self showToastWithText:error.domain];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_BindSuccess object:nil];
            [GBBluetoothManager sharedGBBluetoothManager].iBeaconMac = result;
            [[GBBluetoothManager sharedGBBluetoothManager] connectBeacon:^(NSError *error) {

                if (error) {
                    [hud hide];
                    [[UIApplication sharedApplication].keyWindow showToastWithText:error.domain];
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    [hud changeText:LS(@"device.tip.waiting")];
                    [self performBlock:^{
                        [self.navigationController popViewControllerAnimated:YES];
                        [self performBlock:^{
                            [hud hide];
                        } delay:1.0f];
                    } delay:1.5f];
                }
            }];
        }
    }];
}

- (IBAction)actionShopping:(id)sender {
    GBMallViewController *vc = [[GBMallViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private

-(void)setupUI
{
    self.title = LS(@"scan.nav.title");
    [self setupBackButtonWithBlock:nil];
    @weakify(self)
    self.cameraView.selectedHandler = ^(NSString *item){
        @strongify(self)
        self.detailView.hidden = NO;
        self.resultNumberLabel.text = item;
        self.cameraView.hidden = YES;
        self.scanningLabel.hidden = YES;
        self.scanOkLabel.hidden = NO;
        self.serialNoTextField.textField.text = item;
        [self checkInputValid];
    };
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 50, 40);
    [menuBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [menuBtn setTitle:LS(@"pair.button.find") forState:UIControlStateNormal];
    menuBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    
    [menuBtn addActionHandler:^(NSInteger tag) {
        @strongify(self)
        [UMShareManager event:Analy_Click_Bind_Scan];
        
        [self.navigationController pushViewController:[GBFindWristViewController new] animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
}

- (void)checkInputValid {
    
    NSString *number = [self.serialNoTextField.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.serialNoTextField.correct = number.length==14;
    self.okButton.enabled = self.serialNoTextField.correct;
}

@end
