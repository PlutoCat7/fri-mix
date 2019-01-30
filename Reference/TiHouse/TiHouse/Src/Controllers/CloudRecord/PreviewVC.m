//
//  PreviewVC.m
//  微博照片选择
//
//  Created by 陈晨昕 on 2018/1/31.
//  Copyright © 2018年 洪欣. All rights reserved.
//

#import "PreviewVC.h"
#import "UIImage+HXExtension.h"
#import "UIButton+HXExtension.h"
#import "HXDatePhotoViewTransition.h"
#import "HXDatePhotoInteractiveTransition.h"
#import "HXDatePhotoViewPresentTransition.h"
#import "HXPhotoCustomNavigationBar.h"
#import "HXCircleProgressView.h"
#import "UIViewController+HXExtension.h"
#import "CloudReShareView.h"
#import "CloudReCollectItemModel.h"
#import "TweetDetailsViewController.h"

@interface PreviewVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) HXPhotoModel *currentModel;
@property (strong, nonatomic) PreviewVCViewCell *tempCell;
@property (assign, nonatomic) BOOL orientationDidChange;
@property (assign, nonatomic) NSInteger beforeOrientationIndex;
@property (strong, nonatomic) HXDatePhotoInteractiveTransition *interactiveTransition;
@property (assign, nonatomic) BOOL isAddInteractiveTransition;
@property (strong, nonatomic) UIView * topView;
@property (strong, nonatomic) UIButton * backBtn;
@property (strong, nonatomic) UIButton * commonBtn;
@property (strong, nonatomic) UIButton * moreBtn;
@property (strong, nonatomic) UILabel * titleLable;
@property (strong, nonatomic) UITextView * textView;
@property (weak, nonatomic) CloudReShareView * cloudReShareView;
@end

@implementation PreviewVC
- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationWillChanged:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}

/*
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        return [HXDatePhotoViewTransition transitionWithType:HXDatePhotoViewTransitionTypePush];
    }else {
        if (![fromVC isKindOfClass:[self class]]) {
            return nil;
        }
        return [HXDatePhotoViewTransition transitionWithType:HXDatePhotoViewTransitionTypePop];
    }
}
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    return self.interactiveTransition.interation ? self.interactiveTransition : nil;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [HXDatePhotoViewPresentTransition transitionWithTransitionType:HXDatePhotoViewPresentTransitionTypePresent photoView:self.photoView];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [HXDatePhotoViewPresentTransition transitionWithTransitionType:HXDatePhotoViewPresentTransitionTypeDismiss photoView:self.photoView];
}
*/

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.orientationDidChange) {
        self.orientationDidChange = NO;
        [self changeSubviewFrame];
    }
}
- (void)deviceOrientationChanged:(NSNotification *)notify {
    self.orientationDidChange = YES;
}
- (void)deviceOrientationWillChanged:(NSNotification *)notify {
    self.beforeOrientationIndex = self.currentModelIndex;
}
- (PreviewVCViewCell *)currentPreviewCell:(HXPhotoModel *)model {
    if (!model) {
        return nil;
    }
    return (PreviewVCViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
}

- (void)changeSubviewFrame {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat bottomMargin = kBottomMargin;
    //    CGFloat leftMargin = 0;
    //    CGFloat rightMargin = 0;
    CGFloat width = self.view.hx_w;
    CGFloat itemMargin = 20;
    if (kDevice_Is_iPhoneX && (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)) {
        bottomMargin = 21;
        //        leftMargin = 35;
        //        rightMargin = 35;
        //        width = self.view.hx_w - 70;
    }
    self.flowLayout.itemSize = CGSizeMake(width, self.view.hx_h - kTopMargin - bottomMargin);
    self.flowLayout.minimumLineSpacing = itemMargin;
    
    [self.collectionView setCollectionViewLayout:self.flowLayout];
    
    //    self.collectionView.contentInset = UIEdgeInsetsMake(0, leftMargin, 0, rightMargin);

    self.collectionView.frame = CGRectMake(-(itemMargin / 2), kTopMargin,self.view.hx_w + itemMargin, self.view.hx_h - kTopMargin - bottomMargin);
    self.collectionView.contentSize = CGSizeMake(self.modelArray.count * (self.view.hx_w + itemMargin), 0);
    
    [self.collectionView setContentOffset:CGPointMake(self.beforeOrientationIndex * (self.view.hx_w + itemMargin), 0)];
    
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.beforeOrientationIndex inSection:0]]];
    }];
    
    if (self.manager.configuration.previewCollectionView) {
        self.manager.configuration.previewCollectionView(self.collectionView);
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    HXPhotoModel *model = self.modelArray[self.currentModelIndex];
    self.currentModel = model;
    PreviewVCViewCell *cell = (PreviewVCViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
    if (!cell) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            PreviewVCViewCell *tempCell = (PreviewVCViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
            self.tempCell = tempCell;
            [tempCell requestHDImage];
        });
    }else {
        self.tempCell = cell;
        [cell requestHDImage];
    }
