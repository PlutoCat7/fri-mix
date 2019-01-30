//
//  GBFieldListViewController.m
//  GB_Team
//
//  Created by weilai on 16/9/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBFieldListViewController.h"
#import "GBHomePageViewController.h"
#import "GBSatelliteViewController.h"
#import "GBFourCornerViewController.h"
#import "GBGamePrepareViewController.h"

#import "GBActionSheet.h"
#import "MJRefresh.h"
#import "GBFieldCell.h"

#import "CourtRequest.h"

@interface GBFieldListViewController () <
GBActionSheetDelegate,
AIMTableViewIndexBarDelegate,
UITextFieldDelegate>

// 表控件
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// 表头视图
@property (strong, nonatomic) IBOutlet UIView *tableHeader;
// 索引条
@property (weak, nonatomic) IBOutlet AIMTableViewIndexBar *indexBar;
// 搜索输入框
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

//正常显示
@property (nonatomic, strong) NSArray<CourtResponseData *> *originCourtDataList;
@property (nonatomic, strong) NSArray<CourtResponseData *> *showCourtDataList;

@end

@implementation GBFieldListViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewCourtNotification) name:Notification_CreateCourtSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBHomePageViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.tableHeader.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,(175.f/768)*[UIScreen mainScreen].bounds.size.height);
    [self.tableView setTableHeaderView:self.tableHeader];
}

#pragma mark - Notification

- (void)addNewCourtNotification {
    
    [self getCourtList];
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    if (notification.object != self.searchTextField) {
        return;
    }
    [self searchCourt];
}

#pragma mark - Action

- (void)showActionSheet{
    
    GBActionSheet *actionSheet = [GBActionSheet showWithTitle:LS(@"选择定位方式") button1:LS(@"卫星图定位(推荐使用)") button2:LS(@"球场四角定位") cancel:LS(@"取消")];
    actionSheet.delegate = self;
}

- (IBAction)actionSearch:(id)sender {
    
    [self.searchTextField resignFirstResponder];
}

#pragma mark - ActionSheet Delegate
- (void)GBActionSheet:(GBActionSheet *)actionSheet index:(NSInteger)index {
    
    switch (index) {
        case 0:
            [self.navigationController pushViewController:[[GBSatelliteViewController alloc]init] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[[GBFourCornerViewController alloc]init] animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark - TextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        //收起键盘
        [self.searchTextField resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - TableView Delegate
// section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.showCourtDataList.count;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.showCourtDataList[section].items.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GBFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBFieldCell"];
    CourtInfo *info = self.showCourtDataList[indexPath.section].items[indexPath.row];
    [cell setCourtName:info.courtName address:info.courtAddress];
    return cell;
    
}
// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85.f;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20.f;
}

// section的title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return self.showCourtDataList[section].name;
}

// 设置SectionHeader风格与样式
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor= [UIColor blackColor];
    header.textLabel.font = [UIFont fontWithName:header.textLabel.font.fontName size:14.f];
    [header.textLabel setTextColor:[UIColor whiteColor]];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CourtInfo *info = self.showCourtDataList[indexPath.section].items[indexPath.row];
    @weakify(self)
    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        [self showLoadingToast];
        [CourtRequest deleteDefineCourt:info.courtId handler:^(id result, NSError *error) {
            
            [self dismissToast];
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                [self getCourtList];
            }
        }];
    };
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:LS(@"删除") handler:rowActionHandler];
    return @[action2];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CourtInfo *info = self.showCourtDataList[indexPath.section].items[indexPath.row];
    GBGamePrepareViewController *vc = [[GBGamePrepareViewController alloc] initWithCourtInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - AIMTableViewIndexBarDelegate

- (void)tableViewIndexBar:(AIMTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index {
    
    if ([self.tableView numberOfSections] > index && index > -1){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

#pragma mark - DZNEmptyDataSetDelegate

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    return self.tableView.tableHeaderView.frame.size.height/2.0f;
}

#pragma mark - Private

-(void)setupUI {
    
    self.title = LS(@"选择球场");
    [self setupBackButtonWithBlock:nil];
    
    UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpBtn setSize:CGSizeMake(28, 28)];
    [tmpBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    tmpBtn.backgroundColor = [UIColor clearColor];
    [tmpBtn addTarget:self action:@selector(showActionSheet) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:tmpBtn];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
    
    self.indexBar.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"GBFieldCell" bundle:nil] forCellReuseIdentifier:@"GBFieldCell"];
    self.tableView.tableHeaderView = self.tableHeader;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor blackColor];
    self.emptyScrollView = self.tableView;
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self getCourtList];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    //mj_header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:18.0f];
    //mj_header.stateLabel.font = [UIFont systemFontOfSize:18.0f];
    self.tableView.mj_header = mj_header;
    
    self.searchTextField.delegate = self;
    
    // 加载数据
    [self.tableView.mj_header beginRefreshing];
}

- (void)analyseData {
    
    NSMutableArray *letterList = [NSMutableArray arrayWithCapacity:1];
    for (CourtResponseData *data in self.originCourtDataList) {
        [letterList addObject:data.name];
    }
    [self.indexBar setIndexes:letterList];
}

- (void)getCourtList {
    
    @weakify(self)
    [CourtRequest getCourtList:@"" handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
            [self.tableView reloadData];
        }else {
            self.originCourtDataList = result;
            [self analyseData];
            [self searchCourt];
        }
    }];
}

- (void)searchCourt {
    
    NSString *search = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([NSString stringIsNullOrEmpty:search]) {
        self.showCourtDataList = self.originCourtDataList;
    }else {
        NSMutableArray *searchList = [NSMutableArray arrayWithCapacity:1];
        for (CourtResponseData *data in self.originCourtDataList) {
            CourtResponseData *searchData = [CourtResponseData new];
            for (CourtInfo *courtInfo in data.items) {
                if ([courtInfo.courtName containsString:search] || [courtInfo.courtAddress containsString:search]) {
                    NSMutableArray *items = [NSMutableArray arrayWithArray:searchData.items];
                    [items addObject:courtInfo];
                    searchData.items = [items copy];
                    searchData.name = data.name;
                }
            }
            if (searchData.items.count>0) {
                [searchList addObject:searchData];
            }
        }
        self.showCourtDataList = [searchList copy];
    }
    self.isShowEmptyView = self.showCourtDataList.count==0;
    [self.tableView reloadData];
}

@end
