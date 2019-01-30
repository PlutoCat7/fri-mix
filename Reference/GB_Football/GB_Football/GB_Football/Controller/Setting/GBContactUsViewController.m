//
//  GBContactUsViewController.m
//  GB_Football
//
//  Created by weilai on 16/8/29.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBContactUsViewController.h"
#import "GBMenuViewController.h"
#import "GBScanFWViewController.h"

#define ClickCount      5
#define ClickInterval   1

@interface GBContactUsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *telButton;
@property (weak, nonatomic) IBOutlet UIButton *telMOButton;
@property (weak, nonatomic) IBOutlet UIButton *telMTButton;

@property (weak, nonatomic) IBOutlet UILabel *wechatStLbl;
@property (weak, nonatomic) IBOutlet UILabel *wechatOneStLbl;
@property (weak, nonatomic) IBOutlet UILabel *wechatTwoStLbl;
@property (weak, nonatomic) IBOutlet UILabel *qqStLbl;
@property (weak, nonatomic) IBOutlet UILabel *qqSeviceStLbl;
@property (weak, nonatomic) IBOutlet UILabel *telStLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeStLbl;
@property (weak, nonatomic) IBOutlet UILabel *scanDevStLbl;
@property (weak, nonatomic) IBOutlet UILabel *scanStLbl;
@property (weak, nonatomic) IBOutlet UILabel *callOneStLbl;
@property (weak, nonatomic) IBOutlet UILabel *callTwoStLbl;
@property (weak, nonatomic) IBOutlet UILabel *callThrStLbl;

@property (weak, nonatomic) IBOutlet UIView *scanView;

//兼容在同步数据时，双击检验设备多次返回问题
@property (nonatomic, weak) GBAlertView *alertView;

@property (nonatomic, assign) NSInteger clickCount;
@property (nonatomic, strong) NSDate   *lastClickDate;

@end

@implementation GBContactUsViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)localizeUI {
    self.wechatStLbl.text = LS(@"contact.label.wechat");
    self.wechatOneStLbl.text = LS(@"contact.label.id1");
    self.wechatTwoStLbl.text = LS(@"contact.label.id2");
    self.qqStLbl.text = LS(@"QQ");
    self.qqSeviceStLbl.text = LS(@"contact.label.group");
    self.telStLbl.text = LS(@"contact.label.server.tel");
    self.timeStLbl.text = LS(@"contact.label.time");
    self.scanDevStLbl.text = LS(@"setting.btn.scan");
    self.scanStLbl.text = LS(@"setting.label.scan");
    self.callOneStLbl.text = LS(@"setting.label.call");
    self.callTwoStLbl.text = LS(@"setting.label.call");
    self.callThrStLbl.text = LS(@"setting.label.call");
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // 设备反馈
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceCheck:) name:Notification_DeviceCheck object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}

#pragma mark - NSNotification
// 设备检查
- (void)deviceCheck:(NSNotification*)notification
{
    if (![RawCacheManager sharedRawCacheManager].isBindWristband) { //未绑定手环
        return;
    }
    if (self.alertView) {
        return;
    }
    self.alertView =  [GBAlertView alertWithCallBackBlock:nil title:LS(@"common.popbox.title.tip") message:LS(@"setting.hint.check.firmware") cancelButtonName:LS(@"common.btn.yes") otherButtonTitle:nil style:GBALERT_STYLE_NOMAL];
}

#pragma mark - Delegate

#pragma mark - Action

- (IBAction)actionTel:(id)sender {
    NSURL *phone_url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", ServiceCall_Phone]];
    [[UIApplication sharedApplication] openURL:phone_url];
}

- (IBAction)actionTelMO:(id)sender {
    NSURL *phone_url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", ServiceCall_MOBILEONE]];
    [[UIApplication sharedApplication] openURL:phone_url];
}

- (IBAction)actionTelMT:(id)sender {
    NSURL *phone_url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", ServiceCall_MOBILETWO]];
    [[UIApplication sharedApplication] openURL:phone_url];
}

- (IBAction)actionScan:(id)sender {
    [self.navigationController pushViewController:[GBScanFWViewController new] animated:YES];
}

- (IBAction)actionQQ:(id)sender {
    if (![self.scanView isHidden]) {
        return;
    }
    
    if (self.lastClickDate == nil) {
        self.clickCount = 1;
        self.lastClickDate = [NSDate date];
        
    } else {
        NSDate *currentDate = [NSDate date];
        NSTimeInterval interval = [currentDate timeIntervalSinceNow] - [self.lastClickDate timeIntervalSinceNow];
        if (interval > 0 && interval < ClickInterval) {
            self.clickCount += 1;
        } else {
            self.clickCount = 1;
        }
        self.lastClickDate = currentDate;
    }
    
    if (self.clickCount >= 5) {
        self.scanView.hidden = NO;
    }
}
#pragma mark - Private

-(void)setupUI {
    self.title = LS(@"contact.nav.title");
    [self setupBackButtonWithBlock:nil];
    
    [self.telButton.layer setMasksToBounds:YES];
    [self.telButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    
    [self.telMOButton.layer setMasksToBounds:YES];
    [self.telMOButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    
    [self.telMTButton.layer setMasksToBounds:YES];
    [self.telMTButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
}

@end
