//
//  GBMyWristViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/12.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBMyWristViewController.h"
#import "GBPesonNameViewController.h"

#import "SettingWristFooterView.h"
#import "SettingSwitchTableViewCell.h"
#import "SettingTextTableViewCell.h"
#import "SettingSectionHeaderView.h"
#import "SettingWristHeaderView.h"

#import "GBBluetoothManager.h"
#import "GBSettingConstant.h"
#import "SystemRequest.h"
#import "UserRequest.h"

@interface GBMyWristViewController () <
UITableViewDelegate,
UITableViewDataSource,
SettingWristHeaderViewDelegate,
SettingWristFooterViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SettingWristHeaderView *tableHeaderView;
@property (nonatomic, strong) SettingWristFooterView *tableFooterView;

@end

@implementation GBMyWristViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableHeaderView refreshUI];
    [self.tableView reloadData];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.tableView.contentSize = CGSizeMake(self.tableView.width, self.tableView.height);
    
    self.tableHeaderView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,(NSInteger)((360.f/1334)*[UIScreen mainScreen].bounds.size.height));
    [self.tableView setTableHeaderView:self.tableHeaderView];
    
    self.tableFooterView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,(NSInteger)((300.f/1334)*[UIScreen mainScreen].bounds.size.height));
    if (self.tableView.tableFooterView) {
        [self.tableView setTableFooterView:self.tableFooterView];
    }
    
}

#pragma mark - NSNotification

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccessNotification) name:Notification_ConnectSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelBindSuccessNotification) name:Notification_CancelBindSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelConnectNotification) name:Notification_CancelConenctSuccess object:nil];
}

- (void)connectSuccessNotification {
    
    [self.tableView reloadData];
    [self.tableHeaderView refreshUI];
    [self.tableView setTableFooterView:self.tableFooterView];
}

- (void)cancelBindSuccessNotification {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelConnectNotification {
    
    [self.tableView reloadData];
    [self.tableHeaderView refreshUI];
    [self.tableView setTableFooterView:nil];
}

#pragma mark - Action

#pragma mark - Private

- (void)loadData {
    
}

- (void)setupUI {
    
    self.title = LS(@"setting.wrist.nav.title");
    [self setupBackButtonWithBlock:nil];
    
    [self setupTableView];
    [self setupmenuButton];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingTextTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingSwitchTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingSwitchTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingSectionHeaderView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"SettingSectionHeaderView"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.t_goal_Version==iBeaconVersion_T_Goal_S && [GBBluetoothManager sharedGBBluetoothManager].isConnectedBean) {
        self.tableView.tableFooterView = self.tableFooterView;
    }
}

