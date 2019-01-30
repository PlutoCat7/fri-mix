//
//  HomeHeaderViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/5.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "HomeHeaderViewController.h"
#import "GBWebBrowserViewController.h"
#import "GoodsInfoViewController.h"

#import "SDCycleScrollView.h"
#import "HomeItemCollectionViewCell.h"

#define kItemWidth (93*kAppScale)

@interface HomeHeaderViewController () <SDCycleScrollViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *scycleScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (nonatomic, strong) NSArray<HomeBannerInfo *> *banners;
@property (nonatomic, strong) NSArray<HomeCategoryInfo *> *categorys;

@end

@implementation HomeHeaderViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeItemCollectionViewCell"];
    CGSize itemSize = CGSizeMake(kItemWidth, kItemWidth);
    [_flowLayout setItemSize:itemSize];
}

#pragma mark - Public

- (void)refreshWithBanners:(NSArray<HomeBannerInfo *> *)banners categorys:(NSArray<HomeCategoryInfo *> *)categorys notice:(NSString *)notice {
    
    [self bannerUIRefresh:banners];
    [self categoryUIRefresh:categorys];
    [self noticeUIRefresh:notice];
}

#pragma mark - Private

- (void)bannerUIRefresh:(NSArray<HomeBannerInfo *> *)banners
{
    _banners = banners;
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:banners.count];
    for (HomeBannerInfo *info in banners) {
        [images addObject:info.thumb];
    }
    self.scycleScrollView.imageURLStringsGroup = images;
    self.scycleScrollView.placeholderImage = [UIImage imageNamed:@"default_icon"];
    self.scycleScrollView.delegate = self;
    self.scycleScrollView.pageControlAliment  = SDCycleScrollViewPageContolAlimentCenter;
    self.scycleScrollView.currentPageDotColor = [ColorManager styleColor];
    self.scycleScrollView.pageDotColor = [UIColor whiteColor];
    self.scycleScrollView.autoScrollTimeInterval = 3.f;
}

- (void)categoryUIRefresh:(NSArray<HomeCategoryInfo *> *)categorys {
    
    _categorys = categorys;
    CGFloat inSet = (kUIScreen_Width-kItemWidth*categorys.count)/(categorys.count+1);
    CGFloat spacing = inSet;
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, (NSInteger)(inSet), 0, (NSInteger)(inSet));
    _flowLayout.minimumInteritemSpacing = spacing;
    [self.collectionView reloadData];
}

- (void)noticeUIRefresh:(NSString *)notice {
    
    self.messageLabel.text = notice;
}


#pragma mark - Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_categorys count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeItemCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeItemCollectionViewCell" forIndexPath:indexPath];
    [item refreshWithInfo:_categorys[indexPath.row]];
    return item;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCategoryInfo *info = _categorys[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ShowCatalogView object:info];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    //点击了banner
    HomeBannerInfo *info = _banners[index];
    if ([info.act isEqualToString:@"h5"]) {
        GBWebBrowserViewController *vc = [[GBWebBrowserViewController alloc] initWithTitle:info.title url:info.url];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([info.act isEqualToString:@"goods"]) {
        GoodsInfoViewController *vc = [[GoodsInfoViewController alloc] initWithGoodsId:info.goodsId];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
