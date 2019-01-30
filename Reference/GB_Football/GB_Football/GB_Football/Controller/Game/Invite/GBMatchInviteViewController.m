//
//  GBMatchInviteViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBMatchInviteViewController.h"
#import "GBFriendSelectViewController.h"
#import "GBNavigationController.h"
#import "GBTeamMatchInviteViewController.h"

#import "GBMatchInviteFriendCollectionCell.h"
#import "GBMatchInviteNotAcceptFriendCollectionCell.h"
#import "GBMatchInviteCollectionSectionView.h"
#import "GBMatchInviteCollectionFooterView.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

#import "MatchRequest.h"

#define kItemWith 70
#define kItemNormalHeiht 90   //已接收邀请
#define kItemNotAccpetHeiht 108 //未接受
#define kItemCount 5    //单行个数
#define kDefaultMaxJoinCount 10  //默认已加入显示个数
#define kRepeatTime  10  //轮询页面时间

@interface GBMatchInviteViewController () <UICollectionViewDelegate,
UICollectionViewDataSource,
GBMatchInviteCollectionFooterViewDelegate,
GBMatchInviteFriendCollectionCellDelegate,
GBMatchInviteNotAcceptFriendCollectionCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<FriendInfo *> *joinList; //已加入
@property (nonatomic, strong) NSMutableArray <FriendInfo *> *waitingList; //等在邀请
@property (nonatomic, strong) NSArray<NSMutableArray<FriendInfo *> *> *showDataList;
@property (nonatomic, assign) BOOL isUnFlod;
@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, assign) GameType gameType;

@end

@implementation GBMatchInviteViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithMatchId:(NSInteger)matchId gameType:(GameType)gameType {
    
    self = [super init];
    if (self) {
        _matchId = matchId;
        _gameType = gameType;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupNotification];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
    });
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self checkJoinState];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Create_Invite;
}


#pragma mark - NSNotification

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendSelectedNotification:) name:Notification_Friend_Match_Friend_Selected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerSelectedNotification:) name:Notification_Team_Player_Select object:nil];
}
- (void)friendSelectedNotification:(NSNotification *)notification {
    
    NSArray *friendList = notification.object;
    NSMutableArray<NSNumber *> *friendIdList = [NSMutableArray arrayWithCapacity:1];
    for (FriendInfo *info in friendList) {
        [friendIdList addObject:@(info.userId)];
    }
    @weakify(self)
    [MatchRequest inviteFriends:[friendIdList copy] matchId:self.matchId handler:^(id result, NSError *error) {
        
        @strongify(self)
        if (!error) {
            [self showToastWithText:LS(@"inivte-has.send.message.title")];
            [self getFriendJoinInfo:nil];
        }
    }];
}

- (void)playerSelectedNotification:(NSNotification *)notification {
    NSArray *playerList = notification.object;
    NSMutableArray<NSNumber *> *playerIdList = [NSMutableArray arrayWithCapacity:1];
    for (TeamPalyerInfo *info in playerList) {
        [playerIdList addObject:@(info.user_id)];
    }
    @weakify(self)
    [MatchRequest inviteFriends:[playerIdList copy] matchId:self.matchId handler:^(id result, NSError *error) {
        
        @strongify(self)
        if (!error) {
            [self showToastWithText:LS(@"inivte-has.send.message.title")];
            [self getFriendJoinInfo:nil];
        }
    }];
}

#pragma mark - Action

