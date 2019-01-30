//
//  GBMemberListViewController.m
//  GB_Team
//
//  Created by Pizza on 16/9/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBMemberListViewController.h"
#import "GBHomePageViewController.h"
#import "GBMemberCell.h"
#import "GBAddMemberCell.h"
#import "GBCreatePlayerViewController.h"
#import "UIAlertView+Block.h"
#import "GBMemberCardViewController.h"
#import "GBAlertView.h"
#import "MJRefresh.h"

#import "PlayerRequest.h"
#import "PlayerListPageRequest.h"


@interface GBMemberListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
// 管理按钮
@property (nonatomic, strong) UIButton *editButton;
// 集合视图
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
// 管理状态
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) NSMutableArray<PlayerInfo *> *showDataList;

@property (nonatomic, strong) PlayerListPageRequest *playerPageRequest;

@end

@implementation GBMemberListViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPlayerNotification:) name:Notification_CreatePlayerSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editPlayerNotification:) name:Notification_EditPlayerSuccess object:nil];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBHomePageViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

#pragma mark - Action
// 点击了管理按钮
- (void)actionEditPress {
    
    if (self.isEdit == NO) {
        [self.editButton setTitle:LS(@"完成") forState:UIControlStateNormal];
        [self.editButton setTitle:LS(@"完成") forState:UIControlStateHighlighted];
        self.isEdit = YES;
        @weakify(self)
        [self.collectionView performBatchUpdates:^{
            
            @strongify(self)
            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
        } completion:^(BOOL finished){
            @strongify(self)
            [self.collectionView reloadData];
        }];
    } else {
        [self.editButton setTitle:LS(@"管理") forState:UIControlStateNormal];
        [self.editButton setTitle:LS(@"管理") forState:UIControlStateHighlighted];
        self.isEdit = NO;
        @weakify(self)
        [self.collectionView performBatchUpdates:^{
            
            @strongify(self)
            [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
        } completion:^(BOOL finished){
            @strongify(self)
            [self.collectionView reloadData];
        }];
    }
}

- (void)deletePlayerByIndex:(NSInteger)index {
    
    PlayerInfo *playerInfo = self.showDataList[index];
    @weakify(self)
    [PlayerRequest deletePlayer:playerInfo.playerId handler:^(id result, NSError *error) {
        
        @strongify(self)
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [self.showDataList removeObjectAtIndex:index];
            self.isShowEmptyView = self.showDataList.count==0;
            [self.collectionView performBatchUpdates:^{
                
                [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
            } completion:^(BOOL finished){
                [self.collectionView reloadData];
            }];
        }
    }];
    
}

#pragma mark - Notification

- (void)addPlayerNotification:(NSNotification *)notification {
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)editPlayerNotification:(NSNotification *)notification {
    
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = LS(@"球员库");
    [self setupBackButtonWithBlock:nil];
    [self setupRightButton];
    [self setupCollectionView];
}

- (void)setupRightButton {
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editButton setSize:CGSizeMake(48,44)];
    [self.editButton.titleLabel setFont:[UIFont systemFontOfSize:20.f]];
    [self.editButton setTitle:LS(@"管理") forState:UIControlStateNormal];
    [self.editButton setTitle:LS(@"管理") forState:UIControlStateHighlighted];
    [self.editButton setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
    self.editButton.backgroundColor = [UIColor clearColor];
    [self.editButton addTarget:self action:@selector(actionEditPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)setupCollectionView {
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GBMemberCell" bundle:nil] forCellWithReuseIdentifier:@"GBMemberCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GBAddMemberCell" bundle:nil] forCellWithReuseIdentifier:@"GBAddMemberCell"];
    self.emptyScrollView = self.collectionView;
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        @strongify(self)
        [self getFirstRecordList];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.collectionView.mj_header = mj_header;
}

- (void)getFirstRecordList {
    
    @weakify(self)
    [self.playerPageRequest reloadPageWithHandle:^(id result, NSError *error) {
        
        @strongify(self)
        [self.collectionView.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
            [self.collectionView reloadData];
        }else {
            self.showDataList = [NSMutableArray arrayWithArray:self.playerPageRequest.responseInfo.items];
            self.isShowEmptyView = self.showDataList.count==0;
            [self.collectionView reloadData];
        }
    }];
}

- (void)getNextRecordList {
    
    @weakify(self)
    [self.playerPageRequest loadNextPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            self.showDataList = [NSMutableArray arrayWithArray:self.playerPageRequest.responseInfo.items];
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger count = self.showDataList ? self.showDataList.count : 0;
    count += self.isEdit == NO ? 1 : 0;
    
    return count;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 管理模式
    if (self.isEdit == YES) {
        GBMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GBMemberCell" forIndexPath:indexPath];
        [cell setSelectState:STATE_DELETE];
        cell.rightButton.tag = indexPath.row;
        [cell.rightButton addTarget:self action:@selector(deleteItem:) forControlEvents:UIControlEventTouchUpInside];
        
        PlayerInfo *playerInfo = self.showDataList[indexPath.row];
        [cell refreshWithPlayer:playerInfo];
        
        return cell;
    }else {
        if (indexPath.item == 0) {
            GBAddMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GBAddMemberCell" forIndexPath:indexPath];
            cell.titleLabel.text = LS(@"创建新球员");
            return cell;
            
        }else {
            GBMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GBMemberCell" forIndexPath:indexPath];
            [cell setSelectState:STATE_NOMAL];
            cell.rightButton.tag = 0;
            
            PlayerInfo *playerInfo = self.showDataList[indexPath.row - 1];
            [cell refreshWithPlayer:playerInfo];
            
            return cell;
        }
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 管理模式
    if (!self.isEdit) {
        if (indexPath.item == 0) {
            [self.navigationController pushViewController:[[GBCreatePlayerViewController alloc] init] animated:YES];
        }else{
            PlayerInfo *playerInfo = self.showDataList[indexPath.row - 1];
            [self.navigationController pushViewController:[[GBMemberCardViewController alloc]initWithPlayerInfo:playerInfo] animated:YES];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.playerPageRequest isLoadEnd] &&
        self.showDataList.count-1 == indexPath.row) {
        [self getNextRecordList];
    }
}

// 删除item
- (void)deleteItem:(UIButton*)sender {
    
    UIButton *button = sender;
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self deletePlayerByIndex:button.tag];
        }
    } title:LS(@"温馨提示") message:LS(@"确认删除该球员吗？") cancelButtonName:LS(@"取消") otherButtonTitle:LS(@"确定")];
}

#pragma mark Getter and Setter

- (PlayerListPageRequest *)playerPageRequest {
    
    if (!_playerPageRequest) {
        _playerPageRequest = [[PlayerListPageRequest alloc] init];
    }
    
    return _playerPageRequest;
}

@end
