//
//  ColorCardFavorViewController.m
//  TiHouse
//
//  Created by weilai on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ColorCardFavorViewController.h"
#import "ColorBigCardViewController.h"

#import "ColorFavorPageRequest.h"
#import "ColorCardRequest.h"
#import "ODRefreshControl.h"
#import "ColorCardCollectionViewCell.h"
#import <UIScrollView+EmptyDataSet.h>

@interface ColorCardFavorViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayout;

@property (nonatomic, strong) ODRefreshControl *refreshControl;
@property (nonatomic, strong) ColorFavorPageRequest *recordPageRequest;

@property (nonatomic, strong) NSArray<ColorModeInfo *> *recordList;

@property (nonatomic, assign) BOOL isShowEmptyView;

@end

@implementation ColorCardFavorViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self.collectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

#pragma mark - private

- (void)setupUI {
    
    self.title = @"收藏色卡";
    
    [self setupCollectionView];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(void)setupCollectionView {
    
    [self.collectionFlowLayout setItemSize:CGSizeMake(kRKBWIDTH(160),kRKBHEIGHT(210))];
    self.collectionFlowLayout.headerReferenceSize = CGSizeMake(kScreen_Width, kRKBHEIGHT(10));
    CGFloat inSet = (kScreen_Width-kRKBWIDTH(160)*2)/3;
    self.collectionFlowLayout.sectionInset = UIEdgeInsetsMake(0, (NSInteger)(inSet), 0, (NSInteger)(inSet));
    self.collectionFlowLayout.minimumInteritemSpacing = inSet;
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.collectionView registerNib:[UINib nibWithNibName:@"ColorCardCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ColorCardCollectionViewCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:_collectionView];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

- (void)loadNetworkData {
    [self getFirstRecordList];
}

- (void)refresh {
    [self getFirstRecordList];
}

- (void)getFirstRecordList {
    
    @weakify(self)
    [self.recordPageRequest reloadPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        [self.refreshControl endRefreshing];
        
        if (error) {
            [NSObject showHudTipStr:error.domain];
        }else {
            self.recordList = self.recordPageRequest.responseInfo.items;
        }
        
        self.isShowEmptyView = self.recordList.count == 0 ? YES : NO;
        [self.collectionView reloadData];
    }];
}

- (void)getNextRecordList {
    
    @weakify(self)
    [self.recordPageRequest loadNextPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        if (error) {
            [NSObject showHudTipStr:error.domain];
        }else {
            self.recordList = self.recordPageRequest.responseInfo.items;
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - Getters & Setters

- (ColorFavorPageRequest *)recordPageRequest {
    
    if (!_recordPageRequest) {
        _recordPageRequest = [[ColorFavorPageRequest alloc] init];
        
    }
    
    return _recordPageRequest;
}

#pragma mark - Action

- (void)actionFavorModel:(ColorModeInfo *)model {
    if (model.colorcardiscoll) {
        WEAKSELF
        [ColorCardRequest removeColorCardFavor:model.colorcardid handler:^(id result, NSError *error) {
            if (error) {
                [NSObject showHudTipStr:error.domain];
            } else {
                GBResponseInfo *info = result;
                [NSObject showHudTipStr:info.msg];
                
                model.colorcardiscoll = !model.colorcardiscoll;
                
                NSMutableArray *list = [NSMutableArray arrayWithArray:weakSelf.recordList];
                [list removeObject:model];
                weakSelf.recordList = list;
                
                [weakSelf.collectionView reloadData];
            }
        }];
        
    } else {
        WEAKSELF
        [ColorCardRequest addColorCardFavor:model.colorcardid handler:^(id result, NSError *error) {
            if (error) {
                [NSObject showHudTipStr:error.domain];
            } else {
                GBResponseInfo *info = result;
                [NSObject showHudTipStr:info.msg];
                
                model.colorcardiscoll = !model.colorcardiscoll;
                [weakSelf.collectionView reloadData];
            }
        }];
    }
}


#pragma mark - DZNEmptyDataSetSource

///是否显示没有数据界面
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    
    return self.isShowEmptyView;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"暂无相关内容";
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

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.recordList ? self.recordList.count : 0;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ColorCardCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColorCardCollectionViewCell" forIndexPath:indexPath];
    item.backgroundColor = [UIColor clearColor];
    
    ColorModeInfo *model = self.recordList[indexPath.row];
    [item refreshWithColorModeInfo:model];
    
    WEAKSELF
    item.clickBlock = ^(ColorModeInfo * colorModelInfo) {
        [weakSelf actionFavorModel:colorModelInfo];
    };
    
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (![self.recordPageRequest isLoadEnd] &&
        self.recordList.count-1 == indexPath.row) {
        [self getNextRecordList];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ColorBigCardViewController *viewController = [[ColorBigCardViewController alloc] initWithColorModeInfoList:self.recordList index:indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
