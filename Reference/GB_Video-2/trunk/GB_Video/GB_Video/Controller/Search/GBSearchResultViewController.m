//
//  GBSearchResultViewController.m
//  GB_Video
//
//  Created by gxd on 2018/2/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBSearchResultViewController.h"
#import "PlayerDetailViewController.h"
#import "SearchPageRequest.h"
#import "UIImageView+WebCache.h"

#import "GBHomeCell.h"

@interface GBSearchResultViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayout;

@property (strong, nonatomic) SearchPageRequest *recordPageRequest;
@property (strong, nonatomic) NSArray <VideoDetailInfo *> *recordList;
@end

@implementation GBSearchResultViewController

#pragma mark - Private
-(void)setupUI {
    
    [self setupCollectionView];

}
- (void)setupCollectionView {
    
    [self.collectionFlowLayout setItemSize:CGSizeMake(170*kAppScale,130*kAppScale)];
    self.collectionFlowLayout.sectionInset = UIEdgeInsetsMake(8*kAppScale, 10*kAppScale, 0, 10*kAppScale);
    self.collectionFlowLayout.minimumInteritemSpacing = 6*kAppScale;
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.collectionView registerNib:[UINib nibWithNibName:@"GBHomeCell" bundle:nil] forCellWithReuseIdentifier:@"GBHomeCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    
}

- (void)loadNetworkData {
    
}

- (void)reSearchWithName:(NSString *)searchName {
    self.recordPageRequest.keyword = searchName;
    [self getFirstRecordList];
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

- (SearchPageRequest *)recordPageRequest {
    if (!_recordPageRequest) {
        _recordPageRequest = [[SearchPageRequest alloc] init];
    }
    return _recordPageRequest;
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
