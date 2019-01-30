//
//  GBRankBaseViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/31.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBRankBaseViewController.h"
#import "SINavigationMenuView.h"
#import "GBMenuViewController.h"
#import "GBThisTrunRankViewController.h"
#import "GBDailyRankViewController.h"
#import "GBHistoryRankViewController.h"

@interface GBRankBaseViewController ()<SINavigationMenuDelegate>
@property (nonatomic,strong) GBThisTrunRankViewController   *thisTrunRankViewController;
@property (nonatomic,strong) GBDailyRankViewController      *dailyRankViewController;
@property (nonatomic,strong) GBHistoryRankViewController    *historyRankViewController;
@property (nonatomic,strong) GBBaseViewController           *currentViewController;
@property (nonatomic,strong) GBBaseViewController           *oldViewController;
@property (nonatomic,strong) SINavigationMenuView           *navBarMenu;
@end

@implementation GBRankBaseViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.thisTrunRankViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.dailyRankViewController.view.frame    = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.historyRankViewController.view.frame  = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Rank;
}

#pragma mark - Notification

#pragma mark - Delegate

- (void)didSelectItemAtIndex:(NSUInteger)index
{
    switch (index)
    {
        case 0:
        {
            [UMShareManager event:Analy_Click_Rank_Trun];
            
            if ([self.currentViewController isEqual:self.thisTrunRankViewController]) {
                return;
            }
            
            [self transitionFromViewController:self.currentViewController toViewController:self.thisTrunRankViewController duration:1 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{}
            completion:^(BOOL finished)
            {
                if (finished) {self.currentViewController=self.thisTrunRankViewController;
                }
            }];
        }
            break;
        case 1:
        {
            [UMShareManager event:Analy_Click_Rank_Hist];
            
            if ([self.currentViewController isEqual:self.historyRankViewController]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.historyRankViewController duration:1 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{}
                                    completion:^(BOOL finished)
             {
                 if (finished) {self.currentViewController=self.historyRankViewController;
                 }
             }];
        }
            break;
        case 2:
        {
            [UMShareManager event:Analy_Click_Rank_Daily];
            
            if ([self.currentViewController isEqual:self.dailyRankViewController]) {
                return;
            }
            [self transitionFromViewController:self.currentViewController toViewController:self.dailyRankViewController duration:1 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{}
                                    completion:^(BOOL finished)
             {
                 if (finished) {self.currentViewController=self.dailyRankViewController;
                 }
             }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Action

#pragma mark - Private

-(void)setupUI
{
    [self setupNavBar];
    [self setupViewControllers];
}

-(void)setupNavBar
{
    if (self.navigationItem)
    {
        CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
        self.navBarMenu = [[SINavigationMenuView alloc] initWithFrame:frame title:LS(@"rank.nav.latest")];
        self.navBarMenu.items = @[LS(@"rank.nav.latest"), LS(@"rank.nav.history"), LS(@"rank.nav.daily")];
        self.navBarMenu.delegate = self;
        self.navigationItem.titleView = self.navBarMenu;
        [self.navBarMenu displayMenuInView:self.navigationController.view];
    }
    @weakify(self)
    [self setupBackButtonWithBlock:^{
        
        @strongify(self)
        [self.navBarMenu remove];
    }];
}

-(void)setupViewControllers
{
    self.thisTrunRankViewController = [[GBThisTrunRankViewController alloc]init];
    self.dailyRankViewController    = [[GBDailyRankViewController alloc]init];
    self.historyRankViewController  = [[GBHistoryRankViewController alloc]init];
    [self addChildViewController:self.thisTrunRankViewController];
    [self addChildViewController:self.dailyRankViewController];
    [self addChildViewController:self.historyRankViewController];
    self.thisTrunRankViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.dailyRankViewController.view.frame    = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.historyRankViewController.view.frame  = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    // 指定当前控制器
    [self.view addSubview:self.thisTrunRankViewController.view];
    self.currentViewController = self.thisTrunRankViewController;
    
    [UMShareManager event:Analy_Click_Rank_Trun];
}

-(void)loadData
{
    
}

#pragma mark - Getters & Setters

@end
