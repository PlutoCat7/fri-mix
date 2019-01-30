//
//  MineViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/7/31.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "MineViewController.h"
#import "MineDetailViewController.h"
#import "ShippingAddressViewController.h"
#import "MyOrderViewController.h"
#import "SupplementViewController.h"
#import "ShoppingCartViewController.h"
#import "MyVouchersViewController.h"
#import "PointsViewController.h"
#import "AttendanceViewController.h"
#import "BalanceViewController.h"

#import "UIImageView+WebCache.h"
#import "UserGradeStarView.h"

#import "UserRequest.h"

@interface MineViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userAvatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nextPageImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, nonatomic) IBOutlet UILabel *userTypeName;
@property (weak, nonatomic) IBOutlet UserGradeStarView *userGradeStarView;
@property (weak, nonatomic) IBOutlet UIImageView *userTypeNextPageImageView;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UIView *signOutButton;
@property (weak, nonatomic) IBOutlet UIView *vouchersCountView;
@property (weak, nonatomic) IBOutlet UILabel *vouchersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointCountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signOutButtonTopLayoutConstraint;

@end

@implementation MineViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avatorChangeNotification:) name:Notification_User_Avator object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nickChangeNotification) name:Notification_Nick_Change_Success object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSupplementNotification) name:Notification_User_Supplement object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotification) name:Notification_Has_Login_In object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if ([LogicManager isUserLogined]) {
        [UserRequest refreshUserInfoWithHandler:^(id result, NSError *error) {
           
            if (result) {
                [self refreshUI];
            }
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    //解决右滑不能滑出侧边菜单的问题
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.vouchersCountView.layer.cornerRadius = self.vouchersCountView.width/2;
    });
}

- (void)updateViewConstraints {
    
    [super updateViewConstraints];
    self.headerViewHeightLayoutConstraint.constant = 170*kAppScale;
    self.centerViewHeightLayoutConstraint.constant = 250*kAppScale;
    self.signOutButtonTopLayoutConstraint.constant = 30*kAppScale;
}

#pragma mark - Notification

- (void)avatorChangeNotification:(NSNotification *)notification {
    
    UIImage *image = notification.object;
    self.userAvatorImageView.image = image;
}

- (void)nickChangeNotification {
    
    self.userNameLabel.text = [RawCacheManager sharedRawCacheManager].userInfo.nick;
}

- (void)userSupplementNotification {
    
    self.userTypeNextPageImageView.hidden = YES;
}

- (void)loginNotification {
    
    [self refreshUI];
}

#pragma mark - Action

- (IBAction)actionUser:(id)sender {
    
    if (![RawCacheManager sharedRawCacheManager].userInfo) {
        [LogicManager pushLoginViewControllerWithNav:self.navigationController];
        return;
    }
    MineDetailViewController *vc = [[MineDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//余额
- (IBAction)actionBalance:(id)sender {
    
    if (![LogicManager isUserLogined]) {
        [self showToastWithText:@"请先登录"];
        return;
    }
    BalanceViewController *vc = [[BalanceViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//积分
- (IBAction)actionIntegral:(id)sender {
    
    if (![LogicManager isUserLogined]) {
        [self showToastWithText:@"请先登录"];
        return;
    }
    PointsViewController *vc = [[PointsViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//代金卷
- (IBAction)actionVouchers:(id)sender {
    
    if (![LogicManager isUserLogined]) {
        [self showToastWithText:@"请先登录"];
        return;
    }
    MyVouchersViewController *vc = [[MyVouchersViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//会员等级
- (IBAction)actionUserType:(id)sender {
    
    UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
    if (userInfo.needProfile) {
        //进入完善信息界面
        SupplementViewController *vc = [SupplementViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//我的订单
- (IBAction)actionOrder:(id)sender {
    
    if (![LogicManager isUserLogined]) {
        [self showToastWithText:@"请先登录"];
        return;
    }
    MyOrderViewController *vc = [[MyOrderViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//收货地址
- (IBAction)actionAddress:(id)sender {
    
    if (![LogicManager isUserLogined]) {
        [self showToastWithText:@"请先登录"];
        return;
    }
    ShippingAddressViewController *vc = [[ShippingAddressViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//签到
- (IBAction)actionSignIn:(id)sender {
    
    if (![LogicManager isUserLogined]) {
        [self showToastWithText:@"请先登录"];
        return;
    }
    AttendanceViewController *vc = [[AttendanceViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//客服
- (IBAction)actionService:(id)sender {
    
    NSURL *phone_url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [RawCacheManager sharedRawCacheManager].config.serviceNumber]];
    [[UIApplication sharedApplication] openURL:phone_url];
}

- (IBAction)actionLogOut:(id)sender {

    [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[RawCacheManager sharedRawCacheManager] clearLoginCache];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Has_Login_Out object:nil];
            [self refreshUI];
        }
    } title:@"温馨提示" message:@"您确定要退出当前帐号？" cancelButtonName:@"取消" otherButtonTitles:@"确定", nil];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = @"我的";
    self.userAvatorImageView.layer.cornerRadius = 10;
    self.userAvatorImageView.clipsToBounds = YES;
    [self refreshUI];
}

- (void)refreshUI {
    
    UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
    if (userInfo) {
        
        self.userNameLabel.hidden = NO;
        self.phoneLabel.hidden = NO;
        self.nextPageImageView.hidden = NO;
        self.signOutButton.hidden = NO;
        self.tipsLabel.hidden = YES;
        
        [self.userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"default_avator"]];
        self.userNameLabel.text = [RawCacheManager sharedRawCacheManager].userInfo.nick;
        NSString *account =userInfo.mobile;
        NSString *abbreviate = [NSString stringWithFormat:@"%@****%@", [account substringWithRange:NSMakeRange(0, 3)], [account substringFromIndex:7]];
        self.phoneLabel.text = abbreviate;
        
        self.userTypeName.text = userInfo.groupName;
        self.userGradeStarView.hidden = NO;
        [self.userGradeStarView refreshViewLevel:userInfo.grade];
        self.userTypeNextPageImageView.hidden = !userInfo.needProfile;
        
        NSInteger pointCount = [RawCacheManager sharedRawCacheManager].userInfo.point;
        self.pointCountLabel.text = [NSString stringWithFormat:@"%td积分", pointCount];
    }else {
        self.userNameLabel.hidden = YES;
        self.phoneLabel.hidden = YES;
        self.nextPageImageView.hidden = YES;
        self.signOutButton.hidden= YES;
        self.tipsLabel.hidden = NO;
        
        self.userAvatorImageView.image = [UIImage imageNamed:@"default_avator"];
       
        self.userTypeName.text = @"";
        self.userGradeStarView.hidden = YES;
        self.userTypeNextPageImageView.hidden = YES;
        
        self.pointCountLabel.text = @"积分";
        
    }
    self.phoneNumber.text = [RawCacheManager sharedRawCacheManager].config.serviceNumber;
    NSInteger count = [RawCacheManager sharedRawCacheManager].userInfo.quanCount;
    if (count>0) {
        self.vouchersCountLabel.text = @(count).stringValue;
        self.vouchersCountView.hidden = NO;
    }else {
        self.vouchersCountView.hidden = YES;
    }
    
}

@end
