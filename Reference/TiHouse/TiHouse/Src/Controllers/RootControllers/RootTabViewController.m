//
//  BaseViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/15.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "RootTabViewController.h"
#import "RDVTabBarItem.h"
#import "BaseNavigationController.h"

#import "Home_RootViewController.h"
#import "Find_RootViewController.h"
#import "Discovery_RootViewController.h"
#import "Knowledge_RootViewController.h"
#import "Market_RootViewController.h"
#import "Mine_RootViewController.h"

#import "UnReadManager.h"
#import "Login.h"


@interface RootTabViewController ()

@end

@implementation RootTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViewControllers];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark Private_M
- (void)setupViewControllers {
    Home_RootViewController *home = [[Home_RootViewController alloc] init];
    UINavigationController *nav_home = [[BaseNavigationController alloc] initWithRootViewController:home];
//    RAC(home, rdv_tabBarItem.badgeValue) = [RACSignal combineLatest:@[RACObserve([UnReadManager shareManager], project_update_count)]
//                                                             reduce:^id(NSNumber *project_update_count){
//                                                                 return project_update_count.integerValue > 0? kBadgeTipStr : @"";
//                                                             }];
    
//    Find_RootViewController *find = [[Find_RootViewController alloc] init];
    Discovery_RootViewController *find = [[Discovery_RootViewController alloc] init];
    UINavigationController *nav_find = [[BaseNavigationController alloc] initWithRootViewController:find];
    RAC(find, rdv_tabBarItem.badgeValue) = [RACSignal combineLatest:@[RACObserve([UnReadManager shareManager], find_update_count)]
                                                           reduce:^id(NSNumber *find_update_count){
                                                               NSString *badgeTip = @"";
                                                               return badgeTip;
                                                           }];
    
    Knowledge_RootViewController *knowledge = [[Knowledge_RootViewController alloc]init];
    UINavigationController *nav_knowledge = [[BaseNavigationController alloc] initWithRootViewController:knowledge];
    RAC(knowledge, rdv_tabBarItem.badgeValue) = [RACSignal combineLatest:@[RACObserve([UnReadManager shareManager], know_update_count)]
                                                           reduce:^id(NSNumber *know_update_count){
                                                               NSString *badgeTip = @"";
                                                               NSNumber *unreadCount = [NSNumber numberWithInteger:know_update_count.integerValue];
                                                               if (unreadCount.integerValue > 0) {
                                                                   if (unreadCount.integerValue > 99) {
                                                                       badgeTip = @"99+";
                                                                   }else{
                                                                       badgeTip = unreadCount.stringValue;
                                                                   }
                                                               }
                                                               return badgeTip;
                                                           }];
    
    //    Market_RootViewController *market = [[Market_RootViewController alloc] init];//商城暂时不上线
    //    UINavigationController *nav_market = [[BaseNavigationController alloc] initWithRootViewController:market];//商城暂时不上线
    
    Mine_RootViewController *me = [[Mine_RootViewController alloc] init];
    UINavigationController *nav_me = [[BaseNavigationController alloc] initWithRootViewController:me];
    RAC(me, rdv_tabBarItem.badgeValue) = [RACSignal combineLatest:@[RACObserve([UnReadManager shareManager], me_update_count)]
                                                                reduce:^id(NSNumber *me_update_count){
                                                                    NSString *badgeTip = @"";
                                                                    NSNumber *unreadCount = [NSNumber numberWithInteger:me_update_count.integerValue];
                                                                    if (unreadCount.integerValue > 0) {
                                                                        if (unreadCount.integerValue > 99) {
                                                                            badgeTip = @"99+";
                                                                        }else{
                                                                            badgeTip = unreadCount.stringValue;
                                                                        }
                                                                    }
                                                                    return badgeTip;
                                                                }];
    
    [self setViewControllers:@[nav_home, nav_find, nav_knowledge, nav_me]];
    [self customizeTabBarForController];
    self.delegate = self;
}

- (void)customizeTabBarForController {
    UIImage *backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    NSArray *tabBarItemImages = @[@"project", @"task", @"tweet", @"me"];
    NSArray *tabBarItemTitles = @[@"有数", @"发现", @"知识", @"我的"];
    tabBarItemTitles = @[@"有数", @"发现", @"知识", @"我的"];
    tabBarItemTitles = @[@"有数", @"发现", @"知识", @"我的"];
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        item.titlePositionAdjustment = UIOffsetMake(0, 3);
        [item setBackgroundSelectedImage:backgroundImage withUnselectedImage:backgroundImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setTitle:[tabBarItemTitles objectAtIndex:index]];
        index++;
    }
    [self.tabBar addLineUp:YES andDown:NO andColor:kColorD8DDE4];
}

#pragma mark RDVTabBarControllerDelegate
- (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedViewController != viewController) {
        return YES;
    }
    if (![viewController isKindOfClass:[UINavigationController class]]) {
        return YES;
    }
    UINavigationController *nav = (UINavigationController *)viewController;
    if (nav.topViewController != nav.viewControllers[0]) {
        return YES;
    }
//    if ([nav isKindOfClass:[RKSwipeBetweenViewControllers class]]) {
//        RKSwipeBetweenViewControllers *swipeVC = (RKSwipeBetweenViewControllers *)nav;
//        if ([[swipeVC curViewController] isKindOfClass:[BaseViewController class]]) {
//            BaseViewController *rootVC = (BaseViewController *)[swipeVC curViewController];
//            [rootVC tabBarItemClicked];
//        }
//    } else {
//        if ([nav.topViewController isKindOfClass:[BaseViewController class]]) {
//            BaseViewController *rootVC = (BaseViewController *)nav.topViewController;
//            [rootVC tabBarItemClicked];
//        }
//    }
    return YES;
}
@end

