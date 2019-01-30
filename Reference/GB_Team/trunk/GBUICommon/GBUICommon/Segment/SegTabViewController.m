//
//  SegTabViewController.m
//  GBUICommon
//
//  Created by weilai on 16/9/9.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "SegTabViewController.h"
#import "SegmentView.h"

@interface SegTabViewController () <SegmentViewDelegate>

@property (nonatomic,strong) SegmentView *segmentView;

@property (nonatomic,strong) NSArray<SegPageViewController*>* controllerArray;
@property (nonatomic,strong) NSArray<NSString*>* titleArray;

@end

@implementation SegTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protected
- (void)setupUI {
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.segmentView == nil) {
        CGRect rect = self.view.bounds;
        self.controllerArray = [self viewControllerArray];
        self.titleArray = [self viewTitleArray];
        
        self.segmentView = [[SegmentView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)
                                                   topHeight:68.f
                                             viewControllers:self.controllerArray
                                                      titles:self.titleArray
                                                    delegate:self];
        [self.view addSubview:self.segmentView];
        
        for (SegPageViewController *viewController in self.controllerArray) {
            [self addChildViewController:viewController];
        }
    }
}

-(NSArray<SegPageViewController*>*) viewControllerArray {
    NSAssert(0, @"设置Controller数组，子类必须重写");
    
    return nil;
}

-(NSArray<NSString*>*) viewTitleArray {
    NSAssert(0, @"设置Title数组，子类必须重写");
    
    return nil;
}


#pragma mark - delegate
- (void)SegmentView:(SegmentView*)segment fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    SegPageViewController *toController = self.controllerArray[toIndex];
    if (!toController.isInitLoadData) {
        [toController viewPageDidLoad];
    }
    
    if (fromIndex >= 0 && fromIndex < [self.controllerArray count]) {
        SegPageViewController *fromeController = self.controllerArray[fromIndex];
        [fromeController viewPageDidDisappear];
    }
    
    [toController viewPageDidAppear];
}

- (void)SegmentView:(SegmentView*)segment fromeController:(SegPageViewController*)fromeController toController:(SegPageViewController*)toController {
    if (!toController.isInitLoadData) {
        [toController viewPageDidLoad];
    }
    
    if (fromeController) {
        [fromeController viewPageDidDisappear];
    }
    
    [toController viewPageDidAppear];
}

@end
