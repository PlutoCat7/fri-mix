//
//  Mine_RootViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/15.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "Mine_RootViewController.h"
#import "MineRootTableViewCell.h"
#import "MineSettingsTableViewCell.h"
#import "MineFeedBackController.h"
#import "MineInfoViewController.h"
#import "CommenSettingsController.h"
#import "FollowingViewController.h" 
#import "FollowerViewController.h"
#import "MineHeaderTableViewCell.h"
#import "CollectionViewController.h"
#import "MyMessageViewController.h"
#import "MineFindMainViewController.h"

#import "CollectionTableViewCell.h"
#import "CollectionCloudViewController.h"
#import "PosterFavorViewController.h"
#import "SAFavorViewController.h"
#import "ColorCardFavorViewController.h"
#import "Login.h"
#import "UnReadManager.h"

#import "OptionDetailCell.h"
#import "OptionDetailViewModel.h"

#import "BaseViewModel.h"
#import "BaseTableViewCell.h"
#import "BaseCellLineViewModel.h"

#import "OptionDetailCell.h"
#import "OptionDetailViewModel.h"

#import "NoneContentCell.h"
#import "NoneContentViewModel.h"

#import "PersonProfileHeadView.h"
#import "PersonProfileHeadViewModel.h"

#import "MineOptionCell.h"
#import "MineOptionViewModel.h"
#import "MineOptionDetailViewModel.h"

#import "OneTitleCell.h"
#import "OneTitleViewModel.h"

#import "PersonProfileViewController.h"

#import "FollowerViewController.h"
#import "FollowingViewController.h"
#import "PYPhotoBrowseView.h"

#import "PersonProfileDataModel.h"

#define kHeadViewHeight kRKBHEIGHT(143)

typedef NS_ENUM(NSInteger , MINE_ROOTVIEWCONTROLLERCELLTYPE) {
    MINE_ROOTVIEWCONTROLLERCELLTYPE_DEFAULT,//默认
    MINE_ROOTVIEWCONTROLLERCELLTYPE_MYCOLLECTION,//我的收藏
    MINE_ROOTVIEWCONTROLLERCELLTYPE_MYDISCOVERY,//我的发现
    MINE_ROOTVIEWCONTROLLERCELLTYPE_MYFOLLOER,//我关注的喵友
    MINE_ROOTVIEWCONTROLLERCELLTYPE_MYFOLLOWED,//关注我的喵友
    MINE_ROOTVIEWCONTROLLERCELLTYPE_MYMESSAGE,//我的消息
    MINE_ROOTVIEWCONTROLLERCELLTYPE_COMMONSETTING,//通用设置
    MINE_ROOTVIEWCONTROLLERCELLTYPE_FEEDBACK//意见反馈
};


@interface Mine_RootViewController ()<UITableViewDelegate, UITableViewDataSource, MineSettingsDelegate,PersonProfileHeadViewDelegate>

@property (nonatomic, strong) UITableView    *table;
@property (nonatomic, strong) NSMutableArray *viewModels;

@property (nonatomic, strong) PersonProfileHeadView *headView;
@property (nonatomic, strong) PersonProfileHeadViewModel *headViewModel;

@end

@implementation Mine_RootViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupData) name:kUnreadKey_mineProfileShouldReload object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUIInterface];
    
    [self setupData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UnReadManager shareManager] updateUnRead];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)setupData
{
    [self.viewModels removeAllObjects];

    User *user = [Login curLoginUser];

    self.headViewModel.imageUrl = user.urlhead;
    self.headViewModel.name = user.username;
    [self.headView resetViewWithViewModel:self.headViewModel];
    self.table.tableHeaderView = self.headView;

    [self.viewModels addObject:[self mineOptionViewModel]];
    [self.viewModels addObject:[self emptyModelWithHeight:10 hasBottomLine:NO backgroundColor:[UIColor clearColor]]];

    [self.viewModels addObject:[self optionDetailViewModelWithIconName:@"icon_my_Stars" optionText:@"我的收藏" rightBadgeValue:@"0" cellType:MINE_ROOTVIEWCONTROLLERCELLTYPE_MYCOLLECTION hasBottomLine:NO bottomEdge:UIEdgeInsetsZero]];
    [self.viewModels addObject:[self oneTitleViewModelWithTitle:@"发现"]];
    [self.viewModels addObject:[self optionDetailViewModelWithIconName:@"icon_my_fund" optionText:@"我的发现" rightBadgeValue:@"0" cellType:MINE_ROOTVIEWCONTROLLERCELLTYPE_MYDISCOVERY hasBottomLine:YES bottomEdge:UIEdgeInsetsMake(0, 12, 0, 12)]];
    [self.viewModels addObject:[self optionDetailViewModelWithIconName:@"icon_my_follow" optionText:@"我关注的喵友" rightBadgeValue:@"0" cellType:MINE_ROOTVIEWCONTROLLERCELLTYPE_MYFOLLOER hasBottomLine:YES bottomEdge:UIEdgeInsetsMake(0, 12, 0, 12)]];
    [self.viewModels addObject:[self optionDetailViewModelWithIconName:@"icon_my_people" optionText:@"关注我的喵粉" rightBadgeValue:@"0" cellType:MINE_ROOTVIEWCONTROLLERCELLTYPE_MYFOLLOWED hasBottomLine:NO bottomEdge:UIEdgeInsetsZero]];
    
    [self.table reloadData];
    
    WEAKSELF
    [[TiHouse_NetAPIManager sharedManager] request_checkMyProfileCompletedUsing:^(NSNumber *data, NSError *error) {
        if ([data boolValue])
        {
            User *tmpUser = [Login curLoginUser];
            weakSelf.headViewModel.imageUrl = tmpUser.urlhead;
            weakSelf.headViewModel.name = tmpUser.username;
            [self.headView resetViewWithViewModel:self.headViewModel];
            self.table.tableHeaderView = self.headView;
        }
    }];
}

