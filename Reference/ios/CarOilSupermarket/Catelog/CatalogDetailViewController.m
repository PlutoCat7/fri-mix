//
//  CatalogDetailViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/10.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "CatalogDetailViewController.h"
#import "HomeViewController.h"
#import "GoodsInfoViewController.h"

#import "CatalogDetailCollectionViewCell.h"
#import "MJRefresh.h"
#import "UIScrollView+COSEmpty.h"

#import "CatalogDetailViewModel.h"

@interface CatalogDetailViewController () <UICollectionViewDelegate,
UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) CatalogDetailViewModel *viewModel;

@end

@implementation CatalogDetailViewController

- (instancetype)initWithTitle:(NSString *)title firstCid:(NSInteger)firstCid secondCid:(NSInteger)secondCid {
    
    self = [super init];
    if (self) {
        _viewModel = [[CatalogDetailViewModel alloc] initWithTitle:title firstCid:firstCid secondCid:secondCid];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.collectionView.mj_header beginRefreshing];
    
    @weakify(self)
    [self.yah_KVOController observe:self.viewModel keyPath:@"goodsList" block:^(id observer, id object, NSDictionary *change) {
        
        @strongify(self)
        [self.collectionView reloadData];
        [self.collectionView showEmptyView:self.viewModel.goodsList.count==0];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[HomeViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

#pragma mark - Action
- (IBAction)actionSale:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    self.viewModel.saleType = button.selected?CatalogDetailSortType_Asc:CatalogDetailSortType_Desc;
}

- (IBAction)actionPrice:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    self.viewModel.priceType = button.selected?CatalogDetailSortType_Asc:CatalogDetailSortType_Desc;
}
#pragma mark - Private

- (void)setupUI {
    
    self.title = self.viewModel.title;
    [self setupBackButtonWithBlock:nil];
    
    [self setupCollectionView];
}

- (void)setupCollectionView {
    
    self.collectionView.contentInset = UIEdgeInsetsMake(6*kAppScale, 0, 6*kAppScale, 0);
    [self.collectionView registerNib:[UINib nibWithNibName:@"CatalogDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CatalogDetailCollectionViewCell"];
    CGSize itemSize = CGSizeMake(kCatalogDetailCollectionViewCellWidth, kCatalogDetailCollectionViewCellHeight);
    _flowLayout.minimumInteritemSpacing = kUIScreen_Width-2*kCatalogDetailCollectionViewCellWidth;
    _flowLayout.minimumLineSpacing = _flowLayout.minimumInteritemSpacing;
    [_flowLayout setItemSize:itemSize];
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.viewModel getFirstPageDataWithHandler:^(NSError *error) {
            
            [self handlerRequestWithError:error];
        }];
    }];
    self.collectionView.mj_header = mj_header;
}

- (void)handlerRequestWithError:(NSError *)error {
    
    [self.collectionView.mj_header endRefreshing];
    if (error) {
        [self showToastWithText:error.domain];
    }
}

#pragma mark - Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.goodsList.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CatalogDetailCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"CatalogDetailCollectionViewCell" forIndexPath:indexPath];
    HomeGoodsInfo *info = self.viewModel.goodsList[indexPath.row];
    [item refreshWithData:info];
    
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.viewModel.isLoadEnd &&
        self.viewModel.goodsList.count-1 == indexPath.row) {
        [self.viewModel getNextPageDataWithHandler:^(NSError *error) {
            
            [self handlerRequestWithError:error];
        }];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeGoodsInfo *info = self.viewModel.goodsList[indexPath.row];
    GoodsInfoViewController *vc = [[GoodsInfoViewController alloc] initWithGoodsId:info.goodsId];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
