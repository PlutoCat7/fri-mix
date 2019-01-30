//
//  HUPhotoBrowser.m
//  HUPhotoBrowser
//
//  Created by mac on 16/2/24.
//  Copyright (c) 2016年 jinhuadiqigan. All rights reserved.
//

#import "HUPhotoBrowser.h"
#import "HUPhotoBrowserCell.h"
#import "const.h"

@interface HUPhotoBrowser () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
    CGRect _endTempFrame;
    NSInteger _currentPage;
    NSIndexPath *_zoomingIndexPath;
}

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UICollectionView *fromeCollectionView;
@property (nonatomic, strong) NSArray *URLStrings;
@property (nonatomic) NSInteger index;
@property (nonatomic, copy) DismissBlock dismissDlock;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UILabel *pageNum;
@property (nonatomic, retain) UIButton *eidt;
@property (nonatomic, retain) UIButton *delete;
@property (nonatomic, retain) UIView *tabbar;
@property (nonatomic, retain) UIView *bottomView;

@end

@implementation HUPhotoBrowser

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)showFromImageView:(UIImageView *)imageView withURLStrings:(NSArray *)URLStrings placeholderImage:(UIImage *)image atIndex:(NSInteger)index dismiss:(DismissBlock)block {
    HUPhotoBrowser *browser = [[HUPhotoBrowser alloc] initWithFrame:kScreenRect];
    browser.imageView = imageView;
    browser.URLStrings = URLStrings;
    [browser configureBrowser];
    if (imageView) {
        [browser animateImageViewAtIndex:index];
    }
    browser.placeholderImage = image;
    browser.dismissDlock = block;
    
    return browser;
}


+ (instancetype)showFromImageView:(UIImageView *)imageView withImages:(NSArray *)images placeholderImage:(UIImage *)image atIndex:(NSInteger)index dismiss:(DismissBlock)block {
    HUPhotoBrowser *browser = [[HUPhotoBrowser alloc] initWithFrame:kScreenRect];
    browser.imageView = imageView;
    browser.images = [images mutableCopy];
    [browser configureBrowser];
    if (imageView) {
        [browser animateImageViewAtIndex:index];
    }
    
    browser.placeholderImage = image;
    browser.dismissDlock = block;
    
    return browser;
}

+ (instancetype)showCollectionView:(UICollectionView *)collectionView withImages:(NSMutableArray *)images placeholderImage:(TweetImage *)image atIndex:(NSInteger)index Animation:(BOOL)animation dismiss:(DismissBlock)block{
    
    HUPhotoBrowser *browser = [[HUPhotoBrowser alloc] initWithFrame:kScreenRect];
    browser.fromeCollectionView = collectionView;
    browser.images = images;
    [browser configureBrowser];
    if (collectionView) {
        [browser animateCtionViewViewAtIndex:index Animation:animation];
    }
    browser.placeholderImage = image.image;
    browser.dismissDlock = block;
    browser.pageNum.text = [NSString stringWithFormat:@"%ld/%ld",index+1,images.count];
    browser.tabbar.backgroundColor = XWColorFromHex(0x44444b);
    browser.eidt.hidden = NO;
    browser.delete.hidden = NO;
    return browser;
}

+ (instancetype)showMoveCollectionView:(UICollectionView *)collectionView withImages:(NSMutableArray *)images placeholderImage:(TweetImage *)image atIndex:(NSInteger)index Animation:(BOOL)animation dismiss:(DismissBlock)block{
    HUPhotoBrowser *browser = [[HUPhotoBrowser alloc] initWithFrame:kScreenRect];
    browser.fromeCollectionView = collectionView;
    browser.images = images;
    [browser configureBrowser];
    if (collectionView) {
        [browser animateCtionViewViewAtIndex:index Animation:animation];
    }
    browser.placeholderImage = image.image;
    browser.dismissDlock = block;
    browser.pageNum.text = [NSString stringWithFormat:@"%ld/%ld",index+1,images.count];
    browser.tabbar.backgroundColor = XWColorFromHex(0x44444b);
    return browser;
}

+ (instancetype)showFromImageView:(UIImageView *)imageView withURLStrings:(NSArray *)URLStrings atIndex:(NSInteger)index {

    return [self showFromImageView:imageView withURLStrings:URLStrings placeholderImage:nil atIndex:index dismiss:nil];
}

+ (instancetype)showFromImageView:(UIImageView *)imageView withImages:(NSArray *)images atIndex:(NSInteger)index {
    return [self showFromImageView:imageView withImages:images placeholderImage:nil atIndex:index dismiss:nil];
}

