//
//  ColorCardViewController.m
//  TiHouse
//
//  Created by weilai on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ColorCardViewController.h"
#import "ColorBigCardViewController.h"
#import "ColorCardFavorViewController.h"

#import "ODRefreshControl.h"
#import "ColorCardCollectionViewCell.h"
#import "ColorCardCollectionHeaderView.h"
#import "ColorCardPageRequest.h"
#import "ColorCardRequest.h"

@interface ColorCardViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayout;
@property (weak, nonatomic) IBOutlet UIButton *favorButton;
@property (weak, nonatomic) IBOutlet UIView *favorButtonShadowView;

@property (nonatomic, strong) ODRefreshControl *refreshControl;
@property (nonatomic, strong) ColorCardPageRequest *recordPageRequest;

@property (nonatomic, strong) NSArray<ColorModeInfo *> *recordList;

@end

@implementation ColorCardViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self.collectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)setupUI {
    
    [self.favorButton.layer setMasksToBounds:YES];
    [self.favorButton.layer setCornerRadius:25.f];
    CALayer *sublayer =[CALayer layer];
    sublayer.backgroundColor = [UIColor colorWithRGBHex:0xFDF086].CGColor;
    sublayer.shadowOffset = CGSizeMake(0, 3);
    sublayer.shadowRadius = 5.0;
    sublayer.shadowColor =[UIColor colorWithRGBHex:0xF2DF90].CGColor;
    sublayer.shadowOpacity = 1.0;
    sublayer.frame = CGRectMake(0, 0, kScreen_Width-90, self.favorButtonShadowView.height);
    sublayer.cornerRadius = 25.0;
    [self.favorButtonShadowView.layer addSublayer:sublayer];
    
    [self setupCollectionView];
}

-(void)setupCollectionView {
    
    [self.collectionFlowLayout setItemSize:CGSizeMake(kColorCardCollectionViewCellWidth,kColorCardCollectionViewCellHeight)];
    self.collectionFlowLayout.headerReferenceSize = CGSizeMake(kScreen_Width, kRKBHEIGHT(110));
    
    CGFloat inSet = (kScreen_Width-kColorCardCollectionViewCellWidth*2)/3;
    self.collectionFlowLayout.sectionInset = UIEdgeInsetsMake(0, (NSInteger)(inSet), 0, (NSInteger)(inSet));
    self.collectionFlowLayout.minimumInteritemSpacing = inSet;
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.collectionView registerNib:[UINib nibWithNibName:@"ColorCardCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ColorCardCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ColorCardCollectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ColorCardCollectionHeaderView"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
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
            [NSObject showHudTipStr:error.domain];
        }else {
            self.recordList = self.recordPageRequest.responseInfo.items;
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - Getters & Setters

- (ColorCardPageRequest *)recordPageRequest {
    
    if (!_recordPageRequest) {
        _recordPageRequest = [[ColorCardPageRequest alloc] init];
        
    }
    
    return _recordPageRequest;
}

#pragma mark - Action

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionFavor:(id)sender {
    ColorCardFavorViewController *viewController = [ColorCardFavorViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        ColorCardCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ColorCardCollectionHeaderView" forIndexPath:indexPath];
        
        return headerView;
    }else {
        
        return nil;
    }
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
