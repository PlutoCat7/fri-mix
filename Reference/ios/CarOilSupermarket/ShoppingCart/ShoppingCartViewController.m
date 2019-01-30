//
//  ShoppingCartViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/7/31.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "MakeOrderViewController.h"

#import "MJRefresh.h"
#import "ShoppingCartTableViewCell.h"
#import "ShoppingCartSectionHeaderView.h"
#import "ShoppingEmptyView.h"

#import "ShoppingCartViewModel.h"

@interface ShoppingCartViewController () <
UITableViewDelegate,
UITableViewDataSource,
ShoppingEmptyViewDelegate,
ShoppingCartTableViewCellDelegate,
ShoppingCartSectionHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ShoppingEmptyView *emptyView;
@property (nonatomic, strong) UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIView *settlementView;
@property (weak, nonatomic) IBOutlet UIButton *allSelectButton;
@property (weak, nonatomic) IBOutlet UILabel *totalStaticLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *makeButton;

@property (nonatomic, strong) ShoppingCartViewModel *viewModel;

@end

@implementation ShoppingCartViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewModel = [[ShoppingCartViewModel alloc] init];
        @weakify(self)
        [self.yah_KVOController observe:_viewModel keyPath:@"cellModels" block:^(id observer, id object, NSDictionary *change) {
            
            @strongify(self)
            self.title = [_viewModel shoppingTitle];
            self.emptyView.hidden = !(self.viewModel.cellModels.count == 0);
            self.settlementView.hidden = !self.emptyView.hidden;
            [self refreshSettlementView];
            [self setupRightButton];
            
            [self.tableView reloadData];
        }];
        
        [self.yah_KVOController observe:_viewModel keyPath:@"errorMsg" block:^(id observer, id object, NSDictionary *change) {
            
            @strongify(self)
            [self showToastWithText:self.viewModel.errorMsg];
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    //解决右滑不能滑出侧边菜单的问题
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - Action

- (void)actionEdit {
    
    if (!self.viewModel.isEdit) {
        [self.viewModel startEdit];
        [self.saveButton setTitle:@"完成" forState:UIControlStateNormal];
    }else {
        [self.viewModel cancelEdit];
        [self.saveButton setTitle:@"编辑" forState:UIControlStateNormal];
    }
}
- (IBAction)actionAllSelect:(id)sender {
    
    [self.viewModel selectAll];
}

//结算
- (IBAction)actionMake:(id)sender {
    
    if (self.viewModel.isEdit) {
        @weakify(self)
        [self showLoadingToast];
        [self.viewModel deleteGoodsWithHandler:^(NSError *error) {
            
            @strongify(self)
            [self dismissToast];
        }];
    }else {
        
        @weakify(self)
        [self showLoadingToast];
        [self.viewModel buyGoodsWithHandler:^(id data) {
            
            @strongify(self)
            [self dismissToast];
            if (data) {
                
                MakeOrderViewController *vc = [[MakeOrderViewController alloc] initWithConfirmOrderInfo:data];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
}
#pragma mark - Private

- (void)setupUI {
    
    self.title = [_viewModel shoppingTitle];
    if (self.navigationController.viewControllers.count>1) {
        [self setupBackButtonWithBlock:nil];
    }
    [self setupRightButton];
    [self setupTableView];
    [self setupSettlementView];
    
    self.emptyView.delegate = self;
}

- (void)setupRightButton {
    
    if (self.viewModel.cellModels.count==0) {
        [self.navigationItem setRightBarButtonItem:nil];
        return;
    }
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setSize:CGSizeMake(48, 24)];
    [self.saveButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [self.saveButton setTitle:self.viewModel.isEdit?@"完成":@"编辑" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveButton.backgroundColor = [UIColor clearColor];
    [self.saveButton addTarget:self action:@selector(actionEdit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)setupTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ShoppingCartTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShoppingCartTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShoppingCartSectionHeaderView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"ShoppingCartSectionHeaderView"];
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.viewModel getNetData:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    self.tableView.mj_header = mj_header;
}

- (void)setupSettlementView {
    
    [self.makeButton setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
    [self.makeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xFD6140]] forState:UIControlStateNormal];
}

- (void)refreshSettlementView {
    
    if (self.viewModel.isEdit) {
        self.allSelectButton.selected = [self.viewModel isSelectAllDeleteCell];
        self.totalStaticLabel.hidden = YES;
        self.totalPriceLabel.hidden = YES;
        self.makeButton.enabled = [self.viewModel isSelectDeleteCell];
        [self.makeButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.makeButton setTitle:@"删除" forState:UIControlStateDisabled];
    }else {
        self.allSelectButton.selected = [self.viewModel isSelectAllCell];
        self.totalStaticLabel.hidden = NO;
        self.totalPriceLabel.hidden = NO;
        self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [self.viewModel selectGoodsPrice]];
        self.makeButton.enabled = [self.viewModel isSelectCell];
        [self.makeButton setTitle:@"结算" forState:UIControlStateNormal];
        [self.makeButton setTitle:@"结算" forState:UIControlStateDisabled];
    }
}

#pragma mrak - delegate
#pragma mark ShoppingEmptyViewDelegate

- (void)didClickLookup {
    
    //去看看
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ShowCatalogView object:nil];
}

#pragma mark ShoppingCartSectionHeaderViewDelegate

- (void)didClickSelectAll:(ShoppingCartSectionHeaderView *)headerView {
    
    [self.viewModel selectAll];
}

#pragma mark ShoppingCartTableViewCellDelegate

- (void)addGoodsQuantityWithCell:(ShoppingCartTableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self showLoadingToast];
    @weakify(self)
    [self.viewModel addGoodsQuantityWithIndexPath:indexPath count:1 handler:^(NSError *error) {
        @strongify(self)
        if (!error) {
            [self dismissToast];
        }
    }];
}
- (void)reduceGoodsQuantityWithCell:(ShoppingCartTableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self showLoadingToast];
    @weakify(self)
    [self.viewModel reduceGoodsQuantityWithIndexPath:indexPath count:1 handler:^(NSError *error) {
        @strongify(self)
        if (!error) {
            [self dismissToast];
        }
    }];
}

- (void)changeGoodsQuantityWithCell:(ShoppingCartTableViewCell *)cell count:(NSInteger)count {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self showLoadingToast];
    @weakify(self)
    [self.viewModel changeGoodsQuantityWithIndexPath:indexPath count:count handler:^(NSError *error) {
        
        @strongify(self)
        if (!error) {
            [self dismissToast];
        }else {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)goodDidSelectWithCell:(ShoppingCartTableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.viewModel selectWithIndexPath:indexPath];
}

#pragma mark  Table Delegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.viewModel.cellModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 95.0f * kAppScale;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShoppingCartModel *model = self.viewModel.cellModels[indexPath.row];
    ShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingCartTableViewCell"];
    cell.delegate = self;
    [cell refreshWithModel:model];
    
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    ShoppingCartSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ShoppingCartSectionHeaderView"];
//    headerView.contentView.backgroundColor = [UIColor whiteColor];
//    headerView.delegate = self;
//    if (self.viewModel.isEdit) {
//        headerView.selectButton.selected = [self.viewModel isSelectAllDeleteCell];
//    }else {
//        headerView.selectButton.selected = [self.viewModel isSelectAllCell];
//    }
//    return headerView;
//}


@end