#pragma mark - private 

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
        collectionView.hidden = YES;
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView = collectionView;
        [self addSubview:collectionView];
        
        
        _tabbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, kDevice_Is_iPhoneX?84:64)];
        _tabbar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        //返回
        UIButton *block = [UIButton buttonWithType:UIButtonTypeCustom];
        block.frame = CGRectMake(0, kDevice_Is_iPhoneX?20:0, 40, 64);
        [block setImage:[UIImage imageNamed:@"find_back_white"] forState:UIControlStateNormal];
        [block addTarget:self action:@selector(block) forControlEvents:UIControlEventTouchUpInside];
        
        //删除
        _delete = [UIButton buttonWithType:UIButtonTypeCustom];
        _delete.hidden = YES;
        _delete.frame = CGRectMake(kScreenWidth-40, kDevice_Is_iPhoneX?20:0, 40, 64);
        [_delete setImage:[UIImage imageNamed:@"find_photo_post_delete"] forState:UIControlStateNormal];
        [_delete addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        
        _pageNum = [[UILabel alloc]initWithFrame:CGRectMake(0, kDevice_Is_iPhoneX?20:0, 100, 64)];
        _pageNum.centerX = kScreenWidth/2;
        _pageNum.textAlignment = NSTextAlignmentCenter;
        _pageNum.textColor = [UIColor whiteColor];
        
        [_tabbar addSubview:_pageNum];
        [_tabbar addSubview:_delete];
        [_tabbar addSubview:block];
        [self addSubview:_tabbar];
        
        
        
        //编辑
        _eidt = [UIButton buttonWithType:UIButtonTypeCustom];
        _eidt.hidden = YES;
        _eidt.frame = CGRectMake(0, kScreenHeight - 64, 60, 64);
        [_eidt setTitle:@"编辑" forState:UIControlStateNormal];
        [_eidt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _eidt.titleLabel.font = [UIFont systemFontOfSize:14];
        [_eidt addTarget:self action:@selector(eidtBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_eidt];
        
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadForScreenRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoCellDidZooming:) name:kPhotoCellDidZommingNotification object:nil];
        
    }
    return self;
}
//返回
-(void)block{
    [self dismissAnimation:NO];
}
//编辑
-(void)eidtBtn{
    if (_edit){
        HUPhotoBrowserCell *cell = (HUPhotoBrowserCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage inSection:0]];
        _edit(cell.imageView.image, _currentPage);
    }
    [self dismissAnimation:NO];
}
//删除
-(void)deleteClick{
    
//    if (self.images.count == 1) {
//        [NSObject showHudTipStr:@"至少有一张图片！"];
//        return;
//    }
    [self.images removeObjectAtIndex:_currentPage];
    _currentPage = 0;
    [self animateCtionViewViewAtIndex:_currentPage Animation:NO];
    [_collectionView reloadData];
    self.pageNum.text = [NSString stringWithFormat:@"%ld/%ld",_currentPage+1,self.images.count];
    if (self.images.count == 0) {
        [self dismissAnimation:NO];
    }
}

- (void)configureBrowser {
   
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[HUPhotoBrowserCell class] forCellWithReuseIdentifier:kPhotoBrowserCellID];
    [self.collectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)animateImageViewAtIndex:(NSInteger)index {
    _index = index;
    CGRect startFrame = [self.imageView.superview convertRect:self.imageView.frame toView:[UIApplication sharedApplication].keyWindow];
    CGRect endFrame = kScreenRect;

    if (self.imageView.image) {
        UIImage *image = self.imageView.image;
        CGFloat ratio = image.size.width / image.size.height;
        
        if (ratio > kScreenRatio) {
            endFrame.size.height = kScreenWidth / ratio;
            
        } else {
        
            endFrame.size.height = kScreenHeight * ratio;
        }
        endFrame.origin.x = (kScreenWidth - endFrame.size.width) / 2;
        endFrame.origin.y = (kScreenHeight - endFrame.size.height) / 2;
        
    }

    _endTempFrame = endFrame;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:startFrame];
    tempImageView.image = self.imageView.image;
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
    
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        tempImageView.frame = endFrame;
        
    } completion:^(BOOL finished) {
        _currentPage = index;
        [self.collectionView setContentOffset:CGPointMake(kScreenWidth * index,0) animated:NO];
        self.collectionView.hidden = NO;
        [tempImageView removeFromSuperview];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tempImageView removeFromSuperview];
    });
}

