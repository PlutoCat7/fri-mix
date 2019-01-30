//
//  FindSearchTabViewController.m
//  TiHouse
//
//  Created by weilai on 2018/4/16.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindSearchTabViewController.h"
#import "FindWaterfallViewController.h"
#import "FindSearchArtViewController.h"

#import "SearchSegmentView.h"

@interface FindSearchTabViewController () <SearchSegmentViewDelegate>

@property (weak, nonatomic) IBOutlet SearchSegmentView *searchSegmentView;
@property (weak, nonatomic) IBOutlet UIView *waterfallContainerView;

@property (nonatomic, strong) FindWaterfallViewController *waterfallViewController;
@property (nonatomic, strong) FindSearchArtViewController *artViewController;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation FindSearchTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.waterfallContainerView) {
            self.waterfallViewController.view.frame = self.waterfallContainerView.bounds;
        }
        
        if (self.artViewController) {
            self.artViewController.view.frame = self.waterfallContainerView.bounds;
        }
        
    });

}

#pragma mark - Private

-(void)setupUI
{
    self.searchSegmentView.delegate = self;
    
    self.waterfallViewController   = [[FindWaterfallViewController alloc]init];
    self.artViewController = [[FindSearchArtViewController alloc] init];
  
    [self addChildViewController:self.waterfallViewController];
    [self addChildViewController:self.artViewController];
    
    self.waterfallViewController.view.frame = self.waterfallContainerView.bounds;
    self.artViewController.view.frame = self.waterfallContainerView.bounds;
    
    [self.waterfallContainerView addSubview:self.waterfallViewController.view];
    self.currentIndex = 0;
    
}

- (void)reSearchWithName:(NSString *)name {
    
    if (self.waterfallViewController) {
        [self.waterfallViewController reSearchWithName:name];
    }
    
    if (self.artViewController) {
        [self.artViewController reSearchWithName:name];
    }
}

#pragma mark - SearchSegmentViewDelegate

- (void)searchSegmentViewMenuChange:(SearchSegmentView *)view Index:(NSInteger)index {
    if (index == self.currentIndex) {
        return;
    }
    
    NSArray<UIView *> *viewArray = self.waterfallContainerView.subviews;
    for (UIView *subView in viewArray) {
        [subView removeFromSuperview];
    }
    
    self.currentIndex = index;
    if (self.currentIndex  == 0) {
        [self.waterfallContainerView addSubview:self.waterfallViewController.view];
    } else if (self.currentIndex  == 1) {
        [self.waterfallContainerView addSubview:self.artViewController.view];
    }
    
}

@end
