//
//  GBGameCreateViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/10.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBGameCreateViewController.h"
#import "GBMenuViewController.h"
#import "GBFieldBaseViewController.h"
#import "GBGameTimeDivisionRecordViewController.h"
#import "GBSyncDataViewController.h"
#import "GBFootBallModeViewController.h"
#import "GBFriendSelectViewController.h"
#import "GBNavigationController.h"
#import "GBTeamGameCreateViewController.h"
#import "GBTeamGameCreateViewController.h"

#import "GBHightLightButton.h"
#import "GBGameTypeDescView.h"
#import "UIImageView+WebCache.h"

#import "MatchRequest.h"
#import "AGPSManager.h"
#import "FriendListResponseInfo.h"

#define kMaxShowFriendCount 4

@interface GBGameCreateViewController ()
@property (weak, nonatomic) IBOutlet UILabel *standardLabel;
@property (weak, nonatomic) IBOutlet UIImageView *standardImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeDivisionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeDivisionImageView;
@property (weak, nonatomic) IBOutlet UITextField *gameNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *courtNameLabel;
//邀请好友
@property (weak, nonatomic) IBOutlet UIView *inviteFriendContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *moreAddView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *friendViewList;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *friendAvatorList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreIconWidthConstraint;

@property (weak, nonatomic) IBOutlet GBHightLightButton *okButton;


//localizable
@property (weak, nonatomic) IBOutlet UILabel *standardDecLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDivisionDecLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameNameTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *courtNameTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteFriendLabel;


@property (nonatomic, strong) MatchInfo *matchInfo;
@property (nonatomic, strong) NSArray<FriendInfo *> *selectedFriendList;

@end

@implementation GBGameCreateViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)localizeUI {
    
    self.standardLabel.text = LS(@"multi-section.standard.mode");
    self.standardDecLabel.text = LS(@"multi-section.standard.mode.desc");
    self.timeDivisionLabel.text = LS(@"multi-section.multi-section.mode");
    self.timeDivisionDecLabel.text = LS(@"multi-section.multi-section.mode.desc");
    self.gameNameTitleLabel.text = LS(@"multi-section.game.name");
    self.courtNameTitleLabel.text = LS(@"multi-section.choose.court");
    self.inviteFriendLabel.text = LS(@"multi-section.invite.friend");
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
        
        for(UIImageView *avatorImageView in self.friendAvatorList) {
            avatorImageView.layer.cornerRadius = avatorImageView.width/2;
            avatorImageView.clipsToBounds = YES;
        }
    });
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Create;
}

#pragma mark - NSNotificaion

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedCourtNotification:) name:Notification_SelectedCourt object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendSelectedNotification:) name:Notification_Friend_Match_Friend_Selected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteCourtNotification:) name:Notification_DeleteCourt object:nil];
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    self.matchInfo.matchName = self.gameNameTextField.text;
    [self checkInputValid];
}

- (void)selectedCourtNotification:(NSNotification *)notification {

    NSDictionary *userInfo = notification.userInfo;
    self.matchInfo.courtId = [userInfo[@"court_id"] integerValue];
    self.matchInfo.courtName = userInfo[@"court_name"];
    self.courtNameLabel.text = userInfo[@"court_name"];
    self.courtNameLabel.textColor = [UIColor whiteColor];
    [self checkInputValid];
}

- (void)deleteCourtNotification:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    NSInteger court_id = [userInfo[@"court_id"] integerValue];
    if (court_id == [RawCacheManager sharedRawCacheManager].userInfo.default_court.courtId) { //删除默认球队
        [RawCacheManager sharedRawCacheManager].userInfo.default_court = nil;
        [self updateCourtUI];
    }
}

- (void)friendSelectedNotification:(NSNotification *)notification {
    
    NSArray *friendList = notification.object;
    self.selectedFriendList = friendList;
    [self updateInviteFriendUI];
}

#pragma mark -UITextFieldDelegate

// 字数限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(strlen([self.gameNameTextField.text UTF8String]) >= 33 && range.length != 1)return NO;
    
    return YES;
}

// Done键盘回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Action

- (IBAction)actionStanderdDesc:(id)sender {
    
    [GBGameTypeDescView showWithGameType:GameType_Standard];
}

- (IBAction)actionTimeDivisionDesc:(id)sender {
    
    [GBGameTypeDescView showWithGameType:GameType_Define];
}

- (IBAction)actionStandardGame:(id)sender {
    
    self.matchInfo.gameType = GameType_Standard;
    self.inviteFriendContainerView.hidden = NO;
    self.standardLabel.textColor = [UIColor greenColor];
    self.standardImageView.image = [UIImage imageNamed:@"time_division_Select"];
    self.timeDivisionLabel.textColor = [UIColor whiteColor];
    self.timeDivisionImageView.image = [UIImage imageNamed:@"time_division_Select_uncheck"];
}

