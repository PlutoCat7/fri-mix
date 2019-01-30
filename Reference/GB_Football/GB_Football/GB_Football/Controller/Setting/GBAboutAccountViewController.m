//
//  GBAboutAccountViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/10.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBAboutAccountViewController.h"
#import "GBModifyAccViewController.h"
#import "GBModifyPwdViewController.h"
#import "GBLanguageViewController.h"

#import "SettingFooterView.h"
#import "SettingTextTableViewCell.h"
#import "SettingSectionHeaderView.h"

#import "GBSettingConstant.h"

@interface GBAboutAccountViewController () <
UITableViewDelegate,
UITableViewDataSource,
SettingFooterViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) SettingFooterView *tableFooterView;

@end

@implementation GBAboutAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self refreshUI];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.tableFooterView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,SettingFooterViewHeight);
        if (self.tableView.tableFooterView) {
            [self.tableView setTableFooterView:self.tableFooterView];
        }
    });
    
}

#pragma mark - Private

- (void)loadData {
    
}

- (void)setupUI {
    
    self.title = LS(@"setting.nav.account");
    [self setupBackButtonWithBlock:nil];
    
    [self setupTableView];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingTextTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingSectionHeaderView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"SettingSectionHeaderView"];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.tableFooterView;
}

- (void)refreshUI {
    
    [self.tableView reloadData];
}

#pragma mark - Setter and Getter

- (SettingFooterView *)tableFooterView {
    
    if (!_tableFooterView) {
        _tableFooterView = [[NSBundle mainBundle]loadNibNamed:@"SettingFooterView" owner:self options:nil].firstObject;
        _tableFooterView.delegate = self;
        _tableFooterView.titleLabel.text = LS(@"setting.label.logout");
    }
    return _tableFooterView;
}

- (NSArray<NSArray<NSString *> *> *)titleList {
    
    return @[@[LS(@"setting.label.language"), LS(@"setting.label.account"), LS(@"setting.label.passord")]];
}


- (NSArray<NSArray<NSString *> *> *)descList {
    
    NSString *account = [RawCacheManager sharedRawCacheManager].lastAccount;
    NSString *abbreviate = [NSString stringWithFormat:@"%@****%@", [account substringWithRange:NSMakeRange(0, 3)], [account substringFromIndex:7]];
    //获取APP当前语言
    LanguageItem *curLanguage = [[LanguageManager sharedLanguageManager] getCurrentAppLanguage];
    return @[@[curLanguage.langName, abbreviate, @""]];
}

- (NSArray<NSString *> *)sectionTitleList {
    
    return @[@""];
}

#pragma mark SettingFooterViewDelegate

- (void)didClickFooterView {
    
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NeedLogin object:nil];
        }
    } title:LS(@"common.popbox.title.tip") message:LS(@"setting.hint.exit") cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.yes") style:GBALERT_STYLE_NOMAL];
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
        if (indexPath.row == 0) {
            [self clickLanguageCell];
        }else if (indexPath.row == 1) {
            [self clickAccountCell];
        }else if (indexPath.row == 2) {
            [self clickPasswordCell];
        }
    }
}

- (void)clickLanguageCell {
    
    [self.navigationController pushViewController:[GBLanguageViewController new] animated:YES];
}

- (void)clickAccountCell {
    
    [self.navigationController pushViewController:[GBModifyAccViewController new] animated:YES];
}

- (void)clickPasswordCell {
    
    [self.navigationController pushViewController:[GBModifyPwdViewController new] animated:YES];
}

@end
