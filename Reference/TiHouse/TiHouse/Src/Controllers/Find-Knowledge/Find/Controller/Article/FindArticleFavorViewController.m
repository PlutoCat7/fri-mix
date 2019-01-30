//
//  FindArticleFavorViewController.m
//  TiHouse
//
//  Created by weilai on 2018/2/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindArticleFavorViewController.h"
#import "FindArticleDetailViewController.h"
#import "ArticleFavorViewCell.h"

#import "ODRefreshControl.h"
#import "AssemarcFavorListRequest.h"
#import "NotificationConstants.h"
#import "AssemarcRequest.h"

@interface FindArticleFavorViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ODRefreshControl *refreshControl;
@property (nonatomic, strong) AssemarcFavorListRequest *recordPageRequest;

@property (nonatomic, strong) NSArray<FindAssemarcInfo *> *recordList;
@end

@implementation FindArticleFavorViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationFavor:) name:Notification_User_Collection object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)notificationFavor:(NSNotification *)notification {
    FindAssemarcInfo *findAssemarcInfo =  notification.object;
    
    if (findAssemarcInfo.assemarciscoll) {
        NSMutableArray *newList = [NSMutableArray arrayWithArray:self.recordList];
        [newList addObject:findAssemarcInfo];
        
        self.recordList = newList;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithArray:self.recordList];
        if ([newList containsObject:findAssemarcInfo]) {
            [newList removeObject:findAssemarcInfo];
        }
        self.recordList = newList;
    }
    
    [self.tableView reloadData];
}

#pragma mark - private

- (void)setupUI {
    
    self.title = @"我收藏的文章";
    [self setupTableView];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleFavorViewCell" bundle:nil] forCellReuseIdentifier:@"ArticleFavorViewCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
            [self.tableView reloadData];
        }else {
            self.recordList = self.recordPageRequest.responseInfo.items;
            [self.tableView reloadData];
            
        }
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

#pragma mark - Getters & Setters

- (AssemarcFavorListRequest *)recordPageRequest {
    
    if (!_recordPageRequest) {
        _recordPageRequest = [[AssemarcFavorListRequest alloc] init];
        
    }
    
    return _recordPageRequest;
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
    
    FindAssemarcInfo *info = self.recordList[indexPath.row];
    
    ArticleFavorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleFavorViewCell"];
    cell.backgroundColor = [UIColor whiteColor];
    [cell refreshWithInfo:info];
    WEAKSELF
    cell.clickFavorBlock = ^(FindAssemarcInfo *info) {
        [weakSelf clickFavorItem:info];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FindAssemarcInfo *info = self.recordList[indexPath.row];
    
    return [ArticleFavorViewCell defaultHeight:info.assemtitle];
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
    
    if (![self.recordPageRequest isLoadEnd] && self.recordList.count - 1 == indexPath.row) {
        [self getNextRecordList];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FindAssemarcInfo *info = self.recordList[indexPath.row];
    
    FindArticleDetailViewController *vc = [[FindArticleDetailViewController alloc] initWithAssemarcInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickFavorItem:(FindAssemarcInfo *)info {
    WEAKSELF
    [AssemarcRequest removeAssemarcFavor:info.assemarcid handler:^(id result, NSError *error) {
        if (!error) {
            NSMutableArray *newList = [NSMutableArray arrayWithArray:weakSelf.recordList];
            if ([newList containsObject:info]) {
                [newList removeObject:info];
                
                weakSelf.recordList = newList;
                [weakSelf.tableView reloadData];
            }
        }
    }];
    
    
}

@end
