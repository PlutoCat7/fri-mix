//
//  PosterViewController.m
//  TiHouse
//
//  Created by weilai on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PosterViewController.h"
#import "SingleArticleViewController.h"

#import "PosterSingleViewCell.h"
#import "PosterMultTableViewCell.h"
#import "ODRefreshControl.h"
#import <UIScrollView+EmptyDataSet.h>

#import "PosterPageRequest.h"
#import "NSDate+Utilities.h"

@interface PosterViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ODRefreshControl *refreshControl;
@property (nonatomic, strong) PosterPageRequest *recordPageRequest;

@property (nonatomic, strong) NSArray<NSString *> *dateList;
@property (nonatomic, strong) NSArray <GroupKnowModeInfo *> *recordList;

@property (nonatomic, assign) BOOL isShowEmptyView;

@end

@implementation PosterViewController

- (void)setupUI {
    
    self.title = @"有数小报";
    [self setupTableView];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PosterSingleViewCell" bundle:nil] forCellReuseIdentifier:@"PosterSingleViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PosterMultTableViewCell" bundle:nil] forCellReuseIdentifier:@"PosterMultTableViewCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
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
    
    @weakify(self)
    [self.recordPageRequest reloadPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        [self.refreshControl endRefreshing];
        
        if (error) {
            [NSObject showHudTipStr:error.domain];
        }else {
            [self compareRecordList:self.recordPageRequest.responseInfo.items];
            
//            if (self.recordList.count > 0) {
//                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.recordList.count-1) inSection: 0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//            }
            
        }
        
        self.isShowEmptyView = self.recordList.count == 0 ? YES : NO;
        [self.tableView reloadData];
    }];
}

- (void)getNextRecordList {
    
    @weakify(self)
    [self.recordPageRequest loadNextPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        if (error) {
            [NSObject showHudTipStr:error.domain];
        }else {
            [self compareRecordList:self.recordPageRequest.responseInfo.items];
            [self.tableView reloadData];
//            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.recordList.count-self.lastCount inSection: 0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }];
}

- (void)compareRecordList:(NSArray<GroupKnowModeInfo *> *)recordList {
    
    NSMutableArray *keyList = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *value = [NSMutableArray arrayWithArray:recordList];
    for (int i = (int) value.count - 1; i>= 0; i--) {
        if (recordList[i].listModelKnow.count == 0) {
            [value removeObjectAtIndex:i];
        }
    }
    
    for (GroupKnowModeInfo *knowModeInfo in value) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:(knowModeInfo.groupctime/1000)];

        NSString *key = @"";
        if ([date isToday]) {
            key = @"今天";
        } else if ([date isYesterday]) {
            key = @"昨天";
        } else {
            key = [NSString stringWithFormat:@"%02d-%02d", (int)date.month, (int)date.day];
        }
        
        [keyList addObject:key];
    }
    
    self.dateList = [keyList copy];
    self.recordList = [value copy];
}

#pragma mark - Getters & Setters

- (PosterPageRequest *)recordPageRequest {
    
    if (!_recordPageRequest) {
        _recordPageRequest = [[PosterPageRequest alloc] init];
        
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

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dateList == nil ? 0 : self.dateList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = nil;
    
    NSArray <KnowModeInfo *> *knowList = self.recordList[indexPath.row].listModelKnow;
    if (knowList.count == 1) {
        PosterSingleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PosterSingleViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        [cell refreshWithKnowModeInfo:knowList[0] date:self.dateList[indexPath.row]];
        WEAKSELF
        cell.clickItemBlock = ^(KnowModeInfo *knowModeInfo) {
            [weakSelf clickItem:knowModeInfo];
        };
        
        tableViewCell = cell;
        
    } else {
        PosterMultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PosterMultTableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        [cell refreshWithArray:knowList date:self.dateList[indexPath.row]];
        WEAKSELF
        cell.clickItemBlock = ^(KnowModeInfo *knowModeInfo) {
            [weakSelf clickItem:knowModeInfo];
        };
        
        tableViewCell = cell;
    }
    
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray <KnowModeInfo *> *knowList = self.recordList[indexPath.row].listModelKnow;
    if (knowList.count == 1) {
        return [PosterSingleViewCell calculateHeight:knowList[0].knowtitlesub];
    }
    return [PosterMultTableViewCell calculateHeight:knowList.count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.recordPageRequest isLoadEnd] && self.recordList.count - 1 == indexPath.row) {
        [self getNextRecordList];
    }
}

- (void)clickItem:(KnowModeInfo *)knowModeInfo {
    SingleArticleViewController *viewController = [[SingleArticleViewController alloc] initWithKnowModeInfo:knowModeInfo];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
