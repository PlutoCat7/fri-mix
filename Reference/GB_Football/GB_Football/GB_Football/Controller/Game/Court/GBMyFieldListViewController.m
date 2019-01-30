//
//  GBMyFieldListViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/17.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBMyFieldListViewController.h"
#import "AIMTableViewIndexBar.h"
#import "GBFieldCell.h"
#import "MJRefresh.h"
#import "CourtRequest.h"
#import "UITableViewRowAction+JZExtension.h"
#import "GBBaseViewController+Empty.h"

@interface GBMyFieldListViewController ()<
AIMTableViewIndexBarDelegate,
UITextFieldDelegate
>
// 表头视图
@property (strong, nonatomic) IBOutlet UIView *tableHeader;
// 表控件
@property (weak, nonatomic)   IBOutlet UITableView *tableView;
// 搜索输入框
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
// 索引条
@property (strong, nonatomic) IBOutlet AIMTableViewIndexBar *indexBar;

//正常显示
@property (nonatomic, strong) NSArray<CourtResponseData *>  *originCourtDataList;
@property (nonatomic, strong) NSArray<CourtResponseData *> *showCourtDataList;

@end

@implementation GBMyFieldListViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)localizeUI
{
    self.searchTextField.placeholder = LS(@"create.searchbox.name");
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewCourtNotification:) name:Notification_CreateCourtSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableHeader.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,(208.f/1334)*[UIScreen mainScreen].bounds.size.height);
    [self.tableView setTableHeaderView:self.tableHeader];
}

#pragma mark - Public

- (void)clearSearchResult {
    
    [self.searchTextField resignFirstResponder];
}

#pragma mark - Notification

- (void)addNewCourtNotification:(NSNotification *)notification {
    
    [self.navigationController popToViewController:self.parentViewController animated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_SelectedCourt object:nil userInfo:notification.userInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    if (notification.object != self.searchTextField) {
        return;
    }
    [self searchCourt];
}

#pragma mark - Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        //收起键盘
        [self.searchTextField resignFirstResponder];
        return NO;
    }
    return YES;
}

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.showCourtDataList.count;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.showCourtDataList[section].items.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GBFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBFieldCell"];
    CourtInfo *info = self.showCourtDataList[indexPath.section].items[indexPath.row];
    [cell setCourtName:info.courtName address:info.courtAddress];
    return cell;
    
}
// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.f;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 17.f;
}

// section的title
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.showCourtDataList[section].name;
}

// 设置SectionHeader风格与样式
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor= [UIColor blackColor];
    header.textLabel.font = [UIFont fontWithName:header.textLabel.font.fontName size:10.f];
    [header.textLabel setTextColor:[UIColor whiteColor]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CourtResponseData *info = self.showCourtDataList[indexPath.section];
    if (info.flag != 1) { //非最新比赛球场
        return YES;
    }else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
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
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_DeleteCourt object:nil userInfo:@{@"court_id":@(info.courtId)}];
                [self getCourtList];
            }
        }];
    };
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:LS(@"common.btn.delete") handler:rowActionHandler];
    return @[action2];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CourtInfo *info = self.showCourtDataList[indexPath.section].items[indexPath.row];
    
    NSDictionary *dic = @{@"court_id":@(info.courtId),
                          @"court_name":info.courtName};
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_SelectedCourt object:nil userInfo:dic];
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - AIMTableViewIndexBarDelegate

- (void)tableViewIndexBar:(AIMTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index
{
    if ([self.tableView numberOfSections] > index && index > -1){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

#pragma mark - Action
- (IBAction)actionSearch:(id)sender {
    
    [self.searchTextField resignFirstResponder];
}

#pragma mark - Private

-(void)setupUI
{
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
    self.tableView.mj_header = mj_header;
    
    self.searchTextField.delegate = self;
}

- (void)initPageData {
    [self.tableView.mj_header beginRefreshing];
}

- (void)analyseData {
    
    //过滤多个#问题
    NSMutableArray *list = [NSMutableArray arrayWithArray:self.originCourtDataList];
    NSMutableArray<CourtInfo *> *needMergeList = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *deleteList = [NSMutableArray arrayWithCapacity:1];
    for (CourtResponseData *data in list) {
        if ([data.name isEqualToString:@"#"]) {
            [needMergeList addObjectsFromArray:data.items];
            [deleteList addObject:data];
        }
    }
    [list removeObjectsInArray:deleteList];
    
    if (needMergeList.count > 0) {
        CourtResponseData *data = [[CourtResponseData alloc] init];
        data.name = @"#";
        data.items = [needMergeList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            CourtInfo *courtInfo1 = obj1;
            CourtInfo *courtInfo2 = obj2;
            NSString *firstLetter = [courtInfo1.courtName substringWithRange:NSMakeRange(0, 1)];
            NSString *secondLetter = [courtInfo2.courtName substringWithRange:NSMakeRange(0, 1)];
            return [firstLetter compare:secondLetter];
        }];
        [list addObject:data];
        self.originCourtDataList = [list copy];
    }
    
    
    NSMutableArray *letterList = [NSMutableArray arrayWithCapacity:1];
    for (CourtResponseData *data in self.originCourtDataList) {
        [letterList addObject:data.name];
    }
    [self.indexBar setIndexes:letterList];
}

- (void)getCourtList {

    @weakify(self)
    [CourtRequest getCourtList:@"" type:CourtType_Define cityName:@"" handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
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
