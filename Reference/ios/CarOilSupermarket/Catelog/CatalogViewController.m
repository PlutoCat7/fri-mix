//
//  CatalogViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/7/31.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "CatalogViewController.h"

#import "CatalogCollectionReusableView.h"
#import "CatalogCollectionViewCell.h"
#import "MJRefresh.h"

#import "CatalogViewModel.h"

@interface CatalogViewController ()<CatalogCollectionReusableViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
CatalogCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) CatalogViewModel *viewModel;

@end

@implementation CatalogViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        @weakify(self)
        [self.yah_KVOController observe:self.viewModel keyPath:@"datas" block:^(id observer, id object, NSDictionary *change) {
            
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

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    //解决右滑不能滑出侧边菜单的问题
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - Private

- (void)loadData {
    
    [self showLoadingToast];
    [self.viewModel getNetworkDataWithHandler:^(NSError *error) {
        [self dismissToast];
        [self.collectionView.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
        }
    }];
}

- (void)setupUI {
    
    self.title = @"分类";
    
    [self setupCollectionView];
    [self refreshUI];
}

- (void)setupCollectionView {
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CatalogCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CatalogCollectionReusableView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CatalogCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CatalogCollectionViewCell"];
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self loadData];
    }];
    self.collectionView.mj_header = mj_header;
}

- (void)refreshUI {
    
    [self.collectionView reloadData];
}

#pragma mark - Setter and Getter

- (CatalogViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[CatalogViewModel alloc] init];
    }
    
    return _viewModel;
}

#pragma mark - Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    CatalogModel *model = self.viewModel.datas[section];
    if (model.expand) {
        return 1;
    }else {
        return 0;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return self.viewModel.datas.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CatalogCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CatalogCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.contentView.backgroundColor = [UIColor clearColor];
    CatalogModel *model = self.viewModel.datas[indexPath.section];
    cell.items = model.subCatalogs;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        CatalogCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CatalogCollectionReusableView" forIndexPath:indexPath];
        headerView.delegate = self;
        headerView.section = indexPath.section;
        
        CatalogModel *model = self.viewModel.datas[indexPath.section];
        headerView.catalogTitleLabel.text = model.title;
        headerView.arrowImageView.transform = CGAffineTransformMakeRotation(model.expand?M_PI_2:0);
        
        return headerView;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kUIScreen_Width, 60*kAppScale);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CatalogModel *model = self.viewModel.datas[indexPath.section];
    CGFloat maxHeight = 5*kSubCatalogCellHeight;
    CGFloat height = model.subCatalogs.count*kSubCatalogCellHeight;
    if (height>maxHeight) {
        height = maxHeight;
    }
    return CGSizeMake(collectionView.width, height);
}

#pragma mark CatalogCollectionReusableViewDelegate

- (void)didClickCatalogCollectionReusableView:(CatalogCollectionReusableView *)view {
    
    CatalogModel *model = self.viewModel.datas[view.section];
    if (model.subCatalogs.count>0) {  //展开
        model.expand = !model.expand;
        __weak __typeof(self) weakSelf = self;
        [self.collectionView performBatchUpdates:^{
            __strong typeof(self) strongSelf = weakSelf;
            NSIndexSet *section = [NSIndexSet indexSetWithIndex:view.section];
            [strongSelf.collectionView reloadSections:section];
        } completion:^(BOOL finished) {
        }];
    }else {  //跳转到详情
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:view.section];
        [self.viewModel enterDetailViewWithNavigationController:self.navigationController indexPath:indexPath];
    }
}

#pragma mark CatalogCollectionViewCellDelegate

- (void)didSelectedWithIndex:(NSInteger)index cell:(CatalogCollectionViewCell *)cell {
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.viewModel enterDetailViewWithNavigationController:self.navigationController indexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]];
    
}

@end
