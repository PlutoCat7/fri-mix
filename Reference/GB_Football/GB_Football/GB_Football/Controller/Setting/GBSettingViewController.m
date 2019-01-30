//
//  GBSettingViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/8.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBSettingViewController.h"
#import "GBMenuViewController.h"
#import "GBScanViewController.h"
#import "GBPersonInfoViewController.h"
#import "GBAboutAccountViewController.h"
#import "GBMallViewController.h"
#import "GBSystemSettingViewController.h"
#import "GBMyWristViewController.h"
#import "GBWebBrowserViewController.h"
#import "GBAboutUsViewController.h"

#import "SettingHeaderView.h"
#import "SettingFooterView.h"
#import "SettingTextTableViewCell.h"
#import "SettingSectionHeaderView.h"

#import "GBBluetoothManager.h"
#import "SystemRequest.h"
#import "GBSettingConstant.h"

@interface GBSettingViewController () <
UITableViewDelegate,
UITableViewDataSource,
SettingFooterViewDelegate,
SettingHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SettingHeaderView *tableHeaderView;

@end

@implementation GBSettingViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupNotification];
    
    [self autoCheckFirewareUpdate];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self.tableHeaderView refreshUI];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.tableHeaderView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,(NSInteger)((280.f/1334)*[UIScreen mainScreen].bounds.size.height));
        [self.tableView setTableHeaderView:self.tableHeaderView];

        self.tableView.contentSize = CGSizeMake(self.tableView.width, self.tableView.height);
    });
}

#pragma mark - NSNotification

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindSuccessNotification) name:Notification_ConnectSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindSuccessNotification) name:Notification_BindSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelBindSuccessNotification) name:Notification_CancelBindSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelConnectNotification) name:Notification_CancelConenctSuccess object:nil];
}

- (void)bindSuccessNotification {
    
    [self refreshiBeaconInfo];
}

- (void)cancelBindSuccessNotification {
    
    [self refreshiBeaconInfo];
}

- (void)cancelConnectNotification {
    
    [self refreshiBeaconInfo];
}

#pragma mark - Private

- (void)loadData {
    
}

- (void)setupUI {
    
    self.title = LS(@"setting.nav.title");
    [self setupBackButtonWithBlock:nil];
    
    [self setupTableView];
    
    [self refreshiBeaconInfo];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingTextTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingSectionHeaderView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"SettingSectionHeaderView"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.tableHeaderView;
}

- (void)refreshiBeaconInfo {
    
    [self.tableView reloadData];
}

- (void)autoCheckFirewareUpdate {
    
    if (![[GBBluetoothManager sharedGBBluetoothManager] isConnectedBean]) {
        return;
    }
    [[UpdateManager shareInstance] checkFirewareUpdate:nil];
}

#pragma mark - Setter and Getter

- (SettingHeaderView *)tableHeaderView {
    
    if (!_tableHeaderView) {
        _tableHeaderView = [[NSBundle mainBundle]loadNibNamed:@"SettingHeaderView" owner:self options:nil].firstObject;
        _tableHeaderView.delegate = self;
    }
    return _tableHeaderView;
}

- (NSArray<NSArray<NSString *> *> *)titleList {
    
    NSString *title = LS(@"setting.wrist.state.title");
    if ([RawCacheManager sharedRawCacheManager].isBindWristband) {
        title = [NSString stringIsNullOrEmpty:[RawCacheManager sharedRawCacheManager].userInfo.wristbandInfo.handEquipName]?[RawCacheManager sharedRawCacheManager].userInfo.wristbandInfo.equipName:[RawCacheManager sharedRawCacheManager].userInfo.wristbandInfo.handEquipName;
        if (!title) {
            title = @"";
        }
    }
    return  @[@[title],
              @[LS(@"setting.label.instruction"),LS(@"mall.nav.title"), LS(@"setting.setting.title")],
              @[LS(@"setting.nav.about.us")]];
}

- (NSArray<NSArray<NSString *> *> *)descList {
    
    NSString *bandStateString = @"";
    if (![[RawCacheManager sharedRawCacheManager] isBindWristband]) {
        bandStateString = LS(@"menu.icon.unbind");
    }else {
        if (![[GBBluetoothManager sharedGBBluetoothManager] isConnectedBean]) {
            bandStateString = LS(@"setting.device.unconnected");
        }else {
            bandStateString = LS(@"menu.icon.connected");
        }
    }
    return  @[@[bandStateString],
              @[@"",@"", @""],
              @[@""]];
}

- (NSArray<NSArray<UIColor *> *> *)descColorList {
    
    UIColor *defaultColor = [UIColor colorWithHex:0x5b5b5b];
    UIColor *bandSatteColor = [UIColor colorWithHex:0x5b5b5b];
    if ([[RawCacheManager sharedRawCacheManager] isBindWristband]) {
        if (![[GBBluetoothManager sharedGBBluetoothManager] isConnectedBean]) {
            bandSatteColor = [UIColor greenColor];
        }
    }else {
        bandSatteColor = [UIColor greenColor];
    }
    
    return  @[@[bandSatteColor],
              @[defaultColor, defaultColor, defaultColor],
              @[defaultColor]];
}


