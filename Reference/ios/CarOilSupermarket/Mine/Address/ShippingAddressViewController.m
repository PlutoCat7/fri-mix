//
//  ShippingAddressViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/30.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "ShippingAddressViewController.h"
#import "AddAddressViewController.h"

#import "MJRefresh.h"
#import "ShippingAddressTableViewCell.h"
#import "ShippingAdressFooterView.h"

#import "ShoppingAddressViewModel.h"

@interface ShippingAddressViewController ()<
UITableViewDelegate,
UITableViewDataSource,
ShippingAdressFooterViewDelegate,
ShippingAddressTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ShoppingAddressViewModel *viewModel;

@property (nonatomic, copy) void(^selectBlock)(AddressInfo *info);

@end

@implementation ShippingAddressViewController

- (instancetype)init
{
    return [self initWithSelectBlock:nil];
}

- (instancetype)initWithSelectBlock:(void(^)(AddressInfo *info))block {
    
    self = [super init];
    if (self) {
        _selectBlock = block;
        _viewModel = [[ShoppingAddressViewModel alloc] init];
        @weakify(self)
        [self.yah_KVOController observe:_viewModel keyPath:@"cellModels" block:^(id observer, id object, NSDictionary *change) {
            
            @strongify(self)
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = @"收货地址";
    [self setupBackButtonWithBlock:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShippingAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShippingAddressTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShippingAdressFooterView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"ShippingAdressFooterView"];
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.viewModel getAddressList:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    self.tableView.mj_header = mj_header;
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.viewModel.cellModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 158*kAppScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 50.0f*kAppScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressModel *model = self.viewModel.cellModels[indexPath.row];
    ShippingAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShippingAddressTableViewCell"];
    cell.delegate = self;
    [cell refreshWithAddressModel:model];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    ShippingAdressFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ShippingAdressFooterView"];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.delegate = self;
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectBlock) {
        BLOCK_EXEC(self.selectBlock, [self.viewModel addressInfoWithIndexPath:indexPath]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didClickShippingAdressFooterView {
    
    AddAddressViewController *vc = [[AddAddressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickDefaultCell:(ShippingAddressTableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self showLoadingToast];
    @weakify(self)
    [self.viewModel setDefaultAddressWithIndexPath:indexPath handler:^(NSError *error) {
        @strongify(self)
        [self dismissToast];
    }];
}
- (void)didClickEditCell:(ShippingAddressTableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    AddressModel *model = self.viewModel.cellModels[indexPath.row];
    [self.navigationController pushViewController:[[AddAddressViewController alloc] initWithAddressModel:model] animated:YES];
}

- (void)didClickDeleteCell:(ShippingAddressTableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self showLoadingToast];
    @weakify(self)
    [self.viewModel deleteAddressWithIndexPath:indexPath handler:^(NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (!error) {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}

@end