- (void)rightBarAction {
    
    if (self.gameType == GameType_Team) {
        GBTeamMatchInviteViewController *vc = [[GBTeamMatchInviteViewController alloc] initWithSelectedList:@[]];
        UINavigationController *nav = [[GBNavigationController alloc] initWithNavigationBarClass:[GBNavigationBar class] toolbarClass:nil];
        nav.viewControllers = @[vc];
        [self presentViewController:nav animated:YES completion:nil];
        
    } else if (self.gameType == GameType_Standard) {
        GBFriendSelectViewController *vc = [[GBFriendSelectViewController alloc] initWithSelectedFriendList:@[]];
        UINavigationController *nav = [[GBNavigationController alloc] initWithNavigationBarClass:[GBNavigationBar class] toolbarClass:nil];
        nav.viewControllers = @[vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
}

#pragma mark - Private

#pragma mark - UI
- (void)loadData {

    [self showLoadingToast];
    @weakify(self)
    [self getFriendJoinInfo:^{
        @strongify(self)
        [self dismissToast];
    }];
}

- (void)setupUI {
    
    if (self.gameType == GameType_Team) {
        self.title = LS(@"team.match.label.invite");
    } else {
        self.title = LS(@"inivte-friend-join.title");
    }
    
    [self setupBackButtonWithBlock:nil];
    [self setupNavigationBarRight];
    
    [self setupCollectionView];
}

- (void)setupNavigationBarRight {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setSize:CGSizeMake(48, 24)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [button setTitle:LS(@"invite-nav-left-title") forState:UIControlStateNormal];
    [button setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(rightBarAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)setupCollectionView {
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GBMatchInviteFriendCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"GBMatchInviteFriendCollectionCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GBMatchInviteNotAcceptFriendCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"GBMatchInviteNotAcceptFriendCollectionCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GBMatchInviteCollectionSectionView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GBMatchInviteCollectionSectionView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GBMatchInviteCollectionFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"GBMatchInviteCollectionFooterView"];
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    collectionViewLayout.headerReferenceSize = CGSizeMake(kUIScreen_Width, 35*kAppScale);
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self getFriendJoinInfo:nil];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.collectionView.mj_header = mj_header;
    
    [self refreshUI];
}

- (void)refreshUI {
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;

    if (self.joinList.count>kDefaultMaxJoinCount) {
        collectionViewLayout.footerReferenceSize = CGSizeMake(kUIScreen_Width, 40*kAppScale);
    }else {
        collectionViewLayout.footerReferenceSize = CGSizeMake(kUIScreen_Width, 5*kAppScale);
    }
}

#pragma mark - Logic
- (void)checkJoinState {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    [self getFriendJoinInfo:nil];
    
    [self performSelector:@selector(checkJoinState) withObject:nil afterDelay:kRepeatTime];
}

- (void)getFriendJoinInfo:(void(^)())complete {
    
    @weakify(self)
    [MatchRequest getMatchDoingFriendListWithMatchId:self.matchId handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self.collectionView.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            NSArray<FriendInfo *> *tmpList = result;
            self.joinList = [NSMutableArray arrayWithCapacity:1];
            self.waitingList = [NSMutableArray arrayWithCapacity:1];
            for (FriendInfo *info in tmpList) {
                if (info.inviteStatus == FriendInviteMatchStatus_invited) {
                    [self.joinList addObject:info];
                }else {
                    [self.waitingList addObject:info];
                }
            }
            [self refreshShowData];
            [self.collectionView reloadData];
            
            BLOCK_EXEC(self.joinFriendCountBlock, self.joinList.count);
        }
        BLOCK_EXEC(complete);
    }];
}

- (void)refreshShowData {
    
    if (self.isUnFlod) {
        self.showDataList = @[self.joinList, self.waitingList];
    }else {
        if (self.joinList.count>=kDefaultMaxJoinCount) {
            self.showDataList = @[[self.joinList subarrayWithRange:NSMakeRange(0, kDefaultMaxJoinCount)], self.waitingList];
        }else {
            self.showDataList = @[self.joinList, self.waitingList];
        }
    }
}

#pragma mark - Delegate
#pragma mark GBMatchInviteCollectionFooterViewDelegate

- (void)didClickFoldButton:(GBMatchInviteCollectionFooterView *)footerView {
    
    self.isUnFlod = !self.isUnFlod;
    [self refreshShowData];
    [UIView transitionWithView:self.collectionView
                      duration: 0.35f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void) {
                        [self.collectionView reloadData];
                    } completion:nil];
}

