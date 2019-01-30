//
//  GBPersonViewController.m
//  GB_Video
//
//  Created by gxd on 2018/1/26.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBPersonViewController.h"
#import "GBPerEditViewController.h"
#import "SettingViewController.h"

#import "GBView.h"
#import "GBSettingConstant.h"
#import "SettingTextTableViewCell.h"
#import "SettingFooterView.h"
#import "UIImageView+WebCache.h"
#import "UserRequest.h"

@interface GBPersonViewController () <SettingFooterViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet GBView *avtorFrameView;
@property (weak, nonatomic) IBOutlet UIImageView *avtorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SettingFooterView *tableFooterView;

@end

@implementation GBPersonViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupNotification];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.tableFooterView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SettingFooterViewHeight);
        if (self.tableView.tableFooterView) {
            [self.tableView setTableFooterView:self.tableFooterView];
        }
    });
    
}

#pragma mark - NSNotification

- (void)userInfoChangeNotification {
    
    [self updateUserData];
}

- (void)loginSuccessNotification {
    [self updateUserData];
}

- (void)logoutSuccessNotification {
    [self updateUserData];
}

#pragma mark - Action

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionSetting:(id)sender {
    [self.navigationController pushViewController:[SettingViewController new] animated:YES];
}

- (IBAction)actionLogin:(id)sender {
    if (![RawCacheManager sharedRawCacheManager].isLogined) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NeedLogin object:nil];
    }
}

- (IBAction)actionEdit:(id)sender {
    [self.navigationController pushViewController:[GBPerEditViewController new] animated:YES];
}

- (IBAction)actionFavor:(id)sender {
    if (![RawCacheManager sharedRawCacheManager].isLogined) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NeedLogin object:nil];
        
    } else {
        
    }
}

- (IBAction)actionMessage:(id)sender {
    if (![RawCacheManager sharedRawCacheManager].isLogined) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NeedLogin object:nil];
        
    } else {
        
    }
}

#pragma mark - Private

- (void)loadData {
    
}

- (void)loadNetworkData {
    [UserRequest getUserInfoWithHandler:^(id result, NSError *error) {
        if (!error) {
            [self updateUserData];
        }
    }];
}

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChangeNotification) name:Notification_User_BaseInfo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessNotification) name:Notification_Login object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccessNotification) name:Notification_Logout object:nil];
}

- (void)setupUI {
    
    [self setupUserView];
    [self setupTableView];
    
    [self updateUserData];
}

- (void)setupUserView {
    [self.avtorFrameView.layer setCornerRadius:self.avtorFrameView.width/2];
    [self.avtorFrameView.layer setMasksToBounds:YES];
    
    [self.avtorImageView.layer setCornerRadius:self.avtorImageView.width/2];
    [self.avtorImageView.layer setMasksToBounds:YES];
    
    self.editButton.backgroundColor = [UIColor colorWithHex:0xffffff andAlpha:0.3];
    //关键语句
    self.editButton.layer.cornerRadius = self.editButton.bounds.size.height/2;
    self.editButton.layer.borderColor = [UIColor colorWithHex:0xffffff].CGColor;
    self.editButton.layer.borderWidth = 1.0f;
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingTextTableViewCell"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.tableFooterView;
}

- (void)updateUserData {
    
    if ([RawCacheManager sharedRawCacheManager].isLogined) {
        UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
        
        self.nameLabel.text = [userInfo.nick length] == 0 ? userInfo.phone : userInfo.nick;
        self.addrLabel.text = [LogicManager areaStringWithProvinceId:userInfo.provinceId cityId:userInfo.cityId regionId:userInfo.regionId];
        
        [self.avtorImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"portrait.png"]];
        self.editButton.hidden = NO;
        self.loginButton.hidden = YES;
        
        self.tableFooterView.hidden = NO;
        
    } else {
        self.nameLabel.text = LS(@"setting.label.login.regist");
        self.addrLabel.text = LS(@"setting.hint.login");
        
        self.avtorImageView.image = [UIImage imageNamed:@"portrait.png"];
        self.editButton.hidden = YES;
        self.loginButton.hidden = NO;
        
        self.tableFooterView.hidden = YES;
    }
}

#pragma mark - Setter and Getter

- (NSArray<NSArray<NSString *> *> *)titleList {
    
    return @[@[LS(@"setting.nav.about.us"), LS(@"setting.nav.version"), LS(@"setting.nav.feedback")]];
}


- (NSArray<NSArray<NSString *> *> *)descList {
    
    return @[@[@"", [Utility appVersion], @""]];
}

- (NSArray<NSString *> *)sectionTitleList {
    
    return @[@""];
}

- (SettingFooterView *)tableFooterView {
    
    if (!_tableFooterView) {
        _tableFooterView = [[NSBundle mainBundle]loadNibNamed:@"SettingFooterView" owner:self options:nil].firstObject;
        _tableFooterView.delegate = self;
        _tableFooterView.titleLabel.text = LS(@"setting.label.logout");
    }
    return _tableFooterView;
}

#pragma mark SettingFooterViewDelegate

- (void)didClickFooterView {
    
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[RawCacheManager sharedRawCacheManager] clearLoginCache];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Logout object:nil];
        }
    } title:LS(@"common.popbox.title.tip") message:LS(@"setting.hint.exit") cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.yes") style:GBALERT_STYLE_NOMAL];
}

#pragma mark - UITableViewDelegate

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleList.count;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleList[section].count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTextTableViewCell"];
    cell.titleLabel.text = self.titleList[indexPath.section][indexPath.row];
    cell.descLabel.text = self.descList[indexPath.section][indexPath.row];
    
    return cell;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SettingTextCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self clickContactUsCell];
        }else if (indexPath.row == 1) {
            [self clickSoftwareVersionCell];
        }else if (indexPath.row == 2) {
            [self clickFeedbackCell];
        }
    }
}

- (void)clickContactUsCell {
    
}

- (void)clickSoftwareVersionCell {
    
}

- (void)clickFeedbackCell {
    
}

@end
