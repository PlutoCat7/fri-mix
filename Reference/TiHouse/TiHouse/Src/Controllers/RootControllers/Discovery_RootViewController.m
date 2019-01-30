//
//  Discovery_RootViewController.m
//  YouSuHuoPinDot
//
//  Created by Teen Ma on 2017/11/8.
//  Copyright © 2017年 Teen Ma. All rights reserved.
//

#import "Discovery_RootViewController.h"

#import "SwitchOptionsView.h"
#import "SwitchOptionsViewModel.h"

#import "DiscoverySquareViewController.h"

#import "FindSearchResultViewController.h"
#import "FindAddPreviewViewController.h"
#import "BaseNavigationController.h"

#import "MyNoticedDiscoveryViewController.h"

#define kSegmentedControlWdith 200
#define kSegmentedControlHeight 30

typedef NS_ENUM(NSInteger , TANSPORTSHAREDVIEWCONTROLLERHEADVIEWTYPE) {
    TANSPORTSHAREDVIEWCONTROLLERHEADVIEWTYPE_SQUARETYPE,//动态
    TANSPORTSHAREDVIEWCONTROLLERHEADVIEWTYPE_NOTICE//关注
};

@interface Discovery_RootViewController () <SwitchOptionsViewDelegate>

@property (nonatomic, strong) NSMutableArray *switchOptionsViewModelArray;
@property (nonatomic, strong) SwitchOptionsView *switchOptionView;
@property (nonatomic, strong) UIView         *chooseOptionSegmentedContrtolView;

@property (nonatomic, strong) DiscoverySquareViewController *discoverySquareViewController;
@property (nonatomic, strong) MyNoticedDiscoveryViewController *myNoticedDiscoveryViewController;

@property (nonatomic, strong) BaseViewController *currentChooseViewController;

@end

@implementation Discovery_RootViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUIInterface];
    
    [self setupData];
}

- (void)setupData
{
    [self addChildViewController:self.discoverySquareViewController];
    
    [self.view addSubview:self.discoverySquareViewController.view];
    
    self.currentChooseViewController = self.discoverySquareViewController;
}

- (void)setupUIInterface
{
    self.navigationItem.titleView = self.switchOptionView;
    
    [self.switchOptionsViewModelArray removeAllObjects];
    [self.switchOptionsViewModelArray addObject:[self switchOptionsViewModelWithTitle:@"动态" isChoosed:YES type:TANSPORTSHAREDVIEWCONTROLLERHEADVIEWTYPE_SQUARETYPE]];
    [self.switchOptionsViewModelArray addObject:[self switchOptionsViewModelWithTitle:@"关注" isChoosed:NO type:TANSPORTSHAREDVIEWCONTROLLERHEADVIEWTYPE_NOTICE]];
    [self.switchOptionView resetViewWithArray:self.switchOptionsViewModelArray];
    [self.switchOptionView refreshOptionViewWithIndex:0];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"find_issue"] style:UIBarButtonItemStylePlain target:self action:@selector(issueAction)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"find_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
}

- (NSMutableArray *)switchOptionsViewModelArray
{
    if (!_switchOptionsViewModelArray)
    {
        _switchOptionsViewModelArray = [NSMutableArray array];
    }
    return _switchOptionsViewModelArray;
}

- (BaseViewModel *)switchOptionsViewModelWithTitle:(NSString *)title isChoosed:(BOOL)isChoosed type:(TANSPORTSHAREDVIEWCONTROLLERHEADVIEWTYPE)type
{
    SwitchOptionsViewModel *viewModel = [[SwitchOptionsViewModel alloc] init];
    viewModel.title = title;
    viewModel.cellType = type;
    viewModel.isChoosed = isChoosed;
    return viewModel;
}

- (SwitchOptionsView *)switchOptionView
{
    if (!_switchOptionView)
    {
        _switchOptionView = [[SwitchOptionsView alloc] initWithFrame:CGRectMake(0, 0, 100, kNAVHEIGHT)];
        _switchOptionView.delegate = self;
    }
    return _switchOptionView;
}

#pragma mark SwitchOptionsViewDelegate
- (void)switchOptionsView:(SwitchOptionsView *)view clickOptionWithViewModel:(SwitchOptionsViewModel *)viewModel;
{
    NSInteger index = [self.switchOptionsViewModelArray indexOfObject:viewModel];
    [self.switchOptionView refreshOptionViewWithIndex:index];
    
    BaseViewController *newViewController = nil;
    BOOL shouldChangedValue = NO;
    switch (viewModel.cellType)
    {
        case TANSPORTSHAREDVIEWCONTROLLERHEADVIEWTYPE_SQUARETYPE:
            if (self.currentChooseViewController != self.discoverySquareViewController)
            {
                newViewController = self.discoverySquareViewController;
                shouldChangedValue = YES;
            }
            break;
        case TANSPORTSHAREDVIEWCONTROLLERHEADVIEWTYPE_NOTICE:
            if (self.currentChooseViewController != self.myNoticedDiscoveryViewController)
            {
                newViewController = self.myNoticedDiscoveryViewController;
                shouldChangedValue = YES;
            }
            break;
        default:
            break;
    }
    
    if (shouldChangedValue)
    {
        [self addChildViewController:newViewController];
        [self transitionFromViewController:self.currentChooseViewController toViewController:newViewController duration:0.5 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished){
            if (finished)
            {
                [newViewController didMoveToParentViewController:self];
                [self.currentChooseViewController willMoveToParentViewController:nil];
                [self.currentChooseViewController removeFromParentViewController];
                self.currentChooseViewController = newViewController;
            }
        }];
    }
}

- (DiscoverySquareViewController *)discoverySquareViewController
{
    if (!_discoverySquareViewController)
    {
        _discoverySquareViewController = [[DiscoverySquareViewController alloc] init];
        _discoverySquareViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    return _discoverySquareViewController;
}

- (MyNoticedDiscoveryViewController *)myNoticedDiscoveryViewController
{
    if (!_myNoticedDiscoveryViewController)
    {
        _myNoticedDiscoveryViewController = [[MyNoticedDiscoveryViewController alloc] init];
        _myNoticedDiscoveryViewController.view.frame = self.discoverySquareViewController.view.frame;
    }
    return _myNoticedDiscoveryViewController;
}

- (void)searchAction {
    
    FindSearchResultViewController *vc = [[FindSearchResultViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)issueAction {
    
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:[FindAddPreviewViewController new]];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)dealloc
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

