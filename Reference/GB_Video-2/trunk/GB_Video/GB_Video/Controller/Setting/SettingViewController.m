//
//  SettingViewController.m
//  GB_Video
//
//  Created by gxd on 2018/2/1.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "SettingViewController.h"
#import "GBPersonViewController.h"
#import "GBModifyAccViewController.h"
#import "GBModifyPwdViewController.h"
#import "GBBindPhoneViewController.h"

#import "SettingTextTableViewCell.h"
#import "SettingSwitchTableViewCell.h"
#import "SettingSectionHeaderView.h"
#import "GBSettingConstant.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBPersonViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

#pragma mark - NSNotification

- (void)userInfoChangeNotification {
    
    [self.tableView reloadData];
}

#pragma mark - Private

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChangeNotification) name:Notification_User_BaseInfo object:nil];
}

#pragma mark - Private
- (void)setupUI {
    
    self.title = LS(@"setting.nav.setting");
    [self setupBackButtonWithBlock:nil];
    
    [self setupTableView];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingTextTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingSwitchTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingSwitchTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingSectionHeaderView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"SettingSectionHeaderView"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Setter and Getter
- (NSArray<NSArray<NSString *> *> *)titleList {
    
    return  @[@[LS(@"setting.label.modify.phone"), LS(@"setting.label.modify.password")],
                  @[LS(@"setting.label.network")]];

}

- (NSArray<NSArray<NSString *> *> *)descList {
    
    NSString *isNOWifi = @([RawCacheManager sharedRawCacheManager].isNoWifi).stringValue;
    
    if ([RawCacheManager sharedRawCacheManager].isLogined) {
        NSString *account = [RawCacheManager sharedRawCacheManager].lastAccount;
        NSString *abbreviate = [NSString stringWithFormat:@"%@****%@", [account substringWithRange:NSMakeRange(0, 3)], [account substringFromIndex:7]];
        return @[@[abbreviate, @""], @[isNOWifi]];
    }else {
        return @[@[LS(@"setting.label.unbind"), LS(@"setting.label.unbind")], @[isNOWifi]];
    }
    
}

- (NSArray<NSString *> *)sectionTitleList {
    
    return @[@"", @""];
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
        NSInteger isNOWifi = self.descList[indexPath.section][indexPath.row].boolValue;
        cell.siwtchView.on = (isNOWifi==1);
        cell.siwtchView.action = ^{
            NSInteger tmp = (isNOWifi==1)?0:1;
            [RawCacheManager sharedRawCacheManager].isNoWifi = tmp;
            [self.tableView reloadData];
            
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
                [self clickAccountCell];
                break;
            case 1:
                [self clickPasswordCell];
                break;
                
            default:
                break;
        }
    }
}

- (void)clickAccountCell {
    
    if ([RawCacheManager sharedRawCacheManager].isLogined) {
        if (![NSString stringIsNullOrEmpty:[RawCacheManager sharedRawCacheManager].userInfo.phone]) {
            [self.navigationController pushViewController:[GBModifyAccViewController new] animated:YES];
        }else {
            [self.navigationController pushViewController:[GBBindPhoneViewController new] animated:YES];
        }
        
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NeedLogin object:nil];
    }
    
}

- (void)clickPasswordCell {
    
    if ([RawCacheManager sharedRawCacheManager].isLogined) {
        if (![NSString stringIsNullOrEmpty:[RawCacheManager sharedRawCacheManager].userInfo.phone]) {
            [self.navigationController pushViewController:[GBModifyPwdViewController new] animated:YES];
        }else {
            [self.navigationController pushViewController:[GBBindPhoneViewController new] animated:YES];
        }
        
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NeedLogin object:nil];
    }
    
}

@end
