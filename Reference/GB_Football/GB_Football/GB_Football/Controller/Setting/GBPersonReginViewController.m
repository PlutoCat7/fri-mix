//
//  GBPersonReginViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/4/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBPersonReginViewController.h"

#import "SettingSelectTableViewCell.h"
#import "SettingSectionHeaderView.h"

#import "UserRequest.h"

@interface GBPersonReginViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) NSArray<AreaInfo *> *areaList;
@property (nonatomic, copy) NSString *regionName;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, assign) NSInteger selectAreaId;

@end

@implementation GBPersonReginViewController

- (instancetype)initWithAreaList:(NSArray<AreaInfo *> *)areaList selectRegion:(NSString *)regionName {
    
    self = [super init];
    if (self) {
        _areaList = areaList;
        _regionName = regionName;
    }
    
    return self;
}

#pragma mark - Action

- (void)saveClick {

    [self showLoadingToast];
    @weakify(self)
    [UserRequest updateUserInfo:self.userInfo handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (!error) {
            NSMutableArray<UIViewController *> *tmpList = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            while (1) {
                if ([tmpList.lastObject isKindOfClass:[GBPersonReginViewController class]]) {
                    [tmpList removeLastObject];
                }else {
                    break;
                }
            }
            [self.navigationController setViewControllers:[tmpList copy] animated:YES];
        }else {
            [self showToastWithText:error.domain];
        }
    }];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = LS(@"starcard.label.region");
    [self setupBackButtonWithBlock:nil];
    [self setupNavigationBarRight];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingSelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingSelectTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingSectionHeaderView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"SettingSectionHeaderView"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

#pragma mark Setter and Getter

- (UserInfo *)userInfo {
    
    if (!_userInfo) {
        _userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
    }
    
    return _userInfo;
}

#pragma mark - Delegate

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 48*kAppScale;
}


// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*kAppScale;
}

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isShowSelectRegion?2:1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SettingSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SettingSectionHeaderView"];
    NSString *text = LS(@"personal.region.all");
    if (self.isShowSelectRegion) {
        text = section==0?LS(@"personal.select.region"):LS(@"personal.region.all");
    }
    headerView.titleLabel.text = text;
    
    return headerView;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isShowSelectRegion && section==0) {
        return 1;
    }else {
        return self.areaList.count;
    }
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingSelectTableViewCell"];
    if (self.isShowSelectRegion && indexPath.section==0) {
        cell.type = SettingSelectTableViewCellType_Text;
        cell.titleLabel.text = self.regionName;
        cell.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        return cell;
    }
    
    AreaInfo *info = self.areaList[indexPath.row];
    cell.type = (info.areaChidlArray.count==0)?SettingSelectTableViewCellType_Select:SettingSelectTableViewCellType_Arrow;
    cell.selectImageView.hidden = (info.areaID == self.selectAreaId)?NO:YES;
    cell.titleLabel.text = info.areaName;

    return cell;
}

// 选择row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isShowSelectRegion && indexPath.section == 0) {
        return;
    }
    
    AreaInfo *areaInfo = self.areaList[indexPath.row];
    if (areaInfo.areaChidlArray > 0) {
        [self.navigationController pushViewController:[[GBPersonReginViewController alloc] initWithAreaList:areaInfo.areaChidlArray selectRegion:nil] animated:YES];
    }else {
        
        self.selectAreaId = areaInfo.areaID;
        self.saveButton.enabled = YES;
        
        AreaInfo *cityInfo = areaInfo.superAreaInfo;
        AreaInfo *provinceInfo = cityInfo.superAreaInfo;
        if (cityInfo && provinceInfo) {
            self.userInfo.provinceId = provinceInfo.areaID;
            self.userInfo.cityId = cityInfo.areaID;
            self.userInfo.regionId = areaInfo.areaID;
        }
        
        [tableView reloadData];
    }
}

@end
