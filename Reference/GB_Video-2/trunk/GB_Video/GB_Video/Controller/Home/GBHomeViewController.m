//
//  GBHomeViewController.m
//  GB_Video
//
//  Created by gxd on 2018/1/23.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBHomeViewController.h"
#import "GBPersonViewController.h"
#import "GBSearchViewController.h"

#import "GBHomeCell.h"
#import "PlayerDetailViewController.h"
#import "VideoListViewController.h"
#import "GBSearchBar.h"
#import "GBHomeHeaderView.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#import "HomeRequest.h"
#import "HomePageRequest.h"

@interface GBHomeViewController () <GBHomeHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet GBSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayout;

@property (strong, nonatomic) HomeHeaderInfo *homeHeaderInfo;

@property (strong, nonatomic) HomePageRequest *recordPageRequest;
@property (strong, nonatomic) NSArray <VideoDetailInfo *> *recordList;

@end

@implementation GBHomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

#pragma mark - Private
-(void)setupUI {
    
    @weakify(self)
    self.searchBar.actionSearch = ^{
        @strongify(self)
        [self.navigationController pushViewController:[GBSearchViewController new] animated:YES];
    };
    self.searchBar.actionPerson = ^{
        @strongify(self)
        [self.navigationController pushViewController:[GBPersonViewController new] animated:YES];
    };
    
    [self setupCollectionView];
    
    [self performBlock:^{
        //[AppUpdateManager checkAppVersion];
    } delay:1.f];
}

- (void)setupCollectionView {
    
    [self.collectionFlowLayout setItemSize:CGSizeMake(170*kAppScale,130*kAppScale)];
    self.collectionFlowLayout.headerReferenceSize = CGSizeMake(kUIScreen_Width, 230*kAppScale);
    self.collectionFlowLayout.sectionInset = UIEdgeInsetsMake(8*kAppScale, 10*kAppScale, 0, 10*kAppScale);
    self.collectionFlowLayout.minimumInteritemSpacing = 6*kAppScale;
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.collectionView registerNib:[UINib nibWithNibName:@"GBHomeCell" bundle:nil] forCellWithReuseIdentifier:@"GBHomeCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GBHomeHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GBHomeHeaderView"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self getHomeData];
        [self getFirstRecordList];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.collectionView.mj_header = mj_header;
}

- (void)loadNetworkData {
    [self.collectionView.mj_header beginRefreshing];
}

- (void)getHomeData {
    
    [HomeRequest getHomeHeaderInfo:^(id result, NSError *error) {
        if (!error) {
            self.homeHeaderInfo = result;
            [self.collectionView reloadData];
        }
    }];
    
}

- (void)getFirstRecordList {
    
    @weakify(self)
    [self.recordPageRequest reloadPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        [self.collectionView.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
            [self.collectionView reloadData];
        }else {
            self.recordList = self.recordPageRequest.responseInfo.items;
            [self.collectionView reloadData];
        }
    }];
}

- (void)getNextRecordList {
    
    @weakify(self)
    [self.recordPageRequest loadNextPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            self.recordList = self.recordPageRequest.responseInfo.items;
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - Getter & Setter

- (HomePageRequest *)recordPageRequest {
    if (!_recordPageRequest) {
        _recordPageRequest = [[HomePageRequest alloc] init];
    }
    return _recordPageRequest;
}

#pragma mark - GBHomeHeaderViewDelegate

- (void)didSelectBannerInfo:(BannerInfo *)bannerInfo {
    NSInteger videoId = [bannerInfo.content_url integerValue];
    PlayerDetailViewController *vc = [[PlayerDetailViewController alloc] initWithVideoId:videoId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didSelectTopicInfo:(TopicInfo *)topicInfo {
    VideoListViewController *vc = [[VideoListViewController alloc] initWithTopicId:topicInfo.topicId title:topicInfo.name];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.recordList ? self.recordList.count : 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GBHomeCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"GBHomeCell" forIndexPath:indexPath];
    
    VideoDetailInfo *videoDetailInfo = self.recordList[indexPath.row];

    [item.imageView sd_setImageWithURL:[NSURL URLWithString:videoDetailInfo.videoFirstFrameUrl] placeholderImage:[UIImage imageNamed:@"place_holder_image"]];
    item.nameLabel.text = videoDetailInfo.videoName;
    
    return item;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        GBHomeHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GBHomeHeaderView" forIndexPath:indexPath];
        [headerView refreshWithHomeHeaderInf:self.homeHeaderInfo];
        headerView.delegate = self;
        
        return headerView;
    } else {
        
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![self.recordPageRequest isLoadEnd] &&
        self.recordList.count-1 == indexPath.row) {
        [self getNextRecordList];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoDetailInfo *videoDetailInfo = self.recordList[indexPath.row];
    PlayerDetailViewController *vc = [[PlayerDetailViewController alloc] initWithVideoId:videoDetailInfo.videoId];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
