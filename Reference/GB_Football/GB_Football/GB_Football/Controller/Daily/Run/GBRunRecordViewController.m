//
//  GBRunRecordViewController.m
//  GB_Football
//
//  Created by gxd on 17/7/5.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBRunRecordViewController.h"
#import "GBMenuViewController.h"
#import "GBMapPolylineViewController.h"

#import "GBRunRecordCell.h"
#import "SyncSectionHeaderView.h"
#import "MJRefresh.h"
#import "GBBaseViewController+Empty.h"
#import "RunRecordPageRequest.h"
#import "RunRecordResponseInfo.h"

@interface GBRunRecordViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<NSString *> *keyList;
@property (nonatomic, strong) NSMutableDictionary *recordDictionary;
@property (nonatomic, strong) RunRecordPageRequest *recordPageRequest;

@end

@implementation GBRunRecordViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.keyList = [NSMutableArray arrayWithCapacity:1];
    self.recordDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    [self.tableView.mj_header beginRefreshing];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}


#pragma mark - Delegate

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.keyList == nil ? 0 : [self.keyList count];
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *valueArray = [self.recordDictionary valueForKey:self.keyList[section]];
    
    return valueArray.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GBRunRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBRunRecordCell"];
    
    NSString *key = self.keyList[indexPath.section];
    NSArray *runList = [self.recordDictionary objectForKey:key];
    RunRecordInfo *runRecordInfo = runList[indexPath.row];
    if (runRecordInfo.distance>1000) {
        cell.distanceLbl.text = [NSString stringWithFormat:@"%0.1f", runRecordInfo.distance/1000];
        cell.distanceUnitLbl.text = @"KM";
    }else {
        cell.distanceLbl.text = [NSString stringWithFormat:@"%0.1f", runRecordInfo.distance];
        cell.distanceUnitLbl.text = @"M";
    }
    
    
    NSDateFormatter *dateToStrFormatter = [[NSDateFormatter alloc] init];
    [dateToStrFormatter setDateFormat:@"HH:mm"];
    NSString *time = [dateToStrFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:runRecordInfo.startTime]];
    cell.timeLbl.text = [NSString stringWithFormat:@"%@%@", LS(@"run.record.label.time"), time];
    

    cell.durationLbl.text = runRecordInfo.consumeTimeString;
    
    cell.calorieLbl.text = [NSString stringWithFormat:@"%0.1f kcal", runRecordInfo.consume];
    
    cell.speedLbl.text = runRecordInfo.withSpeedString;
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SyncSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SyncSectionHeaderView"];
    headerView.contentView.backgroundColor = [UIColor colorWithHex:0x171717];
    headerView.titleLabel.text = self.keyList[section];
    
    return headerView;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *key = self.keyList[indexPath.section];
    NSArray *runList = [self.recordDictionary objectForKey:key];
    RunRecordInfo *runRecordInfo = runList[indexPath.row];
    [self.navigationController pushViewController:[[GBMapPolylineViewController alloc] initWithRunRecordInfo:runRecordInfo] animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![self.recordPageRequest isLoadEnd] &&
        self.keyList.count > 0 &&
        self.keyList.count-1 == indexPath.section) {
        NSMutableArray *runList = [self.recordDictionary objectForKey:self.keyList[indexPath.section]];
        if (runList.count - 1 == indexPath.row) {
            [self getNextRecordList];
        }
    }
}

#pragma mark - Action

#pragma mark - Private

-(void)setupUI
{
    self.title = LS(@"run.record.nav.tatle");
    [self setupBackButtonWithBlock:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GBRunRecordCell" bundle:nil] forCellReuseIdentifier:@"GBRunRecordCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SyncSectionHeaderView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"SyncSectionHeaderView"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.emptyScrollView = self.tableView;
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self getFirstRecordList];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_header = mj_header;
}

- (void)getFirstRecordList {
    
    @weakify(self)
    [self.recordPageRequest reloadPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
            [self.tableView reloadData];
        }else {
            NSArray<RunRecordInfo *> *runList = self.recordPageRequest.responseInfo.items;
            [self.keyList removeAllObjects];
            [self.recordDictionary removeAllObjects];
            [self mergeRunListToGroup:runList];
            self.isShowEmptyView = self.keyList.count==0;
            [self.tableView reloadData];
        }
    }];
}

- (void)getNextRecordList {
    
    @weakify(self)
    [self.recordPageRequest loadNextPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            NSArray<RunRecordInfo *> *runList = self.recordPageRequest.responseInfo.items;
            [self mergeRunListToGroup:runList];
            [self.tableView reloadData];
        }
    }];
}

- (void)mergeRunListToGroup:(NSArray<RunRecordInfo *> *)runList {
    if (runList == nil || [runList count] == 0) {
        return;
    }
    
    NSDateFormatter *dateToStrFormatter = [[NSDateFormatter alloc] init];
    NSString *dateFormatter = [NSString stringWithFormat:@"yyyy%@MM%@dd%@", LS(@"run.record.label.year"), LS(@"run.record.label.month"), LS(@"run.record.label.day")];
    [dateToStrFormatter setDateFormat:dateFormatter];
    for (RunRecordInfo *runRecordInfo in runList) {
        NSString *key = [dateToStrFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:runRecordInfo.startTime]];
        if ([self.keyList containsObject:key]) {
            NSMutableArray *runList = [self.recordDictionary objectForKey:key];
            [runList addObject:runRecordInfo];
        } else {
            [self.keyList addObject:key];
            
            NSMutableArray *runList = [NSMutableArray arrayWithCapacity:1];
            [runList addObject:runRecordInfo];
            [self.recordDictionary setObject:runList forKey:key];
            
        }
    }
}

#pragma mark - Getters & Setters

- (RunRecordPageRequest *)recordPageRequest {
    
    if (!_recordPageRequest) {
        _recordPageRequest = [[RunRecordPageRequest alloc] init];
    }
    
    return _recordPageRequest;
}

@end
