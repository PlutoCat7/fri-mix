//
//  GBCoursePageViewController.m
//  GB_Football
//
//  Created by Pizza on 2017/3/10.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBCoursePageViewController.h"
#import "SDCycleScrollView.h"
#import "AppDelegate.h"
#import "GBPopAnimateTool.h"
#import "GBMenuViewController.h"
#import "NoRemindManager.h"

#define kMaxPageCount 7

@interface GBCoursePageViewController ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *pageView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *seeAgainButton;
@property (assign,nonatomic) NSInteger currentIndex;
@end

@implementation GBCoursePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (!IS_IPHONE_X) {
        [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

-(void)setupUI{
    [self UICoursePage];
    [NoRemindManager sharedInstance].tutorialPagesV1 = YES;
}


- (void)UICoursePage{
    self.currentIndex = 0;
    NSMutableArray *imageList = [NSMutableArray arrayWithCapacity:kMaxPageCount];
    for (int i = 1 ; i < kMaxPageCount+1 ; i++) {
        [imageList addObject:[NSString stringWithFormat:@"tutorial%d",i]];
    }
    self.pageView.localizationImageNamesGroup = [imageList copy];
    self.pageView.autoScrollTimeInterval = MAXFLOAT;
    self.pageView.showPageControl = NO;
    self.pageView.delegate = self;
    self.pageView.infiniteLoop = NO;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    [self.pageView scrollToIndex:(int)(index+1)];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    if (index == (kMaxPageCount-1) && self.currentIndex == (kMaxPageCount-2)) {
        [GBPopAnimateTool popAppearFromMini:self.closeButton beginTime:0 completionBlock:nil];
        [GBPopAnimateTool popFade:self.closeButton fade:NO repeat:NO duration:0.3 beginTime:0 completionBlock:nil];
        [GBPopAnimateTool popAppearFromMini:self.seeAgainButton beginTime:0.3 completionBlock:nil];
        [GBPopAnimateTool popFade:self.seeAgainButton fade:NO repeat:NO duration:0.3 beginTime:0.3 completionBlock:nil];
    }
    else if(index == (kMaxPageCount-1) && self.currentIndex == (kMaxPageCount-1)){
        self.closeButton.alpha = 1;
        self.seeAgainButton.alpha = 1;
    }
    else{
        self.closeButton.alpha = 0;
        self.seeAgainButton.alpha = 0;
    }
    self.currentIndex = index;
}
- (IBAction)actionClose:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ShowMainView object:nil];
}

- (IBAction)actionAgain:(id)sender {
    [self.pageView scrollToIndex:0];
}

@end
