//
//  TacticsBaseViewController.m
//  GB_Football
//
//  Created by yahua on 2018/1/12.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "TacticsContainerViewController.h"
#import "TacticsListViewController.h"
#import "GBLineUpViewController.h"

#import "TacticsContainerHeaderView.h"

@interface TacticsContainerViewController () <TacticsContainerHeaderViewDelegate>

@property (nonatomic,strong) GBBaseViewController           *currentViewController;
@property (nonatomic,strong) TacticsListViewController   *tacticsListViewController;
@property (nonatomic,strong) GBLineUpViewController   *lineUpViewController;

@property (nonatomic, strong) UIButton *yesButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation TacticsContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tacticsListViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.lineUpViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

#pragma mark - Private

- (void)setupUI {
    
    [self setupBackButtonWithBlock:nil];
    TacticsContainerHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"TacticsContainerHeaderView" owner:self options:nil].firstObject;
    headerView.delegate = self;
    self.navigationItem.titleView = headerView;
    
    self.tacticsListViewController = [[TacticsListViewController alloc]init];
    self.lineUpViewController = [[GBLineUpViewController alloc]initWithTeamInfo:self.teamResponse useSelect:NO];
    [self addChildViewController:self.tacticsListViewController];
    [self addChildViewController:self.lineUpViewController];
    self.tacticsListViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.lineUpViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    // 指定当前控制器
    [self.view addSubview:self.tacticsListViewController.view];
    self.currentViewController = self.tacticsListViewController;
}

#pragma mark - Delegate

- (void)didClickTactics {
    
    if (self.currentViewController == self.tacticsListViewController) {
        return;
    }
    [self transitionFromViewController:self.currentViewController toViewController:self.tacticsListViewController duration:0.75 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{}
                            completion:^(BOOL finished)
     {
         if (finished) {self.currentViewController=self.tacticsListViewController;
         }
     }];
}

- (void)didClickLineUp {
    
    if (self.currentViewController == self.lineUpViewController) {
        return;
    }
    [self.lineUpViewController loadLineUpList];
    [self transitionFromViewController:self.currentViewController toViewController:self.lineUpViewController duration:0.75 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{}
                            completion:^(BOOL finished)
     {
         if (finished) {self.currentViewController=self.lineUpViewController;
         }
     }];
}

@end
