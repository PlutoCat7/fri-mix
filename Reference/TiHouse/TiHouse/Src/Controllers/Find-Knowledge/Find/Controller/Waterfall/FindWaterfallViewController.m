//
//  FindWaterfallViewController.m
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindWaterfallViewController.h"
#import "FindPhotoDetailViewController.h"
#import "UIViewController+YHToast.h"
#import <UIScrollView+EmptyDataSet.h>

#import "OJLWaterLayout.h"
#import "FindWaterfallCollectionViewCell.h"

#import "FindWaterfallStore.h"
#import "YAHKVOController.h"
#import "AssemarcRequest.h"

@interface FindWaterfallViewController ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
OJLWaterLayoutDelegate,
DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) OJLWaterLayout* layout;

@property (nonatomic, strong) FindWaterfallStore *store;

@property (nonatomic, assign) BOOL isShowEmptyView;

@end

@implementation FindWaterfallViewController

- (instancetype)init
{
    return [self initWithSearchName:@""];
}

- (instancetype)initWithSearchName:(NSString *)searchName
{
    self = [super init];
    if (self) {
        _store = [[FindWaterfallStore alloc] init];
        _store.searchName = searchName;
        WEAKSELF
        [self.yah_KVOController observe:self.store keyPath:@"cellModels" block:^(id observer, id object, NSDictionary *change) {
            
            [weakSelf.collectionView reloadData];
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.store.searchName &&
        ![self.store.searchName isEmpty]) {
        [self.collectionView.mj_header beginRefreshing];
    }
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.collectionView.frame = self.view.bounds;
        [self.collectionView reloadData];
    });
}


- (void)reSearchWithName:(NSString *)name {
    
    _store.searchName = name;
    //调用搜索接口
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = _store.searchName;
    [self setupCollectionView];
}

- (void)setupCollectionView {
    
    OJLWaterLayout* layout = [[OJLWaterLayout alloc] init];
    self.layout = layout;
    layout.numberOfCol = 2;
    layout.rowPanding = 0;
    layout.colPanding = 12;
    layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
    layout.delegate = self;
    [layout autuContentSize];
    
    UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.emptyDataSetSource = self;
    collectionView.emptyDataSetDelegate = self;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FindWaterfallCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([FindWaterfallCollectionViewCell class])];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.store getFirstPageDataWithHandler:^(NSError *error) {
            [self.collectionView.mj_header endRefreshing];
            
            self.isShowEmptyView = self.store.cellModels.count == 0 ? YES : NO;
            [self.collectionView reloadData];
        }];
    }];
    self.collectionView.mj_header = mj_header;
}

#pragma mark - OJLWaterLayoutDelegate

- (CGFloat)OJLWaterLayout:(OJLWaterLayout *)OJLWaterLayout itemHeightForIndexPath:(NSIndexPath *)indexPath {
    
    FindWaterfallModel * model = self.store.cellModels[indexPath.row];
    if (model.caculateHeight>0) {  //已经计算
        return model.caculateHeight;
    }
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - self.layout.sectionInset.left - self.layout.sectionInset.right - (self.layout.colPanding * (self.layout.numberOfCol - 1))) / self.layout.numberOfCol;
    
    CGFloat scale = model.imageWidth / width;
    CGFloat imageHeight =  model.imageHeight / scale;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.font = [UIFont systemFontOfSize:kRKBWIDTH(13)];
    label.numberOfLines = 0;
    label.text = model.title;
    [label sizeToFit];
    CGFloat textHeight = label.height + kFindWaterfallCollectionViewCellTextHeight;
    
    model.caculateHeight = imageHeight + textHeight;;
    
    return model.caculateHeight;
}

#pragma mark - DZNEmptyDataSetSource

///是否显示没有数据界面
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    
    return self.isShowEmptyView;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"没有找到相关内容，换个词试试吧";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:RGB(191, 191, 191),
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"search_e.png"];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.store.cellModels.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FindWaterfallCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FindWaterfallCollectionViewCell class]) forIndexPath:indexPath];
    [cell refreshWithModel:_store.cellModels[indexPath.row]];
    WEAKSELF
    cell.clickZanBlock = ^(FindWaterfallModel *model) {
        [weakSelf clickZan:model indexPath:indexPath];
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.store isLoadEnd] &&
        self.store.cellModels.count-1 == indexPath.row) {
        [self.store getNextPageDataWithHandler:nil];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FindAssemarcInfo *arcInfo = [_store assemarcInfoWithIndexPath:indexPath];
    FindPhotoDetailViewController *vc = [[FindPhotoDetailViewController alloc] initWithAssemarcInfo:arcInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickZan:(FindWaterfallModel *)model indexPath:(NSIndexPath *)indexPath {
    
    [self showLoadingToast];
    @weakify(self)
    [_store likeArticleWithIndexPath:indexPath handler:^(BOOL isSuccess) {
        @strongify(self)
        [self dismissToast];
        if (isSuccess) {
            FindWaterfallCollectionViewCell *cell = (FindWaterfallCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            [cell refreshWithLikeCount:model.likeCount isLike:model.isMeLike];
        }
    }];
}

@end
