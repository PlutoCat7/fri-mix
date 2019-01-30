//
//  GBAboutUsViewController.m
//  GB_Football
//
//  Created by gxd on 2018/1/10.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "GBAboutUsViewController.h"
#import "GBContactUsViewController.h"
#import "GBFeedbackViewController.h"
#import "SettingTextTableViewCell.h"
#import "SettingSectionHeaderView.h"
#import "SettingAboutHeaderView.h"

#import "GBSettingConstant.h"

@interface GBAboutUsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SettingAboutHeaderView *tableHeaderView;

@end

@implementation GBAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.tableHeaderView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,(NSInteger)((460.f/1334)*[UIScreen mainScreen].bounds.size.height));
        [self.tableView setTableHeaderView:self.tableHeaderView];
        
        self.tableView.contentSize = CGSizeMake(self.tableView.width, self.tableView.height);
    });
}

#pragma mark - Private

- (void)loadData {
    
}

- (void)setupUI {
    
    self.title = LS(@"setting.nav.about.us");
    [self setupBackButtonWithBlock:nil];
    
    [self setupTableView];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingTextTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingSectionHeaderView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"SettingSectionHeaderView"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.tableHeaderView;
}

#pragma mark - Setter and Getter

- (SettingAboutHeaderView *)tableHeaderView {
    
    if (!_tableHeaderView) {
        _tableHeaderView = [[NSBundle mainBundle]loadNibNamed:@"SettingAboutHeaderView" owner:self options:nil].firstObject;
    }
    return _tableHeaderView;
}

- (NSArray<NSArray<NSString *> *> *)titleList {
    
    return @[@[LS(@"setting.label.version"), LS(@"setting.label.contactus"), LS(@"setting.nav.feedback")]];
}

- (NSArray<NSArray<NSString *> *> *)descList {
    
    return @[@[[Utility appVersion], @"", @""]];
}

- (NSArray<NSString *> *)sectionTitleList {
    
    return @[@""];
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
            [self clickSoftwareVersionCell];
        }else if (indexPath.row == 1) {
            [self clickContactUsCell];
        }else if (indexPath.row == 2) {
            [self clickFeedbackCell];
        }
    }
}

- (void)clickSoftwareVersionCell {
    
    [[UpdateManager shareInstance] checkAppUpdate:nil];
}

- (void)clickContactUsCell {
    
    [self.navigationController pushViewController:[GBContactUsViewController new] animated:YES];
}

- (void)clickFeedbackCell {
    
    [self.navigationController pushViewController:[GBFeedbackViewController new] animated:YES];
}

@end