- (void)setupUIInterface
{
    self.title = @"我的";
    
    self.table = [KitFactory tableView];
    self.table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.tableHeaderView = self.headView;
    [self.view addSubview:self.table];
    
    [self.table registerClass:[OptionDetailCell class] forCellReuseIdentifier:NSStringFromClass([OptionDetailCell class])];
    [self.table registerClass:[NoneContentCell class] forCellReuseIdentifier:NSStringFromClass([NoneContentCell class])];
    [self.table registerClass:[MineOptionCell class] forCellReuseIdentifier:NSStringFromClass([MineOptionCell class])];
    [self.table registerClass:[OneTitleCell class] forCellReuseIdentifier:NSStringFromClass([OneTitleCell class])];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseViewModel *viewModel = self.viewModels[indexPath.row];
    BaseTableViewCell *cell  = [self.table dequeueReusableCellWithIdentifier:viewModel.cellIndentifier];
    cell.delegate = self;
    [cell resetCellWithViewModel:viewModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseViewModel *viewModel    = self.viewModels[indexPath.row];
    if (viewModel.currentCellHeight == 0)
    {
        viewModel.currentCellHeight = [viewModel.cellClass currentCellHeightWithViewModel:viewModel];
    }
    return viewModel.currentCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseViewModel *viewModel    = self.viewModels[indexPath.row];
    switch (viewModel.cellType)
    {
        case MINE_ROOTVIEWCONTROLLERCELLTYPE_MYCOLLECTION:
        {
            //我的收藏
            CollectionViewController *collVC = [CollectionViewController new];
            [self.navigationController pushViewController:collVC animated:YES];
        }
            break;
        case MINE_ROOTVIEWCONTROLLERCELLTYPE_MYDISCOVERY:
        {
            //我的发现
            PersonProfileViewController *personProfileViewController = [[PersonProfileViewController alloc] init];
            personProfileViewController.uid = [Login curLoginUserID];
            [self.navigationController pushViewController:personProfileViewController animated:YES];
        }
            break;
        case MINE_ROOTVIEWCONTROLLERCELLTYPE_MYFOLLOER:
        {
            //我关注的喵友
            FollowingViewController *followingViewController = [[FollowingViewController alloc] init];
            followingViewController.uid = [Login curLoginUserID];
            followingViewController.navTitle = @"我关注的喵友";
            [self.navigationController pushViewController:followingViewController animated:YES];
        }
            break;
        case MINE_ROOTVIEWCONTROLLERCELLTYPE_MYFOLLOWED:
        {
            //关注我的喵友
            FollowerViewController *followingViewController = [[FollowerViewController alloc] init];
            followingViewController.uid = [Login curLoginUserID];
            followingViewController.navTitle = @"关注我的喵粉";
            [self.navigationController pushViewController:followingViewController animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark LazyInit
- (NSMutableArray *)viewModels
{
    if (!_viewModels)
    {
        _viewModels = [[NSMutableArray alloc] init];
    }
    return _viewModels;
}

- (PersonProfileHeadView *)headView
{
    if (!_headView)
    {
        _headView = [[PersonProfileHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeadViewHeight + kNavigationBarTop + kSTATUSBARH)];
        _headView.delegate = self;
    }
    return _headView;
}

- (PersonProfileHeadViewModel *)headViewModel
{
    if (!_headViewModel)
    {
        _headViewModel = [[PersonProfileHeadViewModel alloc] init];
    }
    return _headViewModel;
}

- (BaseViewModel *)mineOptionViewModel
{
    MineOptionViewModel *viewModel = [[MineOptionViewModel alloc] init];
    viewModel.cellClass = [MineOptionCell class];
    viewModel.currentCellHeight = 72;
    
    UnReadManager * unread = [UnReadManager shareManager];
    viewModel.leftViewModel = [[MineOptionDetailViewModel alloc] init];
    viewModel.leftViewModel.icon = [UIImage imageNamed:@"icon_my_news"];
    viewModel.leftViewModel.title = @"我的消息";
    viewModel.leftViewModel.badgeValue = [unread.me_update_count integerValue] > 0 ? [NSString stringWithFormat:@"%ld",[unread.me_update_count integerValue]]: @"0";
    viewModel.leftViewModel.cellType = MINE_ROOTVIEWCONTROLLERCELLTYPE_MYMESSAGE;
    
    viewModel.centerViewModel = [[MineOptionDetailViewModel alloc] init];
    viewModel.centerViewModel.icon = [UIImage imageNamed:@"icon_my_Set up"];
    viewModel.centerViewModel.title = @"通用设置";
    viewModel.centerViewModel.badgeValue = @"0";
    viewModel.centerViewModel.cellType = MINE_ROOTVIEWCONTROLLERCELLTYPE_COMMONSETTING;
    
    viewModel.rightViewModel = [[MineOptionDetailViewModel alloc] init];
    viewModel.rightViewModel.icon = [UIImage imageNamed:@"icon_my_emal"];
    viewModel.rightViewModel.title = @"意见反馈";
    viewModel.rightViewModel.badgeValue = @"0";
    viewModel.rightViewModel.cellType = MINE_ROOTVIEWCONTROLLERCELLTYPE_FEEDBACK;
    
    return viewModel;
}

- (BaseViewModel *)emptyModelWithHeight:(NSInteger)height hasBottomLine:(BOOL)hasBottomLine backgroundColor:(UIColor *)backgroundColor
{
    NoneContentViewModel *viewModel = [[NoneContentViewModel alloc] init];
    viewModel.cellBackgroundColor   = backgroundColor;
    viewModel.cellClass             = [NoneContentCell class];
    viewModel.currentCellHeight     = height;
    if (hasBottomLine)
    {
        viewModel.cellLineViewModel.bottomLineEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return viewModel;
}

- (BaseViewModel *)optionDetailViewModelWithIconName:(NSString *)iconName optionText:(NSString *)optionText rightBadgeValue:(NSString *)badgeValue cellType:(MINE_ROOTVIEWCONTROLLERCELLTYPE)cellType hasBottomLine:(BOOL)hasBottomLine bottomEdge:(UIEdgeInsets)bottomEdge
{
    OptionDetailViewModel *viewModel = [[OptionDetailViewModel alloc] init];
    viewModel.leftIcon = [UIImage imageNamed:iconName];
    viewModel.optionText = optionText;
    viewModel.rightOptionText = badgeValue;
    viewModel.cellClass = [OptionDetailCell class];
    viewModel.currentCellHeight = kRKBHEIGHT(55);
    if (hasBottomLine)
    {
        viewModel.cellLineViewModel.bottomLineEdgeInsets = bottomEdge;
    }
    viewModel.cellType = cellType;
    return viewModel;
}

- (BaseViewModel *)oneTitleViewModelWithTitle:(NSString *)title
{
    OneTitleViewModel *oneTitleViewModel = [[OneTitleViewModel alloc] init];
    oneTitleViewModel.title = title;
    oneTitleViewModel.cellClass = [OneTitleCell class];
    oneTitleViewModel.currentCellHeight = 40;
    return oneTitleViewModel;
}

#pragma mark PersonProfileHeadViewDelegate
- (void)personProfileHeadView:(PersonProfileHeadView *)view clickBackgroundWithViewModel:(PersonProfileHeadViewModel *)viewModel;
{
    MineInfoViewController *infoVC = [MineInfoViewController new];
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (void)personProfileHeadView:(PersonProfileHeadView *)view clickAvatarWithViewModel:(PersonProfileHeadViewModel *)viewModel;
{
    User *user = [Login curLoginUser];
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
    photoBroseView.imagesURL = [NSArray arrayWithObjects:user.urlhead,nil];
    photoBroseView.sourceImgageViews = [NSArray arrayWithObjects:view.topIcon, nil];
    photoBroseView.currentIndex = 0;
    [photoBroseView show];
}

#pragma mark MineOptionCellDelegate
- (void)mineOptionCell:(MineOptionCell *)cell clickDetailViewWithViewModel:(MineOptionDetailViewModel *)viewModel;
{
    switch (viewModel.cellType)
    {
        case MINE_ROOTVIEWCONTROLLERCELLTYPE_MYMESSAGE:
        {
            //我的消息
            MyMessageViewController *myMessageVC = [MyMessageViewController new];
            [self.navigationController pushViewController:myMessageVC animated:YES];
        }
            break;
        case MINE_ROOTVIEWCONTROLLERCELLTYPE_COMMONSETTING:
        {
            //通用设置
            CommenSettingsController *settingVC = [CommenSettingsController new];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
            break;
        case MINE_ROOTVIEWCONTROLLERCELLTYPE_FEEDBACK:
        {
            //意见反馈
            MineFeedBackController *feedBackVC = [MineFeedBackController new];
            [self.navigationController pushViewController:feedBackVC animated:YES];
        }
            break;
        default:
            break;
    }
} 
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
