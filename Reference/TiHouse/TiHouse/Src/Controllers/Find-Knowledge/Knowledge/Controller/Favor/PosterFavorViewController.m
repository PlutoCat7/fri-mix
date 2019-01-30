//
//  PosterFavorViewController.m
//  TiHouse
//
//  Created by weilai on 2018/2/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PosterFavorViewController.h"
#import "SingleArticleViewController.h"
#import "PosterFavorTableViewCell.h"
#import <UIScrollView+EmptyDataSet.h>

#import "ODRefreshControl.h"
#import "PosterFavorPageRequest.h"
#import "NotificationConstants.h"

@interface PosterFavorViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ODRefreshControl *refreshControl;
@property (nonatomic, strong) PosterFavorPageRequest *recordPageRequest;

@property (nonatomic, strong) NSMutableArray<KnowModeInfo *> *recordList;

@property (nonatomic, assign) BOOL isShowEmptyView;

@end

@implementation PosterFavorViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(favorSuccess:) name:Notification_Favor_KnowSucc object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unfavorSuccess:) name:Notification_UnFavor_KnowSucc object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Notification

- (void)favorSuccess:(NSNotification *)notification {
    KnowModeInfo *knowModeInfo =  notification.object;
    
    NSMutableArray *newList = [NSMutableArray arrayWithArray:self.recordList];
    if (![newList containsObject:knowModeInfo]) {
        [newList addObject:knowModeInfo];
    }
    
    [self.tableView reloadData];
}

- (void)unfavorSuccess:(NSNotification *)notification {
    KnowModeInfo *knowModeInfo =  notification.object;
    
    NSMutableArray *newList = [NSMutableArray arrayWithArray:self.recordList];
    if ([newList containsObject:knowModeInfo]) {
        [newList removeObject:knowModeInfo];
    }
    
    [self.tableView reloadData];
}

#pragma mark - private

- (void)setupUI {
    
    self.title = @"我收藏的有数小报";
    [self setupTableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PosterFavorTableViewCell" bundle:nil] forCellReuseIdentifier:@"PosterFavorTableViewCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:_tableView];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

- (void)loadNetworkData {
    [self getFirstRecordList];
}

- (void)refresh {
    [self getFirstRecordList];
}

- (void)getFirstRecordList {
    
//    @weakify(self)
//    [self.recordPageRequest reloadPageWithHandle:^(id result, NSError *error) {
//        @strongify(self)
//        [self.refreshControl endRefreshing];
//
//        if (error) {
//            [NSObject showHudTipStr:error.domain];
//        }else {
//            self.recordList = self.recordPageRequest.responseInfo.items;
//
//        }
//
//        self.isShowEmptyView = self.recordList.count == 0 ? YES : NO;
//        [self.tableView reloadData];
//    }];
    
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_myCollectedPostWithIndex:0 completedUsing:^(id data, NSError *error) {
        [weakSelf.refreshControl endRefreshing];
        
        if (error) {
            [NSObject showHudTipStr:error.domain];
        }else {
            [self.recordList removeAllObjects];
            [self.recordList addObjectsFromArray:data];
        }
        
        self.isShowEmptyView = self.recordList.count == 0 ? YES : NO;
        [self.tableView reloadData];
    }];
}

- (void)getNextRecordList {
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_myCollectedPostWithIndex:self.recordList.count completedUsing:^(id data, NSError *error) {
        if (error) {
            [NSObject showHudTipStr:error.domain];
        }else {
            [self.recordList addObjectsFromArray:data];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Getters & Setters

- (PosterFavorPageRequest *)recordPageRequest {
    
    if (!_recordPageRequest) {
        _recordPageRequest = [[PosterFavorPageRequest alloc] init];
        
    }
    
    return _recordPageRequest;
}

#pragma mark - DZNEmptyDataSetSource

///是否显示没有数据界面
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    
    return self.isShowEmptyView;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"暂无相关内容";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:RGB(191, 191, 191),
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - table delegate

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.recordList == nil ? 0 : self.recordList.count;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KnowModeInfo *knowModeInfo = self.recordList[indexPath.section];
    
    PosterFavorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PosterFavorTableViewCell"];
    cell.backgroundColor = [UIColor whiteColor];
    [cell refreshWithKnowModeInfo:knowModeInfo];
        WEAKSELF
        cell.clickItemBlock = ^(KnowModeInfo *knowModeInfo) {
            [weakSelf clickItem:knowModeInfo];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return kRKBHEIGHT(75);
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kRKBHEIGHT(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
   
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.recordPageRequest isLoadEnd] && self.recordList.count - 1 == indexPath.section) {
        [self getNextRecordList];
    }
}

- (NSMutableArray<KnowModeInfo *> *)recordList
{
    if (!_recordList)
    {
        _recordList = [NSMutableArray array];
    }
    return _recordList;
}

- (void)clickItem:(KnowModeInfo *)knowModeInfo {
    SingleArticleViewController *viewController = [[SingleArticleViewController alloc] initWithKnowModeInfo:knowModeInfo];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
