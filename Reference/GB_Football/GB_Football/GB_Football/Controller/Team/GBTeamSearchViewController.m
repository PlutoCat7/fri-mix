//
//  GBTeamSearchViewController.m
//  GB_Football
//
//  Created by gxd on 17/7/14.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamSearchViewController.h"
#import "GBMenuViewController.h"
#import "GBBaseViewController+Empty.h"
#import "GBTeamGuestHomePageViewController.h"

#import "MJRefresh.h"
#import "GBTeamSearchCell.h"
#import "UIImageView+WebCache.h"

#import "TeamRequest.h"
#import "AddressBookObject.h"
#import "TeamSearchRequest.h"

@interface GBTeamSearchViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *tableHeader;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

//通讯录
@property (nonatomic, strong) NSArray<NSString *> *phoneList;
@property (nonatomic, strong) NSArray<TeamInfo *> *recommendList;

//搜索
@property (nonatomic, assign, getter=isSearching) BOOL searching;
@property (nonatomic, strong) NSArray<TeamInfo *> *searchList;
@property (nonatomic, strong) TeamSearchRequest *teamSearchRequest;

@end

@implementation GBTeamSearchViewController

#pragma mark -
#pragma mark Memory

#pragma mark - Life Cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)localizeUI {
    self.searchTextField.placeholder = LS(@"team.search.label.search.placehold");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidEndEdit:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidBeginEdit:) name:UITextFieldTextDidBeginEditingNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableHeader.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,(208.f/1334)*[UIScreen mainScreen].bounds.size.height);
        [self.tableView setTableHeaderView:self.tableHeader];
    });
}

#pragma mark - Public
- (void)clearSearchResult {
    
    self.searchTextField.text = @"";
    [self.searchTextField resignFirstResponder];
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    if (notification.object != self.searchTextField) {
        return;
    }
}

- (void)textFieldTextDidEndEdit:(NSNotification *)notification {
    
    if (notification.object != self.searchTextField) {
        return;
    }
}

- (void)textFieldTextDidBeginEdit:(NSNotification *)notification {
    
    if (notification.object != self.searchTextField) {
        return;
    }
}

#pragma mark - Delegate
#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    self.searching = textField.text.length>0;
    if ([string isEqualToString:@"\n"]) {
        //收起键盘
        [self.searchTextField resignFirstResponder];
        [self getSearchTeamList];
        return NO;
    }
    return YES;
}

- (IBAction)actionPressSearch:(id)sender {
    [self getSearchTeamList];
}

#pragma mark - Private
- (void)setupUI {
    
    self.title = LS(@"team.search.nav.title");
    [self setupBackButtonWithBlock:nil];
    
    self.searchTextField.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"GBTeamSearchCell" bundle:nil] forCellReuseIdentifier:@"GBTeamSearchCell"];
    self.tableView.tableHeaderView = self.tableHeader;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.emptyScrollView = self.tableView;
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        if (self.isSearching) {
            [self getSearchTeamList];
        } else {
            [self getRecommendTeamList];
        }
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_header = mj_header;
}

- (void)loadData {
    
    self.phoneList = [AddressBookObject getAddrBookPhoneList];
    [self getRecommendTeamList];
}

- (void)getRecommendTeamList {
    [self showLoadingToast];
    @weakify(self)
    [TeamRequest recommendTeamList:self.phoneList handler:^(id result, NSError *error) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
            self.recommendList = nil;
        }else {
            self.recommendList = result;
            self.isShowEmptyView = self.recommendList.count == 0;
            [self.tableView reloadData];
        }
    }];
}

- (void)getSearchTeamList {
    [self.searchTextField resignFirstResponder];
    NSString *search = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([NSString stringIsNullOrEmpty:search]) {
        [self getRecommendTeamList];
        return;
    }
    
    self.teamSearchRequest.searchKey = search;
    [self showLoadingToast];
    @weakify(self)
    [self.teamSearchRequest reloadPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
            [self.tableView reloadData];
        }else {
            self.searchList = self.teamSearchRequest.responseInfo.items;
            self.isShowEmptyView = self.searchList.count == 0;
            [self.tableView reloadData];
        }
    }];
}

- (void)getNextSearchTeamList {
    
    @weakify(self)
    [self.teamSearchRequest loadNextPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        if (!error) {
            self.searchList = self.teamSearchRequest.responseInfo.items;
            [self.tableView reloadData];
        } else {
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Getters & Setters
- (TeamSearchRequest *)teamSearchRequest {
    
    if (!_teamSearchRequest) {
        _teamSearchRequest = [[TeamSearchRequest alloc] init];
    }
    
    return _teamSearchRequest;
}

- (TeamInfo *)findTeamWithIndexPath:(NSIndexPath *)indexPath {
    
    @try {
        TeamInfo *info = self.isSearching?self.searchList[indexPath.row]:self.recommendList[indexPath.row];
        
        return info;
    } @catch (NSException *exception) {
        return nil;
    }
    
}

#pragma mark - Table Delegate
// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isSearching?self.searchList.count:self.recommendList.count;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.f;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamInfo *info = [self findTeamWithIndexPath:indexPath];
    GBTeamSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBTeamSearchCell"];
    
    cell.teamNameLabel.text = info.teamName;
    cell.teamAddrLabel.text = [LogicManager areaStringWithProvinceId:info.provinceId cityId:info.cityId regionId:0];
    [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:info.teamIcon] placeholderImage:[UIImage imageNamed:@"portrait"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamInfo *info = [self findTeamWithIndexPath:indexPath];
    
    GBTeamGuestHomePageViewController *vc = [[GBTeamGuestHomePageViewController alloc] initWithTeamInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearching && ![self.teamSearchRequest isLoadEnd] &&
        self.teamSearchRequest.responseInfo.items.count-1 == indexPath.row) {
        [self getNextSearchTeamList];
    }
}

@end