- (void)animateCtionViewViewAtIndex:(NSInteger)index Animation:(BOOL)animation{
    
    if (!animation) {
        _currentPage = index;
        [self.collectionView setContentOffset:CGPointMake(kScreenWidth * index,0) animated:NO];
        self.collectionView.hidden = NO;
        return;
    }
    
    _index = index;
    CGRect startFrame = [self.fromeCollectionView convertRect:[self.fromeCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.index inSection:0]].frame toView:[UIApplication sharedApplication].keyWindow];
    CGRect endFrame = kScreenRect;
    
    TweetImage *Tweetimage = self.images[self.index];
    if (Tweetimage.image) {
        UIImage *image = Tweetimage.image;
        CGFloat ratio = image.size.width / image.size.height;
        
        if (ratio > kScreenRatio) {
            endFrame.size.height = kScreenWidth / ratio;
            
        } else {
            
            endFrame.size.height = kScreenHeight * ratio;
        }
        endFrame.origin.x = (kScreenWidth - endFrame.size.width) / 2;
        endFrame.origin.y = (kScreenHeight - endFrame.size.height) / 2;
        
    }
    
    _endTempFrame = endFrame;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:startFrame];
    tempImageView.layer.masksToBounds = YES;
    tempImageView.image = Tweetimage.image;
    tempImageView.layer.masksToBounds = YES;
    tempImageView.contentMode = UIViewContentModeScaleAspectFill;
    [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
    
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        tempImageView.frame = endFrame;
        
    } completion:^(BOOL finished) {
        _currentPage = index;
        [self.collectionView setContentOffset:CGPointMake(kScreenWidth * index,0) animated:NO];
        self.collectionView.hidden = NO;
        [tempImageView removeFromSuperview];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tempImageView removeFromSuperview];
    });
}

- (void)dismissAnimation:(BOOL)animation{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    if (_dismiss) {
        _dismiss();
    }
    
    if (!animation) {
        [self removeFromSuperview];
        return;
    }
    
    
    if (self.dismissDlock) {
        HUPhotoBrowserCell *cell = (HUPhotoBrowserCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage inSection:0]];
        self.dismissDlock(cell.imageView.image, _currentPage);
    }
    
    CGRect endFrame = [self.fromeCollectionView convertRect:[self.fromeCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage inSection:0]].frame toView:[UIApplication sharedApplication].keyWindow];
    
    TweetImage *Tweetimage = self.images[_currentPage];
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:_endTempFrame];
    tempImageView.image = Tweetimage.image;
    tempImageView.layer.masksToBounds = YES;
    tempImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.collectionView.hidden = YES;
    
    [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
    
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        tempImageView.frame = endFrame;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [tempImageView removeFromSuperview];
        
        
    }];
    
}


- (void)dismiss {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    if (_dismiss) {
        _dismiss();
    }
    if (self.dismissDlock) {
        HUPhotoBrowserCell *cell = (HUPhotoBrowserCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage inSection:0]];
        self.dismissDlock(cell.imageView.image, _currentPage);
    }
    
    if (_currentPage != _index) {
        
        [self removeFromSuperview];
        return;
    }
    
    
    CGRect endFrame = [self.imageView.superview convertRect:self.imageView.frame toView:[UIApplication sharedApplication].keyWindow];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:_endTempFrame];
    tempImageView.image = self.imageView.image;
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.collectionView.hidden = YES;
    
    [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
    
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        tempImageView.frame = endFrame;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [tempImageView removeFromSuperview];
        
        
    }];
   
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (self.URLStrings) {
        count = _URLStrings.count;
    }
    else if (self.images) {
        count = _images.count;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HUPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoBrowserCellID forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.placeholderImage = self.placeholderImage;
    [cell resetZoomingScale];
    
    if (self.URLStrings) {
        [cell configureCellWithURLStrings:self.URLStrings[indexPath.row]];
    }
    else if (self.images) {
        TweetImage *Tweetimage = self.images[indexPath.row];
        cell.imageView.image = Tweetimage.image;
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenRect.size;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentPage = scrollView.contentOffset.x/kScreenWidth + 0.5;
    _pageNum.text = [NSString stringWithFormat:@"%ld/%ld",_currentPage+1,_images.count];

    if (_zoomingIndexPath) {
       [self.collectionView reloadItemsAtIndexPaths:@[_zoomingIndexPath]];
        _zoomingIndexPath = nil;
    }
    
}

- (void)reloadForScreenRotate {
     _collectionView.frame = kScreenRect;
   
    [_collectionView reloadData];
    _collectionView.contentOffset = CGPointMake(kScreenWidth * _currentPage,0);
}

- (void)photoCellDidZooming:(NSNotification *)nofit {
    NSIndexPath *indexPath = nofit.object;
    _zoomingIndexPath = indexPath;
}

@end


@interface HUPhotoBrowserBottom () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
    CGRect _endTempFrame;
    NSInteger _currentPage;
    NSIndexPath *_zoomingIndexPath;
}

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation HUPhotoBrowserBottom

//-(instancetype)init{
//    if (self = [super initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 200)]) {
//        <#statements#>
//    }
//}


@end
