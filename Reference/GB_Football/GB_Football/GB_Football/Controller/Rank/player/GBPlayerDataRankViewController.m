//
//  GBPlayerDataRankViewController.m
//  GB_Football
//
//  Created by gxd on 2017/11/29.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBPlayerDataRankViewController.h"
#import "GBPlayerBaseRankViewController.h"
#import "SINavigationMenuView.h"
#import "GBMenuViewController.h"

@interface GBPlayerDataRankViewController () <SINavigationMenuDelegate>

@property (nonatomic, strong) NSMutableArray<GBPlayerBaseRankViewController *> *controllerArray;
@property (nonatomic,strong) SINavigationMenuView           *navBarMenu;
@property (nonatomic,strong) GBPlayerBaseRankViewController   *currentViewController;
    
@end

@implementation GBPlayerDataRankViewController

#pragma mark -
#pragma mark Memory

- (instancetype)init {
    if (self = [super init]) {
        _controllerArray = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

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
    
    for (GBPlayerBaseRankViewController *controller in self.controllerArray) {
    
        controller.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }

}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Card_Index;
}
    
#pragma mark - Delegate

- (void)didSelectItemAtIndex:(NSUInteger)index
{
    if (index < self.controllerArray.count && self.currentViewController == self.controllerArray[index]) {
        return;
    }
    
    [self transitionFromViewController:self.currentViewController toViewController:self.controllerArray[index] duration:1 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{}
                            completion:^(BOOL finished)
     {
         if (finished) {
             self.currentViewController = self.controllerArray[index];
             [self.currentViewController initLoadData];
         }
     }];
}

#pragma mark - Private
    
-(void)setupUI
{
    [self setupNavBar];
    [self setupViewControllers];
}

-(void)setupNavBar
{
    self.title = LS(@"starcard.label.index");
    [self setupBackButtonWithBlock:nil];
    /*
    if (self.navigationItem)
    {
        CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
        self.navBarMenu = [[SINavigationMenuView alloc] initWithFrame:frame title:LS(@"starcard.label.index")];
        self.navBarMenu.items = @[LS(@"starcard.label.index"), LS(@"starcard.label.speed"), LS(@"starcard.label.endur"), LS(@"starcard.label.erupt"), LS(@"starcard.label.sprint"), LS(@"starcard.label.distance"), LS(@"starcard.label.area")];
        self.navBarMenu.delegate = self;
        self.navigationItem.titleView = self.navBarMenu;
        [self.navBarMenu displayMenuInView:self.navigationController.view];
    }
    @weakify(self)
    [self setupBackButtonWithBlock:^{
        
        @strongify(self)
        [self.navBarMenu remove];
    }];
     */
}

-(void)setupViewControllers
{

    [self.controllerArray addObject:[[GBPlayerBaseRankViewController alloc]initWithType:PlayerRank_Score]];
//    [self.controllerArray addObject:[[GBPlayerBaseRankViewController alloc]initWithType:PlayerRank_Speed]];
//    [self.controllerArray addObject:[[GBPlayerBaseRankViewController alloc]initWithType:PlayerRank_Endur]];
//    [self.controllerArray addObject:[[GBPlayerBaseRankViewController alloc]initWithType:PlayerRank_Erupt]];
//    [self.controllerArray addObject:[[GBPlayerBaseRankViewController alloc]initWithType:PlayerRank_Sprint]];
//    [self.controllerArray addObject:[[GBPlayerBaseRankViewController alloc]initWithType:PlayerRank_Distance]];
//    [self.controllerArray addObject:[[GBPlayerBaseRankViewController alloc]initWithType:PlayerRank_Area]];

    for (GBPlayerBaseRankViewController *controller in self.controllerArray) {
        [self addChildViewController:controller];
        
        controller.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }
    
    // 指定当前控制器
    [self.view addSubview:self.controllerArray[0].view];
    self.currentViewController = self.controllerArray[0];
    
    [self.currentViewController initLoadData];
}

-(void)loadData
{
    
}
@end
