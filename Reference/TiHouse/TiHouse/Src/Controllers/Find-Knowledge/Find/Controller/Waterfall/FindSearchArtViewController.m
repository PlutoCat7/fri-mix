//
//  FindSearchArtViewController.m
//  TiHouse
//
//  Created by weilai on 2018/4/16.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindSearchArtViewController.h"
#import "FindArticleDetailViewController.h"
#import "UIViewController+YHToast.h"
#import <UIScrollView+EmptyDataSet.h>

#import "FindArtTableViewCell.h"
#import "AssemArcSearchListRequest.h"

@interface FindSearchArtViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) AssemArcSearchListRequest *recordPageRequest;
@property (nonatomic, strong) NSArray *recordList;

@property (nonatomic, assign) BOOL isShowEmptyView;

@end

@implementation FindSearchArtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Private

-(void)setupUI
{
    [self setupTableView];
    
    
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FindArtTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindArtTableViewCell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self refresh];
    }];
    self.tableView.mj_header = mj_header;

}

#pragma mark - Getters & Setters

- (AssemArcSearchListRequest *)recordPageRequest {
    
    if (!_recordPageRequest) {
        _recordPageRequest = [[AssemArcSearchListRequest alloc] init];
    }
    return _recordPageRequest;
}

- (void)loadNetworkData {
//    [self getFirstRecordList];
}

- (void)refresh {
    [self getFirstRecordList];
}

- (void)getFirstRecordList {
    @weakify(self)
    [self.recordPageRequest reloadPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        [self dismissToast];
        
        if (error) {
            [NSObject showHudTipStr:error.domain];
        }else {
            self.recordList = self.recordPageRequest.responseInfo.items;
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
            self.recordList = self.recordPageRequest.responseInfo.items;
            [self.tableView reloadData];
        }
    }];
}

- (void)reSearchWithName:(NSString *)name {
    
    self.recordPageRequest.searchText = name;
    //调用搜索接口
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - DZNEmptyDataSetSource

///是否显示没有数据界面
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    
    return self.isShowEmptyView;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"没有找到相关内容，换个词试试吧";
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

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"search_e.png"];
}

#pragma mark UITableViewDelegate

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordList == nil ? 0 : self.recordList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kRKBHEIGHT(80.f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FindArtTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindArtTableViewCell"];
    cell.backgroundColor = [UIColor clearColor];
    [cell refreshWithModel:self.recordList[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FindAssemarcInfo *info = self.recordList[indexPath.row];
    
    FindArticleDetailViewController *vc = [[FindArticleDetailViewController alloc] initWithAssemarcInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
