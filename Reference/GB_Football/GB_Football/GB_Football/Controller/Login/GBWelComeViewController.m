//
//  GBWelComeViewController.m
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/7/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBWelComeViewController.h"
#import "GBSegmentView.h"
#import "GBLoginViewController.h"
#import "GBRegisterViewController.h"


@interface GBWelComeViewController ()<GBSegmentViewDelegate>
@property (nonatomic,strong) GBSegmentView *segmentView;
@property (nonatomic,strong) GBLoginViewController *enterViewController;
@property (nonatomic,strong) GBRegisterViewController *regiterViewController;
@end

@implementation GBWelComeViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - Notification

#pragma mark - Delegate
- (void)GBSegmentView:(GBSegmentView*)segment toViewController:(GBBaseViewController*)viewController
{
    [viewController loadData];
}

#pragma mark - Action

#pragma mark - Private

-(void)setupUI
{
    self.enterViewController   = [[GBLoginViewController alloc]init];
    self.regiterViewController = [[GBRegisterViewController alloc]init];
    CGRect rect = [UIScreen mainScreen].bounds;
    self.segmentView = [[GBSegmentView alloc]initWithFrame:CGRectMake(0,kUIScreen_TopBarContentY, rect.size.width,kUIScreen_Height-kUIScreen_TopBarContentY)
                                                 topHeight:63.f
                                           viewControllers:@[self.enterViewController,self.regiterViewController]
                                                    titles:@[LS(@"login.tab.login"),LS(@"signup.tab.signup")]
                                                  delegate:self];
    [self.view addSubview:self.segmentView];
    [self addChildViewController:self.enterViewController];
    [self addChildViewController:self.regiterViewController];
}

-(void)loadData
{
    
}

#pragma mark - Getters & Setters


@end
