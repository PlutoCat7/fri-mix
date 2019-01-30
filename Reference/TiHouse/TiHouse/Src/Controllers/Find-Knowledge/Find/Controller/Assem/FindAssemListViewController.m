//
//  FindAssemListViewController.m
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindAssemListViewController.h"
#import "AssemDetailContainerViewController.h"
#import "FindAssemCell.h"
#import "AssemCellModel.h"

#import "MJRefresh.h"
#import "AssemActivityListRequest.h"

@interface FindAssemListViewController () <
FindAssemCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<AssemCellModel *> *dataList;
@property (nonatomic, strong) AssemActivityListRequest *pageRequest;

@end

@implementation FindAssemListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageRequest = [[AssemActivityListRequest alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = @"全部征集";
    
    [self setupTableView];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FindAssemCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FindAssemCell class])];
    self.tableView.rowHeight = kFindAssemCellHeight;
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.pageRequest reloadPageWithHandle:^(id result, NSError *error) {
            [self.tableView.mj_header endRefreshing];
            if (!error) {
                [self parseNetworkData:self.pageRequest.responseInfo.items];
                [self.tableView reloadData];
            }
        }];
    }];
    self.tableView.mj_header = mj_header;
}

- (void)parseNetworkData:(NSArray<FindAssemActivityInfo *> *)list {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    for (FindAssemActivityInfo *info in list) {
        AssemCellModel *cellModel = nil;
        for (AssemCellModel *hasCellModel in self.dataList) {
            if (hasCellModel.assemid == info.assemid) {
                cellModel = hasCellModel;
                break;
            }
        }
        if (!cellModel) {
            cellModel = [[AssemCellModel alloc] init];
            cellModel.assemid = info.assemid;
            cellModel.assemtitle = info.assemtitle;
            cellModel.assemurlindex = info.assemurlindex;
            cellModel.assemstatus = info.status;
            cellModel.totalUserCount = info.numjoin;
            cellModel.userList = info.userJA;
        }
        [result addObject:cellModel];
    }
    self.dataList = [result copy];
}

#pragma mark - FindAssemCellDelegate

- (void)findAssemCellDidSelected:(FindAssemCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FindAssemActivityInfo *info = self.pageRequest.responseInfo.items[indexPath.row];
    AssemDetailContainerViewController *vc = [[AssemDetailContainerViewController alloc] initWithAssemInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindAssemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FindAssemCell class])];
    cell.delegate = self;
    [cell refreshWithInfo:_dataList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![self.pageRequest isLoadEnd] &&
        self.dataList.count-1 == indexPath.row) {
        [self.pageRequest loadNextPageWithHandle:^(id result, NSError *error) {
            if (!error) {
                [self parseNetworkData:self.pageRequest.responseInfo.items];
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FindAssemActivityInfo *info = self.pageRequest.responseInfo.items[indexPath.row];
    AssemDetailContainerViewController *vc = [[AssemDetailContainerViewController alloc] initWithAssemInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
