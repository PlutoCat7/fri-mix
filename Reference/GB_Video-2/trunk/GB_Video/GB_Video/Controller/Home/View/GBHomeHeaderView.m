//
//  GBHomeHeaderView.m
//  GB_Video
//
//  Created by gxd on 2018/1/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBHomeHeaderView.h"
#import "XXNibBridge.h"
#import "SDCycleScrollView.h"
#import "GBHeaderTopicCell.h"
#import "UIImageView+WebCache.h"

@interface GBHomeHeaderView()<XXNibBridge,
UICollectionViewDelegate,
UICollectionViewDataSource,
SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UICollectionView *topicView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *topicFlowLayout;

@property (strong, nonatomic) HomeHeaderInfo *homeHeaderInfo;
@end

@implementation GBHomeHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self setupBannerView];
    [self setupTopicView];
}

- (void)setupBannerView {

    self.bannerView.imageURLStringsGroup = [NSMutableArray arrayWithCapacity:1];
    self.bannerView.delegate = self;
    self.bannerView.pageControlAliment  = SDCycleScrollViewPageContolAlimentLeft;
    self.bannerView.currentPageDotImage = [UIImage imageNamed:@"rolling_s"];
    self.bannerView.pageDotImage        = [UIImage imageNamed:@"rolling_n"];
    self.bannerView.autoScrollTimeInterval = 3.f;
}

- (void)setupTopicView {
    
    [self.topicFlowLayout setItemSize:CGSizeMake(kUIScreen_Width/5, 75*kAppScale)];
    self.topicFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.topicFlowLayout.minimumInteritemSpacing = 0;
    self.topicFlowLayout.minimumLineSpacing = 0;
    
    [self.topicView registerNib:[UINib nibWithNibName:@"GBHeaderTopicCell" bundle:nil] forCellWithReuseIdentifier:@"GBHeaderTopicCell"];
    self.topicView.backgroundColor = [UIColor whiteColor];
    self.topicView.scrollsToTop = NO;
    self.topicView.showsVerticalScrollIndicator = NO;
    self.topicView.showsHorizontalScrollIndicator = NO;
    self.topicView.delegate = self;
    self.topicView.dataSource = self;
}

- (void)refreshWithHomeHeaderInf:(HomeHeaderInfo *)homeHeaderInfo {
    _homeHeaderInfo = homeHeaderInfo;
    
    NSMutableArray *imageList = [NSMutableArray arrayWithCapacity:1];
    if (homeHeaderInfo.banner_list) {
        for (BannerInfo *bannerInfo in homeHeaderInfo.banner_list) {
            [imageList addObject:bannerInfo.image_url];
        }
    }
    self.bannerView.imageURLStringsGroup = [imageList copy];
    
    [self.topicView reloadData];
}

#pragma mark - SDCycleScrollView Delegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectBannerInfo:)]) {
        BannerInfo *bannerInfo = _homeHeaderInfo.banner_list[index];
        [self.delegate didSelectBannerInfo:bannerInfo];
    }
}

#pragma mark - UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _homeHeaderInfo.topic_list ? _homeHeaderInfo.topic_list.count : 0;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GBHeaderTopicCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"GBHeaderTopicCell" forIndexPath:indexPath];
    
    TopicInfo *topicInfo = _homeHeaderInfo.topic_list[indexPath.row];
    [item.imageView sd_setImageWithURL:[NSURL URLWithString:topicInfo.image_url] placeholderImage:[UIImage imageNamed:@"place_holder_image"]];
    item.nameLabel.text = topicInfo.name;
    
    return item;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectTopicInfo:)]) {
        TopicInfo *topicInfo = _homeHeaderInfo.topic_list[indexPath.row];
        [self.delegate didSelectTopicInfo:topicInfo];
    }
}

@end
