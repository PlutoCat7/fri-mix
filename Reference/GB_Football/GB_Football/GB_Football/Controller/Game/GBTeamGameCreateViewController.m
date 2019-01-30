//
//  GBTeamGameCreateViewController.m
//  GB_Football
//
//  Created by gxd on 17/7/31.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamGameCreateViewController.h"
#import "GBMenuViewController.h"
#import "GBFieldBaseViewController.h"
#import "GBLineUpViewController.h"
#import "GBSyncDataViewController.h"
#import "GBFootBallModeViewController.h"
#import "GBTeamMatchInviteViewController.h"
#import "GBNavigationController.h"

#import "GBTeamInviteCollectionCell.h"
#import "GBHightLightButton.h"
#import "TeamRequest.h"
#import "MatchRequest.h"
#import "UIImageView+WebCache.h"
#import "AGPSManager.h"
#import "LineUpModel.h"

#define kCollectionWith 339
#define kItemWith 65
#define kItemNormalHeiht 80   //已接收邀请
#define kItemCount 5    //单行个数
#define kItemMaxCount 10

@interface GBTeamGameCreateViewController ()
@property (weak, nonatomic) IBOutlet UILabel *matchNameStLbl;
@property (weak, nonatomic) IBOutlet UILabel *matchCourtStLbl;
@property (weak, nonatomic) IBOutlet UILabel *matchTracticStLbl;
@property (weak, nonatomic) IBOutlet UILabel *matchInviteStLbl;
@property (weak, nonatomic) IBOutlet UILabel *matchInvitePlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *matchErrorHintLbl;


@property (weak, nonatomic) IBOutlet UITextField *matchNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *matchCourtLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchTracticLabel;

@property (weak, nonatomic) IBOutlet GBHightLightButton *createButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) MatchInfo *matchInfo;
@property (nonatomic, strong) LineUpModel *tracticsModel;
@property (nonatomic, strong) NSArray<TeamPalyerInfo *> *selectedPlayers;

@property (nonatomic, strong) GBLineUpViewModel *tracticsViewModel;
@property (nonatomic, strong) NSArray<NSArray<LineUpPlayerModel *> *> *tracticsPlayerList;

@end

@implementation GBTeamGameCreateViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectedPlayers = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)localizeUI {
    
    self.matchNameStLbl.text = LS(@"multi-section.game.name");
    self.matchCourtStLbl.text = LS(@"multi-section.choose.court");
    self.matchTracticStLbl.text = LS(@"team.match.label.tractics");
    self.matchInviteStLbl.text = LS(@"team.match.label.invite");
    self.matchInvitePlaceholder.text = LS(@"team.match.label.invite.placeholder");
    //self.matchErrorHintLbl.text = LS(@"team.match.label.error");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupNotification];
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
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.selectedPlayers.count>kItemCount) {
            CGRect frame = self.collectionView.frame;
            frame.size.height = (kItemMaxCount / kItemCount) * kItemNormalHeiht * kAppScale;
            self.collectionView.frame = frame;
        }else {
            CGRect frame = self.collectionView.frame;
            frame.size.height = kItemNormalHeiht * kAppScale;
            self.collectionView.frame = frame;
        }
        
    });
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Team_Game;
}

#pragma mark - NSNotificaion

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedCourtNotification:) name:Notification_SelectedCourt object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedTracticsNotification:) name:Notification_Team_Tractic_Select object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedPlayersNotification:) name:Notification_Team_Player_Select object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteCourtNotification:) name:Notification_DeleteCourt object:nil];

}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    self.matchInfo.matchName = self.matchNameTextField.text;
    [self checkInputValid];
}

- (void)selectedCourtNotification:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    self.matchInfo.courtId = [userInfo[@"court_id"] integerValue];
    self.matchInfo.courtName = userInfo[@"court_name"];
    self.matchCourtLabel.text = userInfo[@"court_name"];
    self.matchCourtLabel.textColor = [UIColor whiteColor];
    [self checkInputValid];
}

