//
//  GBSystemSettingViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/12.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBSystemSettingViewController.h"
#import "GBContactUsViewController.h"
#import "GBLanguageViewController.h"
#import "GBWebBrowserViewController.h"

#import "SettingTextTableViewCell.h"
#import "SettingSectionHeaderView.h"

#import "GBSettingConstant.h"

@interface GBSystemSettingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GBSystemSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Private

- (void)loadData {
    
}

- (void)setupUI {
    
    self.title = LS(@"setting.setting.title");
    [self setupBackButtonWithBlock:nil];
    
    [self setupTableView];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingTextTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingSectionHeaderView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"SettingSectionHeaderView"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Setter and Getter

- (NSArray<NSArray<NSString *> *> *)titleList {
    
    return @[@[LS(@"setting.label.language"), LS(@"setting.label.instruction"), LS(@"setting.label.contactus")],
             @[LS(@"setting.label.version")]];
}


- (NSArray<NSArray<NSString *> *> *)descList {
    
    //获取APP当前语言
    LanguageItem *curLanguage = [[LanguageManager sharedLanguageManager] getCurrentAppLanguage];
    return @[@[curLanguage.langName, @"", @""],
             @[[Utility appVersion]]];
}

- (NSArray<NSString *> *)sectionTitleList {
    
    return @[@"", @""];
}

#pragma mark - UITableViewDelegate

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
    return SettingTextCellHeight;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = self.sectionTitleList[section];
    if (![NSString stringIsNullOrEmpty:sectionTitle]) {
        return SettingSectionHeader_WithTitle_Height;
    }else {
        return SettingSectionHeader_Default_Height;
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
            [self clickQACell];
        }else if (indexPath.row == 2) {
            [self clicContactUsCell];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self clicSoftwareVersionCell];
        }
    }
}

- (void)clickLanguageCell {
    
    [self.navigationController pushViewController:[GBLanguageViewController new] animated:YES];
}

- (void)clickQACell {
    
    NSDictionary *urlDic = @{@(LanguageItemType_Hans):@"https://t-goal.oss-cn-hangzhou.aliyuncs.com/web-page/help_zn.html",
                             @(LanguageItemType_English):@"https://t-goal.oss-cn-hangzhou.aliyuncs.com/web-page/help_en.html",
                             @(LanguageItemType_Hant):@"http://t-goal.oss-cn-hangzhou.aliyuncs.com/web-page/help_fan.html"};

    NSString *helpUrl = urlDic[@([[LanguageManager sharedLanguageManager] getCurrentAppLanguage].languageType)];
    
    GBWebBrowserViewController *webController = [[GBWebBrowserViewController alloc] initWithTitle:LS(@"setting.label.instruction") url:helpUrl];
    [self.navigationController pushViewController:webController animated:YES];
}

- (void)clicContactUsCell {
    
    [self.navigationController pushViewController:[GBContactUsViewController new] animated:YES];
}

- (void)clicSoftwareVersionCell {
    
    [[UpdateManager shareInstance] checkAppUpdate:nil];
}

@end