//    if (!self.isAddInteractiveTransition) {
//        if (!self.outside) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                //初始化手势过渡的代理
//                self.interactiveTransition = [[HXDatePhotoInteractiveTransition alloc] init];
//                //给当前控制器的视图添加手势
//                [self.interactiveTransition addPanGestureForViewController:self];
//            });
//        }
//        self.isAddInteractiveTransition = YES;
//    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    PreviewVCViewCell *cell = (PreviewVCViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
    [cell cancelRequest];
}

- (void)setupUI {

    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.previewBottomView];
    
    self.beforeOrientationIndex = self.currentModelIndex;
    [self changeSubviewFrame];
    
    //HXPhotoModel *model = self.modelArray[self.currentModelIndex];
}

#pragma mark - < UICollectionViewDataSource >
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.modelArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PreviewVCViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DatePreviewCellId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    HXPhotoModel *model = self.modelArray[indexPath.item];
    cell.model = model;
    __weak typeof(self) weakSelf = self;
    [cell setCellDidPlayVideoBtn:^(BOOL play) {
        //点击播放按钮回调
        [self dismissShareView];
    }];
    [cell setCellDownloadICloudAssetComplete:^(PreviewVCViewCell *myCell) {
        if ([weakSelf.delegate respondsToSelector:@selector(datePhotoPreviewDownLoadICloudAssetComplete:model:)]) {
            [weakSelf.delegate datePhotoPreviewDownLoadICloudAssetComplete:weakSelf model:myCell.model];
        }
    }];
    [cell setCellTapClick:^{
        [weakSelf setSubviewAlphaAnimate:YES];
    }];
    return cell;
}

-(void)dismissShareView {
    if (self.cloudReShareView) {
        [self.cloudReShareView dismissSelectColorView];
        self.cloudReShareView = nil;
    }
}

- (void)setSubviewAlphaAnimate:(BOOL)animete {
    [self dismissShareView];
    
    if (self.topView.hidden) {
        self.topView.hidden = NO;
        self.previewBottomView.hidden = NO;
    } else {
        self.topView.hidden = YES;
        self.previewBottomView.hidden = YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(PreviewVCViewCell *)cell resetScale];
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(PreviewVCViewCell *)cell cancelRequest];
}
#pragma mark - < UICollectionViewDelegate >
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self dismissShareView];
    
    if (scrollView != self.collectionView) {
        return;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat offsetx = self.collectionView.contentOffset.x;
    NSInteger currentIndex = (offsetx + (width + 20) * 0.5) / (width + 20);
    if (currentIndex > self.modelArray.count - 1) {
        currentIndex = self.modelArray.count - 1;
    }
    if (currentIndex < 0) {
        currentIndex = 0;
    }
    if (self.modelArray.count > 0) {
        HXPhotoModel *model = self.modelArray[currentIndex];
        self.textView.text = model.barSubTitle;//描述内容
//        self.titleLable.text = [NSString stringWithFormat:@"%ld / %ld",currentIndex,self.modelArray.count];//标题索引
        
        if (model.subType == HXPhotoModelMediaSubTypeVideo) {
            
        } else {
            
        }
    }
    self.currentModelIndex = currentIndex;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.modelArray.count > 0) {
        PreviewVCViewCell *cell = (PreviewVCViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
        HXPhotoModel *model = self.modelArray[self.currentModelIndex];
        self.currentModel = model;
        [cell requestHDImage];
    }
}

-(void)backAction {
    if (_backRefreshBlock) {
        _backRefreshBlock();
    }
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)moreAction {
    
    if (self.cloudReShareView) {
        //如果已经打开更多界面，先进行移除操作
        [self dismissShareView];
        return;
    }
    
    HXPhotoModel * model = nil;
    CloudReCollectItemModel * itemModel = nil;
    if (self.currentModelIndex < self.modelArray.count) {
        model = self.modelArray[self.currentModelIndex];
        itemModel = self.cloudReCollectItemArray[self.currentModelIndex];
    }
    
    WEAKSELF;
    CloudReShareView * shareView = [CloudReShareView shareInstanceWithViewModel:nil];
    self.cloudReShareView = shareView;
    self.cloudReShareView.viewVC = self;
    self.cloudReShareView.fileid = itemModel.fileid;
    self.cloudReShareView.image = model.tempImage;
    self.cloudReShareView.videoUrl = itemModel.typefile == 2 ? itemModel.urlfile : nil;
    self.cloudReShareView.itemModel = itemModel;
    [self.view addSubview:self.cloudReShareView];
    [self.cloudReShareView showSelectColorView];
    self.cloudReShareView.DelBlock = ^{
        [weakSelf backAction];
    };
}

