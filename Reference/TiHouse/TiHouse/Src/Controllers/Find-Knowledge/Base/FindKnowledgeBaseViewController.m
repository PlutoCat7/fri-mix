//
//  FindBaseViewController.m
//  TiHouse
//
//  Created by yahua on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindKnowledgeBaseViewController.h"

@interface FindKnowledgeBaseViewController ()

@end

@implementation FindKnowledgeBaseViewController

- (void)dealloc
{
    NSLog(@"dealloc %@", [self description]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self setupUI];
    [self loadNetworkData];
    [self setupLayoutConstraint:self.view];
    
}

#pragma mark - Public

- (void)loadData {
    
}

- (void)setupUI {
    
}

- (void)loadNetworkData {
    
}

#pragma mark - Private

#define IPHONEX_Layout_TopConstraint @"Layout_TopConstraint"

- (void)setupLayoutConstraint:(UIView *)view {
    
    //iphoneX 适配
    NSArray<NSLayoutConstraint *> *arr = [view constraints];
    for (NSLayoutConstraint *constraint in arr) {
        if([IPHONEX_Layout_TopConstraint isEqualToString:constraint.identifier]){
            constraint.constant = kDevice_Is_iPhoneX?88:64;
            return;
        }
    }
    for (UIView *subView in view.subviews) {
        [self setupLayoutConstraint:subView];
    }
}

@end
