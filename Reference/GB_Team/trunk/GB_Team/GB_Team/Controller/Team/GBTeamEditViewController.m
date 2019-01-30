//
//  GBTeamEditViewController.m
//  GB_Team
//
//  Created by Pizza on 16/9/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBTeamEditViewController.h"
#import "GBHomePageViewController.h"
#import "GBMemberCell.h"
#import "MJRefresh.h"

#import "TeamRequest.h"
#import "TeamNotAddPlayerPageRequest.h"

@interface GBTeamEditViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
// 保存按钮
@property (nonatomic, strong) UIButton *saveButton;
// 集合视图
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
// 未添加的球员
@property (nonatomic, strong) NSMutableArray<TeamAddPlayerInfo *> *notAddPlayerList;
// 原始数据
@property (nonatomic, assign) NSInteger teamId;
@property (nonatomic, strong) TeamNotAddPlayerPageRequest *playerPageRequest;

@end

@implementation GBTeamEditViewController

- (instancetype)initWithPlayerList:(NSInteger)teamId {
    
    if(self=[super init]){
        _teamId = teamId;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - Action

// 点击了保存按钮
- (void)actionSavePress {
    
    NSMutableArray<NSNumber *> *playerIds = [NSMutableArray array];
    for (TeamAddPlayerInfo *info in self.notAddPlayerList) {
        if (info.isSelect) {
            [playerIds addObject:@(info.playerId)];
        }
    }
    
    [self showLoadingToast];
    @weakify(self)
    [TeamRequest addPlayerToTeam:self.teamId playerList:playerIds handler:^(id result, NSError *error) {
        @strongify(self)
        
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_EditTeamSuccess object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

#pragma mark - Private

-(void)setupUI {
    
    self.title = LS(@"添加球员");
    [self setupBackButtonWithBlock:nil];
    [self setupRightButton];
    [self setupCollectionView];
}

- (void)setupRightButton {
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setSize:CGSizeMake(48,44)];
    [self.saveButton.titleLabel setFont:[UIFont systemFontOfSize:20.f]];
    [self.saveButton setTitle:LS(@"保存") forState:UIControlStateNormal];
    [self.saveButton setTitle:LS(@"保存") forState:UIControlStateHighlighted];
    [self.saveButton setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[ColorManager disableColor] forState:UIControlStateDisabled];
    self.saveButton.backgroundColor = [UIColor clearColor];
    [self.saveButton addTarget:self action:@selector(actionSavePress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    [self.navigationItem setRightBarButtonItem:rightButton];
    self.saveButton.enabled = NO;
}

- (void)setupCollectionView {
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GBMemberCell" bundle:nil] forCellWithReuseIdentifier:@"GBMemberCell"];
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
            self.notAddPlayerList = [NSMutableArray arrayWithArray:self.playerPageRequest.responseInfo.items];
            self.isShowEmptyView = self.notAddPlayerList.count==0;
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
            self.notAddPlayerList = [NSMutableArray arrayWithArray:self.playerPageRequest.responseInfo.items];
            [self.collectionView reloadData];
        }
    }];
}

- (void)checkInputValid {
    
    BOOL isCanSave = NO;
    for (TeamAddPlayerInfo *info in self.notAddPlayerList) {
        if (info.isSelect) {
            isCanSave = YES;
            break;
        }
    }
    self.saveButton.enabled = isCanSave;
}

#pragma mark - Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.notAddPlayerList.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GBMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GBMemberCell" forIndexPath:indexPath];
    
    TeamAddPlayerInfo *playerInfo = self.notAddPlayerList[indexPath.item];
    [cell refreshWithPlayer:playerInfo];
    cell.selectState = playerInfo.isSelect?STATE_SELECTED:STATE_UNSELECT;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TeamAddPlayerInfo *playerInfo = self.notAddPlayerList[indexPath.item];
    playerInfo.isSelect = !playerInfo.isSelect;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    [self checkInputValid];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.playerPageRequest isLoadEnd] &&
        self.notAddPlayerList.count-1 == indexPath.row) {
        [self getNextRecordList];
    }
}

#pragma mark - Setter and Getter

- (TeamNotAddPlayerPageRequest *)playerPageRequest {
    
    if (!_playerPageRequest) {
        _playerPageRequest = [TeamNotAddPlayerPageRequest new];
        _playerPageRequest.teamId = self.teamId;
    }
    
    return _playerPageRequest;
}

@end
