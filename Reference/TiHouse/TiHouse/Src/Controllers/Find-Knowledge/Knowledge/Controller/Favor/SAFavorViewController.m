 //
//  SAFavorViewController.m
//  TiHouse
//
//  Created by weilai on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SAFavorViewController.h"

#import "SAFavorPageRequest.h"
#import "KnowledgeUtil.h"

@interface SAFavorViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SAFavorViewController

- (instancetype)initWithKnowType:(KnowType)knowType knowTypeSub:(KnowTypeSub)knowTypeSub {
    if (self = [super initWithKnowType:knowType knowTypeSub:knowTypeSub]) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - private

- (BasePageNetworkRequest *)createRecordPageRequest {
    SAFavorPageRequest *recordPageRequest = [[SAFavorPageRequest alloc] initWithKnowTypeSub:self.knowTypeSub];
    
    return recordPageRequest;
}

- (void)setupUI {
    
    self.title = self.knowTypeSub == KnowTypeSub_Size ? @"收藏的尺寸" : @"收藏的风水";
    
    [self setupTableView:_tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}



@end
