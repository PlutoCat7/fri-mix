//
//  HomeViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/7/31.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeHeaderViewController.h"
#import "CatalogDetailViewController.h"
#import "GoodsInfoViewController.h"

#import "HomeSectionHeaderView.h"
#import "HomeTableViewCell.h"
#import "MJRefresh.h"

#import "HomeViewControllerViewModel.h"

@interface HomeViewController ()<HomeTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic, strong) HomeHeaderViewController *headerViewController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) HomeViewControllerViewModel *viewModel;

@end

@implementation HomeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewModel = [[HomeViewControllerViewModel alloc] init];
        @weakify(self)
        [self.yah_KVOController observe:_viewModel keyPath:@"showGoodsList" block:^(id observer, id object, NSDictionary *change) {
           
            @strongify(self)
            [self refreshUI];
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //[self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YHMainHallRightSlideEnableNotification object:nil userInfo:@{@"enable": @(YES)}];
    //解决右滑不能滑出侧边菜单的问题
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:YHMainHallRightSlideEnableNotification object:nil userInfo:@{@"enable": @(NO)}];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.headerViewController.view.frame = CGRectMake(0, 0, kUIScreen_Width, 310*kAppScale);
        self.tableView.tableHeaderView = _headerViewController.view;
    });
    
}

#pragma mark - Action
- (IBAction)leftItemBtnPress:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YHMainHallLeftItemClickNotification object:nil];
}

- (void)rightItemBtnPress {
    
    //弹出下啦菜单
}

- (IBAction)searchBtnPress:(id)sender {
    
    CatalogDetailViewController *vc = [[CatalogDetailViewController alloc] initWithTitle:@"商品列表" firstCid:0 secondCid:0];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private

- (void)loadData {
    
    [self showLoadingToast];
    [self.viewModel getNetworkDataWithHandler:^(NSError *error) {
        [self dismissToast];
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            //刷新界面
            [self refreshUI];
        }
    }];
}

- (void)setupUI {
    
    [self setupTableView];
    [self refreshUI];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeSectionHeaderView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"HomeSectionHeaderView"];
    self.tableView.tableHeaderView = self.headerViewController.view;
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self loadData];
    }];
    self.tableView.mj_header = mj_header;
}

- (void)refreshUI {
    
    //对subview刷新UI
    [self.headerViewController refreshWithBanners:self.viewModel.homeData.bannerList categorys:self.viewModel.homeData.categoryList notice:self.viewModel.homeData.notice];
    [self.tableView reloadData];
}

#pragma mark - Setter And Getter

- (HomeHeaderViewController *)headerViewController {
    
    if (!_headerViewController) {
        _headerViewController = [[HomeHeaderViewController alloc] init];
        [self addChildViewController:_headerViewController];
    }
    
    return _headerViewController;
}

#pragma mark - Delegate
#pragma mark UITableViewDelegate

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.showGoodsList.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
    cell.delegate = self;
    [cell refreshWithData:self.viewModel.showGoodsList[indexPath.row]];
    
    return cell;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 235*kAppScale;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 50*kAppScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    HomeSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HomeSectionHeaderView"];
    
    return headerView;
}

#pragma mark HomeTableViewCell

- (void)didClickCell:(HomeTableViewCell *)cell index:(NSInteger)index {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    HomeGoodsInfo *info = self.viewModel.showGoodsList[indexPath.row][index];
    GoodsInfoViewController *vc = [[GoodsInfoViewController alloc] initWithGoodsId:info.goodsId];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