- (IBAction)actionTimeDivisionGame:(id)sender {
    
    self.matchInfo.gameType = GameType_Define;
    self.inviteFriendContainerView.hidden = YES;
    self.timeDivisionLabel.textColor = [UIColor greenColor];
    self.timeDivisionImageView.image = [UIImage imageNamed:@"time_division_Select"];
    self.standardLabel.textColor = [UIColor whiteColor];
    self.standardImageView.image = [UIImage imageNamed:@"time_division_Select_uncheck"];
}

- (IBAction)ActionSelectCourt:(id)sender {
    
    [self.navigationController pushViewController:[[GBFieldBaseViewController alloc] initWithPageIndex:1] animated:YES];
}

- (IBAction)actionInviteFrient:(id)sender {
    
    [UMShareManager event:Analy_Click_Game_Invite1];
    
    GBFriendSelectViewController *vc = [[GBFriendSelectViewController alloc] initWithSelectedFriendList:self.selectedFriendList];
    UINavigationController *nav = [[GBNavigationController alloc] initWithNavigationBarClass:[GBNavigationBar class] toolbarClass:nil];
    nav.viewControllers = @[vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)actionOK:(id)sender {
    
    [UMShareManager event:Analy_Click_Game_Create];
    
    [self showLoadingToast];
    NSMutableArray<NSNumber *> *friendList = [NSMutableArray arrayWithCapacity:1];
    //only GameType_Standard to invite friends
    if (self.matchInfo.gameType == GameType_Standard) {
        for (FriendInfo *info in _selectedFriendList) {
            [friendList addObject:@(info.userId)];
        }
    }
    @weakify(self)
    [MatchRequest addMatch:self.matchInfo friendList:[friendList copy] tractics:TracticsType_Not tracticsPlayerList:nil handler:^(id result, NSError *error) {
            
        @strongify(self)
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            MatchInfo *matchInfo = result;
            [self saveAndStartMatch:matchInfo.matchId];
        }
    }];
}

#pragma mark - Private

- (void)loadData {
    
    self.matchInfo = [MatchInfo new];
    self.matchInfo.creatorId = [RawCacheManager sharedRawCacheManager].userInfo.userId;
    self.matchInfo.creatorName = [RawCacheManager sharedRawCacheManager].userInfo.nick;
    self.matchInfo.createMatchDate = [NSDate date].timeIntervalSince1970;
    self.matchInfo.gameType = GameType_Standard;
}

- (void)setupUI {
    
    self.title = LS(@"football.button.create");
    [self setupBackButtonWithBlock:nil];
    
    self.gameNameTextField.attributedPlaceholder = [[NSAttributedString alloc]
                                            initWithString:LS(@"multi-section.game.name.placehold")
                                            attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x909090]}];
    [self updateCourtUI];
    [self updateInviteFriendUI];
}

- (void)updateInviteFriendUI {
    
    if (self.selectedFriendList.count<=kMaxShowFriendCount) {
        self.moreIconWidthConstraint.constant = 0;
        //先隐藏
        for(UIView *view in self.friendViewList) {
            view.hidden = YES;
        }
        NSInteger index = self.selectedFriendList.count-1;
        for (NSInteger i=0; i<self.selectedFriendList.count; i++) {
            UIView *view = self.friendViewList[i];
            view.hidden = NO;
            UIImageView *avatorImageView = self.friendAvatorList[i];
            [avatorImageView sd_setImageWithURL:[NSURL URLWithString:self.selectedFriendList[index].imageUrl] placeholderImage:[UIImage imageNamed:@"portrait"]];
            index--;
        }
    }else {
        self.moreIconWidthConstraint.constant = 17;
        for(UIView *view in self.friendViewList) {
            view.hidden = NO;
        }
        NSInteger index=0;
        for (NSInteger i=self.selectedFriendList.count-1; i>=self.selectedFriendList.count-kMaxShowFriendCount; i--) {
            UIImageView *avatorImageView = self.friendAvatorList[index];
            [avatorImageView sd_setImageWithURL:[NSURL URLWithString:self.selectedFriendList[i].imageUrl] placeholderImage:[UIImage imageNamed:@"portrait"]];
            index++;
        }
    }
}

- (void)updateCourtUI {
    
    if ([RawCacheManager sharedRawCacheManager].userInfo.default_court) {
        self.matchInfo.courtId = [RawCacheManager sharedRawCacheManager].userInfo.default_court.courtId;
        self.matchInfo.courtName = [RawCacheManager sharedRawCacheManager].userInfo.default_court.courtName;
        self.courtNameLabel.text = self.matchInfo.courtName;
        self.courtNameLabel.textColor = [UIColor whiteColor];
    }else {
        self.courtNameLabel.text = LS(@"multi-section.choose.court.placehold");
        self.courtNameLabel.textColor = [UIColor colorWithHex:0x909090];
    }
}

- (void)checkInputValid {
    
    self.okButton.enabled = self.matchInfo.matchName.length>=2 && self.matchInfo.courtId>0;
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
