//
//  GBMenuViewController.m
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/7/14.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBMenuViewController.h"
#import "GBMenuViewController_Blue.h"
#import "GBMenuViewController+Bluetooth.h"
#import "GBFriendBaseViewController.h"
#import "GBGameCreateViewController.h"
#import "GBSyncDataViewController.h"
#import "GBRecordListViewController.h"
#import "GBSettingViewController.h"
#import "GBDailyDayViewController.h"
#import "GBPersonDefaultCardViewController.h"
#import "GBRankBaseViewController.h"
#import "GBMessageContainerViewController.h"
#import "GBMallViewController.h"
#import "GBFootBallModeViewController.h"
#import "GBTeamHomePageViewController.h"

#import "GBCourseMask.h"
#import "GBMenuScroller.h"
#import "MenuItemBar.h"
#import "GBCircleHub.h"

#import "UpdateManager.h"
#import "NoRemindManager.h"
#import "AGPSManager.h"
#import "GBBluetoothManager.h"
#import "GBMenuViewModel.h"

#define kDefaultIndex 3

@interface GBMenuViewController () <GBMenuScrollerDelegate,GBMenuItemBarDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// 底部按钮栏
@property (strong, nonatomic) IBOutlet MenuItemBar  *menuBar;
// 右上角消息图片
@property (weak, nonatomic) IBOutlet UIImageView *messageIconView;
// 教程覆盖页
@property (weak, nonatomic) IBOutlet GBCourseMask *courseMask;
//中部滚动条
@property (strong, nonatomic) GBMenuScroller *menuScroller;

@property (nonatomic, strong) GBMenuViewModel *viewModel;

// 是否是重启初始化
@property (nonatomic, assign) BOOL isRestartInit;

@end

@implementation GBMenuViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (instancetype) initForRestart {
    
    if (self = [self init]) {
        _isRestartInit = YES;
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewModel = [[GBMenuViewModel alloc] init];
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // 重启初始化不做任何操作
    if (!_isRestartInit) {
        
        //蓝牙模式初始化配置
        [self initBluetooth];
        
        if ([[RawCacheManager sharedRawCacheManager] isBindWristband] && ![[GBBluetoothManager sharedGBBluetoothManager] isConnectedBean]) {  //自动连接
            
            [self connectWristbandWithMac:[RawCacheManager sharedRawCacheManager].userInfo.wristbandInfo.mac];
        } else {
            if (![[RawCacheManager sharedRawCacheManager] isBindWristband]) {
                [self performBlock:^{
                    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {  //如果不是当前页，  不弹出扫描框
                        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NeedBindiBeacon object:nil];
                    }
                } delay:1.0f];
            }
        }
        [[UpdateManager shareInstance] checkAppAndFirewareUpdate];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self updateAboutBlutoothUI];
    // 教程蒙版提示
    if (self.viewModel.isShowCourseMask) {
        [self.courseMask showWithType:COURSE_MASK_MENU];
        [self.view bringSubviewToFront:self.courseMask];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.viewModel checkHasNewMessage];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.menuBar.height = (NSInteger)self.menuBar.height;
        CGFloat top = 86 + 70*kAppScale;
        self.menuScroller.frame = CGRectMake(0, (NSInteger)top, self.view.width, self.view.height-top-self.menuBar.height);
    });
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Menu;
}

#pragma mark - Action

// 按下消息按钮
- (IBAction)actionPressMessageButton:(id)sender {
    
    self.viewModel.isNewMessage = NO;
    [self.navigationController pushViewController:[[GBMessageContainerViewController alloc]initWithNewMessageInfo:self.viewModel.hasNewMessageInfo] animated:YES];
}

#pragma mark - Private

- (void)setupUI {

    self.menuBar.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupMenu];
    });
    [self addBluetoothNotification];
    [self setupObserver];
}

- (void)setupMenu {
    
    self.menuScroller = [[GBMenuScroller alloc] initWithFrame:CGRectZero
                                                   imageNames:[self.viewModel bigItemImageNames]
                                                 currentIndex:kDefaultIndex];
    self.menuScroller.delegate = self;
    [self.view addSubview:self.menuScroller];
    
    //menu图片
    [self.menuScroller setupIcons:[self.viewModel bigItemImageNames]];
    [self.menuBar setIconNames:[self.viewModel smallItemImageNames]];
}

