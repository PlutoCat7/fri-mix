//
//  GBTeamMemberViewController.m
//  GB_Team
//
//  Created by Pizza on 16/9/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBTeamMemberViewController.h"
#import "GBMemberCell.h"
#import "GBAddMemberCell.h"
#import "UIAlertView+Block.h"
#import "GBTeamEditViewController.h"
#import "GBAlertView.h"
#import "MJRefresh.h"

#import "TeamRequest.h"

@interface GBTeamMemberViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
// 编辑按钮
@property (nonatomic, strong) UIButton *editButton;
// 集合视图
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
// 编辑状态
@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, assign) NSInteger teamId;
//正常显示
@property (nonatomic, strong) NSMutableArray<PlayerInfo *> *showDataList;

@end

@implementation GBTeamMemberViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithTeamId:(NSInteger)teamId {
    
    if (self = [super init]) {
        _teamId = teamId;
    }
    return self;
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.collectionView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupRefreshView:) name:Notification_EditTeamSuccess object:nil];
}

#pragma mark - Notification

- (void)setupRefreshView:(NSNotification *)notification {
    
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - Action

// 点击了编辑按钮
- (void)actionEditPress {
    
    if (self.isEdit == NO) {
        [self.editButton setTitle:LS(@"完成") forState:UIControlStateNormal];
        [self.editButton setTitle:LS(@"完成") forState:UIControlStateHighlighted];
        self.isEdit = YES;
        [self.collectionView performBatchUpdates:^{
            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
        } completion:^(BOOL finished){
            [self.collectionView reloadData];
        }];
    }else {
        [self.editButton setTitle:LS(@"管理") forState:UIControlStateNormal];
        [self.editButton setTitle:LS(@"管理") forState:UIControlStateHighlighted];
        self.isEdit = NO;
        [self.collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
        } completion:^(BOOL finished){
            [self.collectionView reloadData];
        }];
    }
}

// 删除item
-(void)deleteItem:(UIButton*)sender {
    
    UIButton *button = sender;
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            PlayerInfo *playerInfo = self.showDataList[button.tag];
            [self showLoadingToast];
            @weakify(self)
            [TeamRequest deletePlayerFromTeam:self.teamId playerId:playerInfo.playerId handler:^(id result, NSError *error) {
                
                @strongify(self)
                [self dismissToast];
                if (error) {
                    [self showToastWithText:error.domain];
                }else {
                    [self.showDataList removeObject:playerInfo];
                    self.isShowEmptyView = self.showDataList.count==0;
                    [self.collectionView performBatchUpdates:^{
                        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:button.tag inSection:0]]];
                    } completion:^(BOOL finished){
                        [self.collectionView reloadData];
                    }];
                }
            }];
        }
    } title:LS(@"温馨提示") message:LS(@"确认删除该球员吗？") cancelButtonName:LS(@"取消") otherButtonTitle:LS(@"确定")];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = LS(@"球队成员");
    [self setupRightButton];
    [self setupBackButtonWithBlock:nil];
    [self setupCollectionView];
}

- (void)setupCollectionView {
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GBMemberCell" bundle:nil] forCellWithReuseIdentifier:@"GBMemberCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GBAddMemberCell" bundle:nil] forCellWithReuseIdentifier:@"GBAddMemberCell"];
    self.emptyScrollView = self.collectionView;
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self getMemberdList];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.collectionView.mj_header = mj_header;
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

- (void)getMemberdList {
    
    @weakify(self)
    [TeamRequest getTeamMemberWithTeamId:self.teamId handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self.collectionView.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
            [self.collectionView reloadData];
        }else {
            self.showDataList = [NSMutableArray arrayWithArray:result];
            self.isShowEmptyView = self.showDataList.count==0;
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
    
    // 编辑模式
    if (self.isEdit == YES) {
        GBMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GBMemberCell" forIndexPath:indexPath];
        [cell setSelectState:STATE_DELETE];
        cell.rightButton.tag = indexPath.row;
        [cell.rightButton addTarget:self action:@selector(deleteItem:) forControlEvents:UIControlEventTouchUpInside];
        
        PlayerInfo *playerInfo = self.showDataList[indexPath.row];
        [cell refreshWithPlayer:playerInfo];
        
        return cell;
    }else { // 正常模式
        if (indexPath.item == 0) {
            GBAddMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GBAddMemberCell" forIndexPath:indexPath];
            cell.titleLabel.text = LS(@"添加球员");
            return cell;
            
        } else {
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
    
    // 正常模式
    if (!self.isEdit) {
        if (indexPath.item == 0) { //添加球员
            [self.navigationController pushViewController:[[GBTeamEditViewController alloc]initWithPlayerList:self.teamId] animated:YES];
        }
    }
}

@end