-(void)commonAction {
    
    CloudReCollectItemModel * itemModel = nil;
    if (self.currentModelIndex < self.modelArray.count) {
        itemModel = self.cloudReCollectItemArray[self.currentModelIndex];
    }
    TweetDetailsViewController *vc = [[TweetDetailsViewController alloc] init];
    vc.dairyid = itemModel.dairyid;
    House *house = [[House alloc] init];
    house.houseid = itemModel.houseid;
    vc.house = house;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - get fun

-(UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.frame = CGRectMake(0, kNavigationBarTop, kScreen_Width, 64);
        
        UIView * background = [[UIView alloc] init];
        background.backgroundColor = [UIColor blackColor];
        background.alpha = 0.6;
        background.frame = _topView.bounds;
        [_topView addSubview:background];
        
        [_topView addSubview:self.backBtn];
        [_topView addSubview:self.titleLable];
        [_topView addSubview:self.moreBtn];
        [_topView addSubview:self.commonBtn];
    }
    return _topView;
}

-(UIView *)previewBottomView {
    if (!_previewBottomView) {
        _previewBottomView = [[UIView alloc] init];
        _previewBottomView.backgroundColor = [UIColor clearColor];
        _previewBottomView.frame = CGRectMake(0, kScreen_Height - (kNavigationBarTop + 64), kScreen_Width, 64);
        
        UIView * background = [[UIView alloc] init];
        background.backgroundColor = [UIColor blackColor];
        background.alpha = 0.6;
        background.frame = _previewBottomView.bounds;
        [_previewBottomView addSubview:background];
        [_previewBottomView addSubview:self.textView];
    }
    return _previewBottomView;
}

-(UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:12];
        _textView.textColor = [UIColor whiteColor];
        _textView.frame = CGRectMake(0, 0, kScreen_Width, 64);
        _textView.editable = NO;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
    }
    return _textView;
}

-(UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"c_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.frame = CGRectMake(0, 20, 50, 40);
    }
    return _backBtn;
}

-(UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setImage:[UIImage imageNamed:@"c_more"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.frame = CGRectMake(kScreen_Width - 60, 20, 60, 40);
    }
    return _moreBtn;
}

-(UIButton *)commonBtn {
    if (!_commonBtn) {
        _commonBtn = [[UIButton alloc] init];
        [_commonBtn setImage:[UIImage imageNamed:@"c_white_msg"] forState:UIControlStateNormal];
        [_commonBtn addTarget:self action:@selector(commonAction) forControlEvents:UIControlEventTouchUpInside];
        _commonBtn.frame = CGRectMake(kScreen_Width - 120, 20, 60, 40);
    }
    return _commonBtn;
}

-(UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = [UIFont systemFontOfSize:16];
        _titleLable.textColor = [UIColor whiteColor];
        _titleLable.frame = CGRectMake((kScreen_Width - 80) / 2, 20, 80, 40);
    }
    return _titleLable;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, kTopMargin,self.view.hx_w + 20, self.view.hx_h - kTopMargin - kBottomMargin) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[PreviewVCViewCell class] forCellWithReuseIdentifier:@"DatePreviewCellId"];
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#else
        if ((NO)) {
#endif
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _collectionView;
}
    
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            
        if (self.outside) {
            _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        }else {
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
#else
        if ((NO)) {
#endif
                _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
            }else {
                _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
            }
        }
    }
    return _flowLayout;
}

- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}
- (void)dealloc {
    PreviewVCViewCell *cell = (PreviewVCViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
    [cell cancelRequest];
    
//    if ([UIApplication sharedApplication].statusBarHidden) {
//        [self.navigationController setNavigationBarHidden:NO animated:NO];
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//    }
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    NSSLog(@"dealloc");
}
    
@end

@interface PreviewVCViewCell ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) CGPoint imageCenter;
@property (strong, nonatomic) UIImage *gifImage;
@property (strong, nonatomic) UIImage *gifFirstFrame;
@property (assign, nonatomic) BOOL livePhotoAnimating;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) UIButton *videoPlayBtn;
@property (strong, nonatomic) HXCircleProgressView *progressView;
@end

@implementation PreviewVCViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.contentView.layer addSublayer:self.playerLayer];
    [self.contentView addSubview:self.videoPlayBtn];
    [self.contentView addSubview:self.progressView];
}
- (void)resetScale {
    [self.scrollView setZoomScale:1.0 animated:NO];
}
    