- (void)setupObserver {
    
    @weakify(self)
    [self.yah_KVOController observe:self.viewModel keyPath:@"isNewMessage" block:^(id observer, id object, NSDictionary *change) {
        @strongify(self)
        self.messageIconView.image = [self.viewModel messageIcon];
    }];
    [self.yah_KVOController observe:self.viewModel keyPath:@"bigItemImageNames" block:^(id observer, id object, NSDictionary *change) {
        @strongify(self)
        [self.menuScroller setupIcons:[self.viewModel bigItemImageNames]];
    }];
    [self.yah_KVOController observe:self.viewModel keyPath:@"smallItemImageNames" block:^(id observer, id object, NSDictionary *change) {
        @strongify(self)
        [self.menuBar setIconNames:[self.viewModel smallItemImageNames]];
    }];
}

#pragma mark - Delegate

- (void)menuScroller:(GBMenuScroller *)menuScroller didSelectItemAtIndex:(NSInteger)index
{
    switch (index) {
        case 0: {
            [UMShareManager event:Analy_Click_Menu_Card];
            
            GBPersonDefaultCardViewController *vc = [[GBPersonDefaultCardViewController alloc] init];
            vc.userId = [RawCacheManager sharedRawCacheManager].userInfo.userId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 1: {
            [UMShareManager event:Analy_Click_Menu_Rank];
            
            [self.navigationController pushViewController:[GBRankBaseViewController new] animated:YES];
        }
            break;
            
        case 2: {
            [UMShareManager event:Analy_Click_Menu_Record];
            
            [self.navigationController pushViewController:[GBRecordListViewController new] animated:YES];
        }
            break;
            
        case 3: {
            // 比赛未创建 -> 选择球场
            if (![RawCacheManager sharedRawCacheManager].userInfo.matchInfo) {
                [UMShareManager event:Analy_Click_Menu_Create];
                
                [self.navigationController pushViewController:[GBGameCreateViewController new] animated:YES];
                return;
            }
            // 比赛已创建 -> 根据手环搜星状况跳转到不同页面
            else{
                [UMShareManager event:Analy_Click_Menu_Finish];
                
                switch ([AGPSManager shareInstance].status) {
                    case iBeaconStatus_Sport:
                    {
                        [self.navigationController pushViewController:[[GBSyncDataViewController alloc]
                                                                       initWithMatchId:[RawCacheManager sharedRawCacheManager].userInfo.matchInfo.match_id
                                                                       showSportCard:NO] animated:YES];
                    }
                        break;
                    default:
                    {
                        [self.navigationController pushViewController:[[GBFootBallModeViewController alloc] init] animated:YES];
                    }
                        break;
                }
            }
        }
            break;
            
        case 4: {
            [UMShareManager event:Analy_Click_Menu_Team];
            
            [NoRemindManager sharedInstance].tutorialNewTeamIcon = YES;
            [self.menuBar refreshUI];
            [self.navigationController pushViewController:[GBTeamHomePageViewController new] animated:YES];
            
        }
            break;
            
        case 5: {
            [UMShareManager event:Analy_Click_Menu_Daily];
            
            [self.navigationController pushViewController:[GBDailyDayViewController new] animated:YES];
        }
            break;
            
        case 6: {
            [UMShareManager event:Analy_Click_Menu_Friend];
            
            [self.navigationController pushViewController:[GBFriendBaseViewController new] animated:YES];
        }
            break;
            
        case 7: {
            [UMShareManager event:Analy_Click_Menu_Setting];
            
            [self.navigationController pushViewController:[GBSettingViewController new] animated:YES];
        }
            break;
        default:
            break;
    }
    
}

- (void)menuScroller:(GBMenuScroller *)menuScroller didChangeItemAtIndex:(NSInteger)index
{
    self.titleLabel.text = [self.viewModel bigItemNames][index];
    [self.menuBar setSelectIndex:index];
}

- (void)menuItemBar:(MenuItemBar *)menubar index:(NSInteger)index
{
    [self.menuScroller setCurrentMovieIndex:index animated:YES];
}

@end
