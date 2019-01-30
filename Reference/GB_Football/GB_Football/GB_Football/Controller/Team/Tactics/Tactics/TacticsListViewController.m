//
//  TacticsListViewController.m
//  GB_Football
//
//  Created by yahua on 2018/1/12.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "TacticsListViewController.h"
#import "TacticsViewController.h"

#import "MJRefresh.h"
#import "TacticsListCell.h"
#import "GBBaseViewController+Empty.h"

#import "TacticsListViewModel.h"

@interface TacticsListViewController () <UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//静态
@property (weak, nonatomic) IBOutlet UILabel *addTacticsLabel;

@property (nonatomic, strong) TacticsListViewModel *viewModel;

@end

@implementation TacticsListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewModel = [[TacticsListViewModel alloc] init];
        
        @weakify(self)
        [self.yah_KVOController observe:_viewModel keyPath:@"cellModels" block:^(id observer, id object, NSDictionary *change) {
            
            @strongify(self)
            self.isShowEmptyView = self.viewModel.cellModels.count == 0;
            [self.tableView reloadData];
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableView];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Action

- (IBAction)actionAddTactics:(id)sender {
    
    TacticsViewController *vc = [[TacticsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private

-(void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"TacticsListCell" bundle:nil] forCellReuseIdentifier:@"TacticsListCell"];
    self.tableView.rowHeight = 90*kAppScale;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.emptyScrollView = self.tableView;
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        @strongify(self)
        [self.viewModel getFirstPageListWithBlock:^(NSError *error) {
            
            [self.tableView.mj_header endRefreshing];
            if (error) {
                [self showToastWithText:error.domain];
            }
        }];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_header = mj_header;
}

#pragma mark TableViewDelegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.cellModels.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TacticsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TacticsListCell"];
    TacticsListCellModel *model = self.viewModel.cellModels[indexPath.row];
    [cell refreshWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TeamTacticsInfo *info = [self.viewModel tacticsInfoWithIndex:indexPath.row];
    TacticsViewController *vc = [[TacticsViewController alloc] initWithTacticsInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.viewModel.cellModels.count-1 == indexPath.row) {
        @weakify(self)
        [self.viewModel getNextPageListWithBlock:^(NSError *error) {
            @strongify(self)
            if (error) {
                [self showToastWithText:error.domain];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self setEditing:false animated:true];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {

    @weakify(self)
    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath)
    {

        @strongify(self)
        [self showLoadingToast];
        [self.viewModel deleteTacticsWithIndex:indexPath.row block:^(NSError *error) {
            [self dismissToast];
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                [self.tableView reloadData];
            }
        }];
    };
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:LS(@"common.btn.delete") handler:rowActionHandler];
    return @[action];
}

@end