#pragma mark GBMatchInviteFriendCollectionCellDelegate

- (void)didClickDeleteButton:(GBMatchInviteFriendCollectionCell *)cell {
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    FriendInfo *info = [self.showDataList[indexPath.section] objectAtIndex:indexPath.row];
    @weakify(self)
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        @strongify(self)
        if (buttonIndex == 1) {
            [self showLoadingToast];
            [MatchRequest kickedOutFriend:info.userId matchId:self.matchId handler:^(id result, NSError *error) {
                
                @strongify(self)
                [self dismissToast];
                if (error) {
                    [self showToastWithText:error.domain];
                }else {
                    [self.joinList removeObject:info];
                    [self refreshShowData];
                    [self.collectionView reloadData];
                    
                    BLOCK_EXEC(self.joinFriendCountBlock, self.joinList.count);
                }
            }];
        }
    } title:LS(@"common.popbox.title.tip") message:[NSString stringWithFormat:@"%@ %@", LS(@"inivte-kick-out-tips"), info.nickName] cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.yes") style:GBALERT_STYLE_NOMAL];
    
}

#pragma mark GBMatchInviteNotAcceptFriendCollectionCellDelegate

- (void)didClcikRetryInviteButton:(GBMatchInviteNotAcceptFriendCollectionCell *)cell {
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    FriendInfo *info = [self.showDataList[indexPath.section] objectAtIndex:indexPath.row];
    [self showLoadingToast];
    @weakify(self)
    [MatchRequest inviteFriends:@[@(info.userId)] matchId:self.matchId handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [self showToastWithText:LS(@"inivte-has.send.message.title")];
        }
    }];
}

#pragma mark  UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.showDataList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.showDataList[section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FriendInfo *info = [self.showDataList[indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section == 0) {
        GBMatchInviteFriendCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GBMatchInviteFriendCollectionCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell.avatorImageView sd_setImageWithURL:[NSURL URLWithString:info.imageUrl] placeholderImage:[UIImage imageNamed:@"portrait"]];
        cell.userNameLabel.text = info.nickName;
        return cell;
    }else {
        GBMatchInviteNotAcceptFriendCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GBMatchInviteNotAcceptFriendCollectionCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell.avatorImageView sd_setImageWithURL:[NSURL URLWithString:info.imageUrl] placeholderImage:[UIImage imageNamed:@"portrait"]];
        cell.userNameLabel.text = info.nickName;
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemHeight = indexPath.section==0?kItemNormalHeiht:kItemNotAccpetHeiht;
    return CGSizeMake(kItemWith*kAppScale,itemHeight*kAppScale);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSInteger h_inSet = (kUIScreen_Width-(kItemWith*kAppScale)*5)/2;
    NSInteger v_inSet = 6*kAppScale;
    return  UIEdgeInsetsMake(v_inSet,h_inSet, v_inSet, h_inSet);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    

    if (kind == UICollectionElementKindSectionHeader)
    {
        GBMatchInviteCollectionSectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GBMatchInviteCollectionSectionView" forIndexPath:indexPath];
        headerView.titleLable.text = (indexPath.section==0)?[NSString stringWithFormat:@"%@(%td)", LS(@"inivte-joined.title"), self.joinList.count]:[NSString stringWithFormat:@"%@(%td)", LS(@"inivte-not-join.title"), self.waitingList.count];
        
        return headerView;
    }else {
        GBMatchInviteCollectionFooterView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"GBMatchInviteCollectionFooterView" forIndexPath:indexPath];
        footerview.delegate = self;
        footerview.isUnFlod = self.isUnFlod;
        if (indexPath.section == 0 && self.joinList.count>kDefaultMaxJoinCount) {
            footerview.arrowButton.hidden = NO;
        }else {
            footerview.arrowButton.hidden = YES;
        }
    
        return footerview;
    }
}

@end