-(void)resetFrame {
    [self resetScale];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat imgWidth = self.model.imageSize.width;
    CGFloat imgHeight = self.model.imageSize.height;
    CGFloat w;
    CGFloat h;
    
    imgHeight = width / imgWidth * imgHeight;
    if (imgHeight > height) {
        w = height / self.model.imageSize.height * imgWidth;
        h = height;
        self.scrollView.maximumZoomScale = width / w + 0.5;
    }else {
        w = width;
        h = imgHeight;
        self.scrollView.maximumZoomScale = 2.5;
    }
    self.imageView.frame = CGRectMake(0, 0, w, h);
    self.imageView.center = CGPointMake(width / 2, height / 2);
}
    
- (void)setModel:(HXPhotoModel *)model {
    _model = model;
    
    [self cancelRequest];
    
    [self resetFrame];
    
    __weak typeof(self) weakSelf = self;
    if(model.type == HXPhotoModelMediaTypePhoto) {
        self.videoPlayBtn.hidden = YES;
        self.playerLayer.hidden = YES;
        self.imageView.hidden = NO;
        
        [self.imageView sd_setImageWithURL:model.networkPhotoUrl placeholderImage:[UIImage imageNamed:@"c_default_img"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            //NSSLog(@"load image progress : %lf",(float)receivedSize / (float)expectedSize);
            weakSelf.progressView.hidden = NO;
            weakSelf.progressView.progress = (float)receivedSize / (float)expectedSize;
            
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            weakSelf.progressView.hidden = YES;
            self.imageView.image = image;
            model.tempImage = image;
            model.imageSize = image.size;
            
            [weakSelf resetFrame];
        }];
        
    } else if (model.type == HXPhotoModelMediaTypeVideo) {
        self.videoPlayBtn.hidden = NO;
        self.imageView.hidden = NO;
        self.playerLayer.hidden = YES;
        
        //获取图片
        [self.imageView sd_setImageWithURL:model.networkPhotoUrl placeholderImage:[UIImage imageNamed:@"c_default_img"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            //NSSLog(@"load image progress : %lf",(float)receivedSize / (float)expectedSize);
            weakSelf.progressView.hidden = NO;
            weakSelf.progressView.progress = (float)receivedSize / (float)expectedSize;
            
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            weakSelf.progressView.hidden = YES;
            self.imageView.image = image;
            model.tempImage = image;
            model.imageSize = image.size;
            
            [weakSelf resetFrame];
        }];
        
        // setup player
        //AVAsset * avasset = [AVAsset assetWithURL:weakSelf.model.videoURL];
        AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL:weakSelf.model.videoURL];
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
        self.playerLayer.player = self.player;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayerAndShowNaviBar) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
        
    } else {
        self.playerLayer.hidden = YES;
        self.videoPlayBtn.hidden = YES;
        self.imageView.hidden = YES;
    }
}
    
- (void)requestHDImage {
    
}

- (void)pausePlayerAndShowNaviBar {
    [self.player pause];
    self.videoPlayBtn.selected = NO;
    self.imageView.hidden = NO;
    [self.player.currentItem seekToTime:CMTimeMake(0, 1)];
}
    
- (void)cancelRequest {
    self.videoPlayBtn.selected = NO;
    self.progressView.hidden = YES;
    self.progressView.progress = 0;
    
    [self.player pause];
    [self.player seekToTime:kCMTimeZero];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}
    
- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.cellTapClick) {
        self.cellTapClick();
    }
}
- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        CGPoint touchPoint;
        touchPoint = [tap locationInView:self.imageView];
        
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat xsize = width / newZoomScale;
        CGFloat ysize = height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}
    
#pragma mark - < UIScrollViewDelegate >
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}
- (void)didPlayBtnClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [self.player play];
        self.imageView.hidden = YES;
        self.playerLayer.hidden = NO;
    }else {
        [self.player pause];
    }
    if (self.cellDidPlayVideoBtn) {
        self.cellDidPlayVideoBtn(button.selected);
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    self.playerLayer.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.hx_w, self.hx_h);
    self.progressView.center = CGPointMake(self.hx_w / 2, self.hx_h / 2);
}
#pragma mark - < 懒加载 >
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bouncesZoom = YES;
        _scrollView.minimumZoomScale = 1;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_scrollView addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [_scrollView addGestureRecognizer:tap2];
    }
    return _scrollView;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIButton *)videoPlayBtn {
    if (!_videoPlayBtn) {
        _videoPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoPlayBtn setImage:[HXPhotoTools hx_imageNamed:@"multimedia_videocard_play@2x.png"] forState:UIControlStateNormal];
        [_videoPlayBtn setImage:[[UIImage alloc] init] forState:UIControlStateSelected];
        [_videoPlayBtn addTarget:self action:@selector(didPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _videoPlayBtn.frame = self.bounds;
    }
    return _videoPlayBtn;
}
- (HXCircleProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[HXCircleProgressView alloc] init];
    }
    return _progressView;
}
- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [[AVPlayerLayer alloc] init];
        [_playerLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    }
    return _playerLayer;
}
- (void)dealloc {
    [self cancelRequest];
}


@end