- (NSArray<NSString *> *)sectionTitleList {
    
    NSString *title = @"";
    if ([[RawCacheManager sharedRawCacheManager] isBindWristband]) {
        title = LS(@"setting.has.band.wrist.title");
    }
    return @[title,
             @"",
             @""];
}



#pragma mark - Delegate

#pragma mark SettingHeaderViewDelegate

- (void)didClickUserInfo {
    
    [self.navigationController pushViewController:[GBPersonInfoViewController new] animated:YES];
}

#pragma mark SettingFooterViewDelegate

- (void)didClickFooterView {
    
    @weakify(self)
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self showLoadingToast];
            [SystemRequest bindWristband:nil handler:^(id result, NSError *error) {
                @strongify(self)
                if (error) {
                    [self showToastWithText:error.domain];
                }else {
                    [[GBBluetoothManager sharedGBBluetoothManager] disconnectBeacon];
                    [[GBBluetoothManager sharedGBBluetoothManager] resetGBBluetoothManager];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CancelBindSuccess object:nil];
                    [self showToastWithText:LS(@"setting.hint.unbind.success")];
                }
            }];
        }
    } title:LS(@"common.popbox.title.tip") message:LS(@"setting.hint.unbind") cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.yes") style:GBALERT_STYLE_NOMAL];
}

#pragma mark UITableViewDelegate

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleList.count;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleList[section].count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTextTableViewCell"];
    cell.titleLabel.text = self.titleList[indexPath.section][indexPath.row];
    cell.descLabel.text = self.descList[indexPath.section][indexPath.row];
    cell.descLabel.textColor = self.descColorList[indexPath.section][indexPath.row];
    
    return cell;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*kAppScale;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = self.sectionTitleList[section];
    if (![NSString stringIsNullOrEmpty:sectionTitle]) {
        return 48*kAppScale;
    }else {
        return 15*kAppScale;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SettingSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SettingSectionHeaderView"];
    headerView.titleLabel.text= self.sectionTitleList[section];
    
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        [self clickBandCell];
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self clickQACell];
        } else if (indexPath.row == 1) {
            [self clickShopCell];
        }else if (indexPath.row == 2) {
            [self clickSettingCell];
        }
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self clickAboutUs];
        }
    }
}

- (void)clickBandCell {
    
    if (![[RawCacheManager sharedRawCacheManager] isBindWristband]) {
        [self.navigationController pushViewController:[GBScanViewController new] animated:YES];
    }else {
        //进入我的球芯
        [self.navigationController pushViewController:[GBMyWristViewController new] animated:YES];
    }
}

- (void)clickQACell {
    NSDictionary *urlDic = @{@(LanguageItemType_Hans):@"https://t-goal.oss-cn-hangzhou.aliyuncs.com/web-page/help_zn.html",
                             @(LanguageItemType_English):@"https://t-goal.oss-cn-hangzhou.aliyuncs.com/web-page/help_en.html",
                             @(LanguageItemType_Hant):@"http://t-goal.oss-cn-hangzhou.aliyuncs.com/web-page/help_fan.html"};
    
    NSString *helpUrl = urlDic[@([[LanguageManager sharedLanguageManager] getCurrentAppLanguage].languageType)];
    
    GBWebBrowserViewController *webController = [[GBWebBrowserViewController alloc] initWithTitle:LS(@"setting.label.instruction") url:helpUrl];
    [self.navigationController pushViewController:webController animated:YES];
}

- (void)clickWeChatCell {
    
    NSDictionary *urlDic = @{@(LanguageItemType_Hans):@"https://t-goal.oss-cn-hangzhou.aliyuncs.com/web-page/wechat_jc.html",
                             @(LanguageItemType_English):@"https://t-goal.oss-cn-hangzhou.aliyuncs.com/web-page/wechat_jc_en.html",
                             @(LanguageItemType_Hant):@"https://t-goal.oss-cn-hangzhou.aliyuncs.com/web-page/wechat_jc_fan.html"};
    
    NSString *helpUrl = urlDic[@([[LanguageManager sharedLanguageManager] getCurrentAppLanguage].languageType)];
    
    GBWebBrowserViewController *webController = [[GBWebBrowserViewController alloc] initWithTitle:LS(@"setting.nav.wechat.tutorial") url:helpUrl];
    [self.navigationController pushViewController:webController animated:YES];
}

- (void)clickShopCell {
    
    GBMallViewController *vc = [[GBMallViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickSettingCell {
    
    [self.navigationController pushViewController:[GBAboutAccountViewController new] animated:YES];
}

- (void)clickAboutUs {
    [self.navigationController pushViewController:[GBAboutUsViewController new] animated:YES];
}

@end
