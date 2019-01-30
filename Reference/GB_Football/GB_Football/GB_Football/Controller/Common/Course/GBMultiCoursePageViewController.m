//
//  GBMultiCoursePageViewController.m
//  GB_Football
//
//  Created by gxd on 17/5/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBMultiCoursePageViewController.h"
#import "GBMultiOneViewController.h"
#import "GBMultiTwoViewController.h"
#import "GBSegmentView.h"
#import "NoRemindManager.h"

@interface GBMultiCoursePageViewController ()<GBSegmentViewDelegate>

@property (nonatomic,strong) GBSegmentView *segmentView;
@property (nonatomic,strong) GBMultiOneViewController *multiOneViewController;
@property (nonatomic,strong) GBMultiTwoViewController *multiTwoViewController;

@end

@implementation GBMultiCoursePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (!IS_IPHONE_X) {
        [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
     self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - Delegate
- (void)GBSegmentView:(GBSegmentView*)segment toViewController:(GBBaseViewController*)viewController
{
}

#pragma mark - Private

-(void)setupUI
{
    [NoRemindManager sharedInstance].tutorialMultiMode = YES;
    
    self.multiOneViewController   = [[GBMultiOneViewController alloc]init];
    self.multiTwoViewController = [[GBMultiTwoViewController alloc]init];
    self.segmentView = [[GBSegmentView alloc]initWithFrame:[UIScreen mainScreen].bounds
                                                 topHeight:0.f
                                           viewControllers:@[self.multiOneViewController,self.multiTwoViewController]
                                                    titles:nil
                                                  delegate:self];
    [self.view addSubview:self.segmentView];
    [self addChildViewController:self.multiOneViewController];
    [self addChildViewController:self.multiTwoViewController];
}


@end
