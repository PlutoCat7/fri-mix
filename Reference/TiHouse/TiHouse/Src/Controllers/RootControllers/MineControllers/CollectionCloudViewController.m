//
//  CollectionCloudViewController.m
//  TiHouse
//
//  Created by admin on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CollectionCloudViewController.h"
#import "CommonTableViewCell.h"
#import "CollectionCloudTableViewCell.h"
#import "CloudRecordCollectVC.h"
#import "Login.h"
#import "CollectionCloud.h"

@interface CollectionCloudViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *collectionClouds;
@end

@implementation CollectionCloudViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏-云记录";
    
    [self tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self getCollectionClouds];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_collectionClouds count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    CollectionCloudTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[CollectionCloudTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.collectionCloud = [CollectionCloud mj_objectWithKeyValues:_collectionClouds[indexPath.row]];
    }
    cell.topLineStyle = CellLineStyleFill;
    cell.bottomLineStyle = CellLineStyleFill;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kRKBHEIGHT(50);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CloudRecordCollectVC *crcVC = [CloudRecordCollectVC new];
    crcVC.type = 4;
    CollectionCloud *cc = [CollectionCloud mj_objectWithKeyValues:_collectionClouds[indexPath.row]];
    crcVC.houseID = cc.houseid;
    crcVC.titleName = cc.name;
    [self.navigationController pushViewController:crcVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - getters and setters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0));
        }];
    }
    return _tableView;
}

-(void)getCollectionClouds {
    User *user = [Login curLoginUser];
    WEAKSELF
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/collectioncloud/listByUid" withParams:@{@"uid":[NSString stringWithFormat:@"%ld", user.uid]} withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            _collectionClouds = data[@"data"];
             [weakSelf.tableView reloadData];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

