//
//  MainViewController.m
//  MagicBean
//
//  Created by yahua on 16/3/13.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "MainViewController.h"
#import "LeftMenuViewController.h"
#import "MainTabBarController.h"
#import "CatalogDetailViewController.h"

#import "HomeResponseInfo.h"

@interface MainViewController ()

@property (nonatomic, strong) MainTabBarController *tabBarVC;


@end

@implementation MainViewController

+ (instancetype)CreateMainViewController {
    
    LeftMenuViewController *left = [LeftMenuViewController new];
    left.view.frame = CGRectMake(0, 0, kUIScreen_Width, kUIScreen_Height);
    MainTabBarController *center = [[MainTabBarController alloc] init];
    center.leftVC = left;
    MainViewController *vc = [[MainViewController alloc] initWithCenterViewController:center leftViewController:left];

    vc.leftSize = kUIScreen_Width*(0.42);
    vc.panningMode = IIViewDeckNoPanning;
    vc.delegate = center;
    vc.tabBarVC = center;
    
    return vc;
}

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setupNotification];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self removeNotification];
}

#pragma mark - NSNotification

- (void)mianHallLeftItemClick:(NSNotification *)notification {
    
    if ([self isSideOpen:IIViewDeckLeftSide]) {
        [self closeLeftViewAnimated:YES];
    }else {
        [self toggleLeftViewAnimated:YES];
    }
}

- (void)closeLeftSide {
    
    [self closeLeftViewAnimated:YES];
}

- (void)mianHallRightSlideEnable:(NSNotification *)notification {
    
    BOOL enable = [[notification.userInfo objectForKey:@"enable"] boolValue];
    self.panningMode = (enable)?IIViewDeckFullViewPanning:IIViewDeckNoPanning;
}

- (void)showCatalogViewNotification:(NSNotification *)notification {
    
    [self.tabBarVC setSelectedIndex:1];
    HomeCategoryInfo *info = notification.object;
    if (info && info.type == CategoryType_Normal) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UINavigationController *nav = self.tabBarVC.selectedViewController;
            NSMutableArray *viewControllers = [NSMutableArray arrayWithObject:nav.viewControllers.firstObject];
            CatalogDetailViewController *vc = [[CatalogDetailViewController alloc] initWithTitle:info.name firstCid:info.cid secondCid:0];
            vc.hidesBottomBarWhenPushed = YES;
            [viewControllers addObject:vc];
            [nav setViewControllers:viewControllers animated:YES];
        });
    }
}

#pragma mark - Private

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mianHallLeftItemClick:) name:YHMainHallLeftItemClickNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeLeftSide) name:YHDeckLeftSideCloseNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mianHallRightSlideEnable:) name:YHMainHallRightSlideEnableNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCatalogViewNotification:) name:Notification_ShowCatalogView object:nil];
}

- (void)removeNotification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