- (void)selectedTracticsNotification:(NSNotification *)notification {
    
    self.tracticsViewModel = notification.object;
    self.tracticsModel = self.tracticsViewModel.tracticsList[self.tracticsViewModel.currentTracticsIndex];
    self.matchTracticLabel.text = self.tracticsModel.name;
    self.matchTracticLabel.textColor = [UIColor whiteColor];
    [self checkInputValid];
    
    @weakify(self)
    [self.tracticsViewModel tracticsPlayerListWithHandle:^(NSArray<NSArray<LineUpPlayerModel *> *> *list, NSError *error) {
        
        @strongify(self)
        if (!error) {
            self.tracticsPlayerList = list;
        }
    }];
    
    
}

- (void)selectedPlayersNotification:(NSNotification *)notification {
    
    NSArray *playerList = notification.object;
    self.selectedPlayers = playerList;
    if (self.selectedPlayers.count >= 2) {
        self.matchInvitePlaceholder.text = [NSString stringWithFormat:@"%@%d%@", LS(@"team.match.label.invite.select"), (int) self.selectedPlayers.count, LS(@"team.match.label.invite.player")];
    } else {
        self.matchInvitePlaceholder.text = LS(@"team.match.label.invite.placeholder");
    }
    
    [self refreshUI];
    [self.collectionView reloadData];
    [self checkInputValid];
}

- (void)deleteCourtNotification:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    NSInteger court_id = [userInfo[@"court_id"] integerValue];
    if (court_id == self.matchInfo.courtId) { //删除默认球队
        self.matchInfo.courtId = 0;
        self.matchInfo.courtName = @"";
        self.matchCourtLabel.text = LS(@"multi-section.choose.court.placehold");
        self.matchCourtLabel.textColor = [UIColor colorWithHex:0x5b5b5b];
        
        [self checkInputValid];
    }
}

#pragma mark -Action

- (IBAction)actionSelectCourt:(id)sender {
    [self.navigationController pushViewController:[[GBFieldBaseViewController alloc] initWithPageIndex:1] animated:YES];
}

- (IBAction)actionSelectTractics:(id)sender {
    
    GBLineUpViewController *vc = [[GBLineUpViewController alloc] initWithTracticModel:self.tracticsViewModel useSelect:YES];
    [vc loadLineUpList];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionCreate:(id)sender {
    [self showLoadingToast];
    NSMutableArray<NSNumber *> *friendList = [NSMutableArray arrayWithCapacity:1];
    //invite friends
    for (TeamPalyerInfo *info in _selectedPlayers) {
        [friendList addObject:@(info.user_id)];
    }
    
    @weakify(self)
    [MatchRequest addMatch:self.matchInfo friendList:[friendList copy] tractics:self.tracticsModel.tracticsType tracticsPlayerList:self.tracticsPlayerList handler:^(id result, NSError *error) {
        
        @strongify(self)
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            MatchInfo *matchInfo = result;
            [self saveAndStartMatch:matchInfo.matchId];
        }
    }];
}

- (IBAction)actionSelectPlayer:(id)sender {
    
    GBTeamMatchInviteViewController *vc = [[GBTeamMatchInviteViewController alloc] initWithSelectedList:self.selectedPlayers];
    UINavigationController *nav = [[GBNavigationController alloc] initWithNavigationBarClass:[GBNavigationBar class] toolbarClass:nil];
    nav.viewControllers = @[vc];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedPlayers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TeamPalyerInfo *info = self.selectedPlayers[indexPath.row];

    GBTeamInviteCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GBTeamInviteCollectionCell" forIndexPath:indexPath];
    [cell.avatorImageView sd_setImageWithURL:[NSURL URLWithString:info.image_url] placeholderImage:[UIImage imageNamed:@"portrait"]];
    cell.userNameLabel.text = info.nick_name;

    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kItemWith*kAppScale,kItemNormalHeiht*kAppScale);
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
    NSInteger h_inSet = (kCollectionWith*kAppScale-(kItemWith*kAppScale)*5)/2;
    NSInteger v_inSet = 0*kAppScale;
    return  UIEdgeInsetsMake(v_inSet,h_inSet, v_inSet, h_inSet);
}

