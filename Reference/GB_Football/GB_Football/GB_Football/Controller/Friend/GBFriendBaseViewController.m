//
//  GBFriendBaseViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBFriendBaseViewController.h"
#import "GBSegmentView.h"
#import "GBMyFriendViewController.h"
#import "GBAdressBookViewController.h"
#import "GBMenuViewController.h"

#import "FriendRequest.h"
#import "AddressBookObject.h"

@interface GBFriendBaseViewController ()<
GBSegmentViewDelegate>

@property (nonatomic, strong) UIButton *rightBarItem;
@property (nonatomic,strong) GBSegmentView *segmentView;
@property (nonatomic,strong) GBMyFriendViewController   *myFriendViewController;
@property (nonatomic,strong) GBAdressBookViewController *addressBookViewController;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation GBFriendBaseViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.segmentView goCurrentController:self.currentIndex];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myFriendListChangeNotificetion:) name:MyFirenCountChangeNotification object:nil];
}

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

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}

#pragma mark - Public 

- (void)goToNewFriend {
    
    self.currentIndex = 1;
    [self.segmentView goCurrentController:self.currentIndex];
}

#pragma mark - Notification

- (void)myFriendListChangeNotificetion:(NSNotification *)notification {
    
    @try {
        NSInteger friendCoutn = [notification.object integerValue];
        [self.segmentView setTitle:[NSString stringWithFormat:@"%td%@", friendCoutn,LS(@"friend.tab.friends")] index:0];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

#pragma mark - Delegate

- (void)GBSegmentView:(GBSegmentView *)segment toViewController:(PageViewController *)viewController {
    
    if ([viewController isKindOfClass:[GBMyFriendViewController class]]) {
        [self.addressBookViewController clearSearchResult];
    }else {
        [self.myFriendViewController clearSearchResult];
    }
    
    [viewController initLoadData];
}

#pragma mark - Private

-(void)setupUI
{
    self.title = LS(@"friend.nav.title");
    [self setupBackButtonWithBlock:nil];
   
    self.myFriendViewController    = [[GBMyFriendViewController alloc]init];
    self.addressBookViewController = [[GBAdressBookViewController alloc]init];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    self.segmentView = [[GBSegmentView alloc]initWithFrame:CGRectMake(0,kUIScreen_NavigationBarHeight, rect.size.width,kUIScreen_AppContentHeight)
                                                 topHeight:54.f
                                           viewControllers:@[self.myFriendViewController,self.addressBookViewController]
                                                    titles:@[LS(@"friend.tab.0friend"),LS(@"friend.tab.myfriend")]
                                                  delegate:self];
    self.segmentView.isNeedDelete = NO;
    self.segmentView.scrollerEnable = NO;
    [self.view addSubview:self.segmentView];
    [self addChildViewController:self.myFriendViewController];
    [self addChildViewController:self.addressBookViewController];
    
}

#pragma mark - Getters & Setters

@end
