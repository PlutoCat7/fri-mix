//
//  SADataListViewController.m
//  TiHouse
//
//  Created by weilai on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SADataListViewController.h"
#import "SASearchViewController.h"

#import "KnowledgeUtil.h"
#import "SAPageRequest.h"

@interface SADataListViewController ()
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SADataListViewController

- (instancetype)initWithKnowType:(KnowType)knowType knowTypeSub:(KnowTypeSub)knowTypeSub {
    if (self = [super initWithKnowType:knowType knowTypeSub:knowTypeSub]) {

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Action

- (IBAction)actionSearch:(id)sender {
    SASearchViewController *viewController = [[SASearchViewController alloc] initWithKnowType:self.knowType knowTypeSub:self.knowTypeSub];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - private

- (BasePageNetworkRequest *)createRecordPageRequest {
    SAPageRequest *recordPageRequest = [[SAPageRequest alloc] initWithKnowType:self.knowType knowTypeSub:self.knowTypeSub];
    
    return recordPageRequest;
}

- (void)setupUI {
    
    self.title = [KnowledgeUtil nameWithKnowType:self.knowType];
    
    [self.searchView.layer setMasksToBounds:YES];
    [self.searchView.layer setCornerRadius:5.f];
    
    [self setupTableView:_tableView];
}




@end
