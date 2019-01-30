//
//  GBFieldBaseViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/17.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBFieldBaseViewController.h"
#import "GBMyFieldListViewController.h"
#import "GBSystemFieldListViewController.h"
#import "GBSegmentView.h"
#import "GBActionSheet.h"
#import "GBSatelliteViewController.h"
#import "GBFourCornerViewController.h"

@interface GBFieldBaseViewController ()<
GBSegmentViewDelegate>

@property (nonatomic,strong) GBSegmentView *segmentView;
@property (nonatomic,strong) GBMyFieldListViewController     *myViewController;
@property (nonatomic,strong) GBSystemFieldListViewController *systemViewController;


@property (nonatomic, assign) NSInteger startPageIndex;

@end

@implementation GBFieldBaseViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

#pragma mark - Life Cycle

- (instancetype)initWithPageIndex:(NSInteger)pageIndex {
    
    self = [super init];
    if (self) {
        _startPageIndex = pageIndex;
    }
    return self;
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Court;
}

#pragma mark - Notification

#pragma mark - Delegate

- (void)GBSegmentView:(GBSegmentView*)segment toIndex:(NSInteger)index
{
    if (index == 0) {
        [self.myViewController clearSearchResult];
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }else {
        [self.systemViewController clearSearchResult];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"add"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAction)] animated:YES];
    }
}

- (void)GBSegmentView:(GBSegmentView *)segment toViewController:(PageViewController *)viewController {
    
    if ([viewController isKindOfClass:[GBSystemFieldListViewController class]]) {
        [self.myViewController clearSearchResult];
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }else {
        [self.systemViewController clearSearchResult];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"add"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAction)] animated:YES];
    }
    
    [viewController initLoadData];
}

#pragma mark - Action

- (void)rightBarAction {
    
    [UMShareManager event:Analy_Click_Court_Add];
    
    [GBActionSheet showWithTitle:LS(@"create.popbox.title")
                         button1:LS(@"create.popbox.item.map")
                         button2:LS(@"create.popbox.item.corner")
                          cancel:LS(@"common.btn.cancel")
                          handle:^(NSInteger index) {
                              if (index == 0) {
                                  [UMShareManager event:Analy_Click_Court_Map];
                                  
                                  [self.navigationController pushViewController:[[GBSatelliteViewController alloc]init] animated:YES];
                              }else if (index == 1) {
                                  [UMShareManager event:Analy_Click_Court_Gps];
                                  
                                  [self.navigationController pushViewController:[[GBFourCornerViewController alloc]init] animated:YES];
                              }
                          }];
}

#pragma mark - Private

-(void)setupUI
{
    self.title = LS(@"create.nav.title");
    [self setupBackButtonWithBlock:nil];

    self.myViewController    = [[GBMyFieldListViewController alloc]init];
    self.systemViewController = [[GBSystemFieldListViewController alloc]init];
    CGRect rect = [UIScreen mainScreen].bounds;
    self.segmentView = [[GBSegmentView alloc]initWithFrame:CGRectMake(0,kUIScreen_NavigationBarHeight, rect.size.width,kUIScreen_AppContentHeight)
                                                 topHeight:54.f
                                           viewControllers:@[self.systemViewController, self.myViewController]
                                                    titles:@[LS(@"create.tab.system"), LS(@"create.tab.my")]
                                                  delegate:self];
    self.segmentView.isNeedDelete = YES;
    [self.view addSubview:self.segmentView];
    [self addChildViewController:self.myViewController];
    [self addChildViewController:self.systemViewController];
    
    [self.segmentView goCurrentController:self.startPageIndex];
}

@end
