//
//  MainTabBarController.m
//  MagicBean
//
//  Created by yahua on 16/3/3.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "CatalogViewController.h"
#import "ShoppingCartViewController.h"
#import "MineViewController.h"

#import "UIImage+SuperCompress.h"
#import "UIImage+Color.h"
#import "UIColor+HEX.h"

#import "ShoppingRequest.h"


@interface MainTabBarController () <
UITabBarControllerDelegate>

@property (nonatomic, strong) HomeViewController *homeVC;
@property (nonatomic, strong) CatalogViewController    *catelogVC;
@property (nonatomic, strong) ShoppingCartViewController *shoppingCartVC;
@property (nonatomic, strong) MineViewController     *mineViewController;

@property (nonatomic, strong) UIView                *coverView;

@end

@implementation MainTabBarController

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tabBar.tintColor = [ColorManager styleColor];
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.translucent = NO;
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithObjects:self.homeVC,self.catelogVC, self.shoppingCartVC, self.mineViewController, nil];
    
    for (NSInteger index = 0; index < [viewControllers count]; index++) {
        UINavigationController *nav = [[UINavigationController alloc] initWithNavigationBarClass:[UINavigationBar class] toolbarClass:nil];
        nav.viewControllers = @[[viewControllers objectAtIndex:index]];
        
        [viewControllers replaceObjectAtIndex:index withObject:nav];
        if (index == 0) {
            self.leftVC.nav = nav;
        }
    }
    
    [self setViewControllers:viewControllers];
    
    self.delegate = self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UIView *touchView = [touches anyObject].view;
    if (touchView == self.coverView) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YHMainHallLeftItemClickNotification object:nil];
    }
}


#pragma mark - IIViewDeckControllerDelegate

- (void)viewDeckController:(IIViewDeckController*)viewDeckController willOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated {
    
    if (!self.coverView.superview) {
        [self.view addSubview:self.coverView];
    }
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController didOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated {

}


- (void)viewDeckController:(IIViewDeckController*)viewDeckController didCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated {
    
    [self.coverView removeFromSuperview];
}

#pragma mark - UITabBarControllerDelegate

//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    
//    UIViewController *selected = [tabBarController selectedViewController];
//    if ([selected isEqual:viewController]) {
//        return NO;
//    }
//    return YES;
//}


#pragma mark - Getter and Setter

- (HomeViewController *)homeVC {
    
    if (nil == _homeVC) {
        _homeVC = [[HomeViewController alloc] init];
        UIImage *normalImage = [UIImage imageNamed:@"outline"];
        UIImage *selectImage = [UIImage imageNamed:@"outline_an"];
        normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:normalImage selectedImage:selectImage];
        _homeVC.tabBarItem = tabBarItem;
        
    }
    return _homeVC;
}

- (CatalogViewController *)catelogVC {
    
    if (nil == _catelogVC) {
        _catelogVC = [[CatalogViewController alloc] init];
        UIImage *normalImage = [UIImage imageNamed:@"classification"];
        UIImage *selectImage = [UIImage imageNamed:@"classification_an"];
        normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"分类" image:normalImage selectedImage:selectImage];
        _catelogVC.tabBarItem = tabBarItem;
    }
    return _catelogVC;
}

- (ShoppingCartViewController *)shoppingCartVC {
    
    if (nil == _shoppingCartVC) {
        _shoppingCartVC = [[ShoppingCartViewController alloc]init];
        UIImage *normalImage = [UIImage imageNamed:@"shopping"];
        UIImage *selectImage = [UIImage imageNamed:@"shopping_an"];
        normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"购物车" image:normalImage selectedImage:selectImage];
        _shoppingCartVC.tabBarItem = tabBarItem;
        [ShoppingRequest getShoppingInfoWithHandler:^(id result, NSError *error) {
            
            if (!error) {
                ShoppingListInfo *info = result;
                _shoppingCartVC.title = [NSString stringWithFormat:@"购物车(%td)", info.list.count];
            }
        }];
    }
    return _shoppingCartVC;
}

- (MineViewController*)mineViewController {
    
    if (nil == _mineViewController) {
        _mineViewController = [[MineViewController alloc]init];
        UIImage *normalImage = [UIImage imageNamed:@"me"];
        UIImage *selectImage = [UIImage imageNamed:@"me_an"];
        normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:normalImage selectedImage:selectImage];
        _mineViewController.tabBarItem = tabBarItem;;
    }
    return _mineViewController;
}

- (UIView *)coverView {
    
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:self.view.bounds];
        _coverView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.5];
    }
    
    return _coverView;
}

- (void)setLeftVC:(LeftMenuViewController *)leftVC {
    
    _leftVC = leftVC;
    _leftVC.nav = self.selectedViewController;
}

@end