-(void)setupmenuButton
{
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 60, 40);
    [menuBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [menuBtn setTitle:LS(@"setting.device.release") forState:UIControlStateNormal];
    menuBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    @weakify(self)
    [menuBtn addActionHandler:^(NSInteger tag) {
        @strongify(self)
        
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
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
}

#pragma mark - Setter and Getter

- (SettingWristHeaderView *)tableHeaderView {
    
    if (!_tableHeaderView) {
        _tableHeaderView = [[NSBundle mainBundle]loadNibNamed:@"SettingWristHeaderView" owner:self options:nil].firstObject;
        _tableHeaderView.delegate = self;
    }
    return _tableHeaderView;
}

- (SettingWristFooterView *)tableFooterView {
    
    if (!_tableFooterView) {
        _tableFooterView = [[NSBundle mainBundle]loadNibNamed:@"SettingWristFooterView" owner:self options:nil].firstObject;
        _tableFooterView.delegate = self;
    }
    return _tableFooterView;
}

- (NSArray<NSArray<NSString *> *> *)titleList {
    
    if ([self canAddSportStep]) {
        return  @[@[LS(@"setting.label.nickname"), LS(@"setting.label.firmware")],
                  @[LS(@"setting.wirst.add.steps")]];
    }else {
        return  @[@[LS(@"setting.label.nickname"), LS(@"setting.label.firmware")]];
    }
    
}

- (NSArray<NSArray<NSString *> *> *)descList {
    
    NSString *nickName = [NSString stringIsNullOrEmpty:[RawCacheManager sharedRawCacheManager].userInfo.wristbandInfo.handEquipName]?[RawCacheManager sharedRawCacheManager].userInfo.wristbandInfo.equipName:[RawCacheManager sharedRawCacheManager].userInfo.wristbandInfo.handEquipName;
    nickName = nickName?nickName:@"";
    NSString *firewareVersion = [GBBluetoothManager sharedGBBluetoothManager].isConnectedBean ? [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.firewareVersion : LS(@"setting.device.unconnected");
    firewareVersion = firewareVersion?firewareVersion:@"";
    if ([self canAddSportStep]) {
        NSString *isNOJoin = @([RawCacheManager sharedRawCacheManager].userInfo.config.match_add_dail).stringValue;
        return  @[@[nickName, firewareVersion],
                  @[isNOJoin]];
    }else {
        return  @[@[nickName, firewareVersion]];
    }
    
}

- (NSArray<NSString *> *)sectionTitleList {
    
    if ([self canAddSportStep]) {
        return @[@"",
                 LS(@"setting.wirst.section.title")];
    }else {
        return @[@""];
    }
}

- (BOOL)canAddSportStep {
    
    if ([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.t_goal_Version==iBeaconVersion_T_Goal_S && [[GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.firewareVersion floatValue]>2.1 + 0.0001 && [GBBluetoothManager sharedGBBluetoothManager].isConnectedBean) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Delegate

#pragma mark SettingFooterViewDelegate

- (void)didClickWristHeader {
    if (![[GBBluetoothManager sharedGBBluetoothManager] isConnectedBean]) {
        [[GBBluetoothManager sharedGBBluetoothManager] connectBeaconWithUI:nil];
    }
}

- (void)didClickRestart {
    
    [self showLoadingToast];
    @weakify(self)
    [[GBBluetoothManager sharedGBBluetoothManager] restartDevieWithComplete:^(NSError *error) {
        @strongify(self)
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [self performBlock:^{
                [self showToastWithText:LS(@"setting.button.restart.tips")];
            } delay:1.5f];
        }
    }];
}

- (void)didClickClose {
    @weakify(self)
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self showLoadingToast];
            [[GBBluetoothManager sharedGBBluetoothManager] closeDeviceWithComplete:^(NSError *error) {
                @strongify(self)
                if (error) {
                    [self showToastWithText:error.domain];
                }else {
                    [self performBlock:^{
                        [[GBBluetoothManager sharedGBBluetoothManager] disconnectBeacon];
                        
                        [self showToastWithText:LS(@"setting.label.close.tips")];
                    } delay:1.5f];
                }
            }];
            
        }
    } title:LS(@"common.popbox.title.tip") message:LS(@"setting.label.close.hint") cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.yes") style:GBALERT_STYLE_NOMAL];
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
    if (indexPath.section == 1 && indexPath.row == 0) {
        SettingSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingSwitchTableViewCell"];
        cell.titleLabel.text = self.titleList[indexPath.section][indexPath.row];
        NSInteger isJoin = self.descList[indexPath.section][indexPath.row].boolValue;
        cell.siwtchView.on = (isJoin==1);
        cell.siwtchView.action = ^{
            NSInteger tmp = (isJoin==1)?0:1;
            [self showLoadingToast];
            @weakify(self)
            [UserRequest updateUserConfigMatchAddDaily:tmp handler:^(id result, NSError *error) {
                
                @strongify(self)
                [self dismissToast];
                if (error) {
                    [self showToastWithText:error.domain];
                }else {
                    [self.tableView reloadData];
                }
            }];
        };
        
        return cell;
    }else {
        SettingTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTextTableViewCell"];
        cell.titleLabel.text = self.titleList[indexPath.section][indexPath.row];
        cell.descLabel.text = self.descList[indexPath.section][indexPath.row];
        
        return cell;
    }
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SettingTextCellHeight;
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
        switch (indexPath.row) {
            case 0:
                [self clickNickNameCell];
                break;
            case 1:
                [self clickFirewareCell];
                break;
                
            default:
                break;
        }
    }
}

- (void)clickNickNameCell {
    
    GBPesonNameViewController *nameViewController = [[GBPesonNameViewController alloc] initWithTitle:LS(@"personal.label.nickname") placeholder:LS(@"personal.placeholder.nickname")];
    nameViewController.defaltName = [self descList][0][0];
    nameViewController.minLenght = 2;
    nameViewController.maxLength = 16;
    @weakify(self)
    nameViewController.saveBlock = ^(NSString *name){
        
        @strongify(self)
        [self.navigationController.topViewController showLoadingToast];
        [SystemRequest resetWristbandName:name handler:^(id result, NSError *error) {
            [self.navigationController.topViewController dismissToast];
            if (error) {
                [self.navigationController.topViewController showToastWithText:error.domain];
            }else {
                [RawCacheManager sharedRawCacheManager].userInfo.wristbandInfo.handEquipName = name;
                [self.tableView reloadData];
                
                [self.navigationController yh_popViewController:self.navigationController.topViewController animated:YES];
            }
        }];
    };
    [self.navigationController pushViewController:nameViewController animated:YES];
}

- (void)clickFirewareCell {
    
    if (![GBBluetoothManager sharedGBBluetoothManager].isConnectedBean) {
        return;
    }
    
    [self showLoadingToast];
    @weakify(self)
    [[UpdateManager shareInstance] checkFirewareUpdate:^(NSString *url, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else if (url.length == 0) {
            [self showToastWithText:LS(@"setting.hint.firmware.latest")];
        }
    }];
}


@end