#pragma mark - Private
- (void)loadData {
    
    self.matchInfo = [MatchInfo new];
    self.matchInfo.creatorId = [RawCacheManager sharedRawCacheManager].userInfo.userId;
    self.matchInfo.creatorName = [RawCacheManager sharedRawCacheManager].userInfo.nick;
    self.matchInfo.createMatchDate = [NSDate date].timeIntervalSince1970;
    self.matchInfo.gameType = GameType_Team;
    
}

- (NSArray<TeamPalyerInfo *> *)getTeamPlayerListWithoutMe:(NSArray<TeamPalyerInfo *> *)result {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    if (result && result.count > 0) {
        NSInteger userId = [RawCacheManager sharedRawCacheManager].userInfo.userId;
        for (TeamPalyerInfo *playerInfo in result) {
            if (playerInfo.user_id == userId) {
                continue;
            }
            
            [array addObject:playerInfo];
        }
    }
    
    return array;
}

- (void)setupUI {
    
    self.title = LS(@"team.match.nav.title");
    [self setupBackButtonWithBlock:nil];
    
    self.matchNameTextField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString:LS(@"multi-section.game.name.placehold")
                                                    attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x5b5b5b]}];
    if ([RawCacheManager sharedRawCacheManager].userInfo.default_court) {
        self.matchInfo.courtId = [RawCacheManager sharedRawCacheManager].userInfo.default_court.courtId;
        self.matchInfo.courtName = [RawCacheManager sharedRawCacheManager].userInfo.default_court.courtName;
        self.matchCourtLabel.text = self.matchInfo.courtName;
        self.matchCourtLabel.textColor = [UIColor whiteColor];
    }else {
        self.matchCourtLabel.text = LS(@"multi-section.choose.court.placehold");
        self.matchCourtLabel.textColor = [UIColor colorWithHex:0x5b5b5b];
    }
    
    self.matchTracticLabel.text = LS(@"team.match.label.tractics.placeholder");
    self.matchTracticLabel.textColor = [UIColor colorWithHex:0x5b5b5b];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GBTeamInviteCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"GBTeamInviteCollectionCell"];
    
    [self refreshUI];
}

- (void)refreshUI {
    
    if (self.selectedPlayers.count > 0) {
        self.collectionView.hidden = NO;
        //self.matchErrorHintLbl.hidden = YES;
        
        if (self.selectedPlayers.count>kItemCount) {
            CGRect frame = self.collectionView.frame;
            frame.size.height = (kItemMaxCount / kItemCount) * kItemNormalHeiht * kAppScale;
            self.collectionView.frame = frame;
        }else {
            CGRect frame = self.collectionView.frame;
            frame.size.height = kItemNormalHeiht * kAppScale;
            self.collectionView.frame = frame;
        }
        [self.collectionView reloadData];
        
    } else {
        self.collectionView.hidden = YES;
        //self.matchErrorHintLbl.hidden = NO;
    }
}

- (void)checkInputValid {
    
    self.createButton.enabled = self.matchInfo.matchName.length>=2 && self.matchInfo.courtId>0 && self.selectedPlayers.count >= 2 && self.tracticsModel != nil;
}

- (void)saveAndStartMatch:(NSInteger)matchId {
    
    UserMatchInfo *userMatchInfo = [[UserMatchInfo alloc] init];
    userMatchInfo.match_id = matchId;
    userMatchInfo.creator_id = [RawCacheManager sharedRawCacheManager].userInfo.userId;
    [RawCacheManager sharedRawCacheManager].userInfo.matchInfo = userMatchInfo;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CreateMatchSuccess object:nil];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [viewControllers removeLastObject];
    // 搜星模式直接进同步页
    switch ([AGPSManager shareInstance].status) {
        case iBeaconStatus_Sport:
        {
            [viewControllers addObject:[[GBSyncDataViewController alloc] initWithMatchId:matchId showSportCard:NO]];
        }
            break;
        default:
        {
            [viewControllers addObject:[[GBFootBallModeViewController alloc] init]];
        }
            break;
    }
    
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

@end
