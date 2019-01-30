//
//  GBGenderViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/9.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBGenderViewController.h"

#import "SettingSectionHeaderView.h"
#import "SettingSelectTableViewCell.h"

#import "UserRequest.h"

@interface GBGenderViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, assign) SexType currentSexType;
@property (nonatomic, strong) UserInfo *userInfo;

@end

@implementation GBGenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Action

- (void)saveClick {
    
    self.userInfo.sexType = self.currentSexType;
    [self showLoadingToast];
    @weakify(self)
    [UserRequest updateUserInfo:self.userInfo handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self showToastWithText:error.domain];
        }
    }];
}

#pragma mark - Private

- (void)loadData {
    
    self.userInfo = [[RawCacheManager sharedRawCacheManager].userInfo copy];
    self.currentSexType = self.userInfo.sexType;
}

- (void)setupUI {
    
    self.title = LS(@"personal.nav.gender");
    [self setupBackButtonWithBlock:nil];
    [self setupNavigationBarRight];
    
    [self setupTableView];
}

- (void)setupNavigationBarRight {
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setSize:CGSizeMake(48, 24)];
    [self.saveButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [self.saveButton setTitle:LS(@"common.btn.save") forState:UIControlStateNormal];
    [self.saveButton setTitle:LS(@"common.btn.save") forState:UIControlStateHighlighted];
    [self.saveButton setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[ColorManager styleColor_50] forState:UIControlStateDisabled];
    self.saveButton.backgroundColor = [UIColor clearColor];
    self.saveButton.enabled = NO;
    [self.saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    rightButton.enabled = NO;
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)checkSaveEnable {
    
    self.saveButton.enabled = (self.currentSexType != self.userInfo.sexType);
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingSelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingSelectTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingSectionHeaderView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"SettingSectionHeaderView"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSArray<NSString *> *)titleList {
    
    return  @[LS(@"personal.label.male"), LS(@"personal.label.female")];
}

#pragma mark - UITableViewDelegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.titleList.count;
}
              
// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SettingSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingSelectTableViewCell"];
    cell.type = SettingSelectTableViewCellType_Select;
    cell.titleLabel.text = self.titleList[indexPath.row];
    if (indexPath.row == 0) {
        cell.selectImageView.hidden = !(self.currentSexType == SexType_Male);
    }else {
        cell.selectImageView.hidden = !(self.currentSexType == SexType_Female);
    }
    
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
    return 15*kAppScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SettingSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SettingSectionHeaderView"];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        self.currentSexType = SexType_Male;
    }else {
        self.currentSexType = SexType_Female;
    }
    [tableView reloadData];
    
    [self checkSaveEnable];
}

@end
