//
//  XWDatePhotoPreviewViewController.m
//  微博照片选择
//
//  Created by 洪欣 on 2017/10/14.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import "XWDatePhotoPreviewViewController.h"
#import "UIImage+HXExtension.h"
#import "XWDatePhotoPreviewBottomView.h"
#import "UIButton+HXExtension.h"
#import "HXDatePhotoViewTransition.h"
#import "HXDatePhotoInteractiveTransition.h"
#import "HXDatePhotoViewPresentTransition.h"
#import "HXPhotoCustomNavigationBar.h"
#import "HXCircleProgressView.h"
#import "UIViewController+HXExtension.h"
#import "HXPhotoModel.h"

#import "TOCropViewController.h"

#define bottomHeight 143

@interface XWDatePhotoPreviewViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,XWDatePhotoPreviewBottomViewDelegate,TOCropViewControllerDelegate>
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) TweetImage *currentModel;
@property (strong, nonatomic) UIView *customTitleView;
@property (strong, nonatomic) UILabel *titleLb;
@property (strong, nonatomic) UILabel *subTitleLb;
@property (strong, nonatomic) XWDatePhotoPreviewViewCell *tempCell;
@property (strong, nonatomic) UIButton *selectBtn;
@property (assign, nonatomic) BOOL orientationDidChange;
@property (assign, nonatomic) NSInteger beforeOrientationIndex;
@property (strong, nonatomic) HXDatePhotoInteractiveTransition *interactiveTransition;
@property (strong, nonatomic) HXPhotoCustomNavigationBar *navBar;
@property (strong, nonatomic) UINavigationItem *navItem;
@property (assign, nonatomic) BOOL isAddInteractiveTransition;

//@property (strong, nonatomic) HXPhotoModel *currentModel;

@end

@implementation XWDatePhotoPreviewViewController
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
    
    self.view.backgroundColor = kRKBViewControllerBgColor;
    [self wr_setNavBarBarTintColor:kTiMainBgColor];
    [self wr_setNavBarTitleColor:kRKBNAVBLACK];
    [self wr_setNavBarTintColor:kRKBNAVBLACK];
    
    // Do any additional setup after loading the view.
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationWillChanged:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}
//- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
//    if (operation == UINavigationControllerOperationPush) {
//        return [HXDatePhotoViewTransition transitionWithType:HXDatePhotoViewTransitionTypePush];
//    }else {
//        if (![fromVC isKindOfClass:[self class]]) {
//            return nil;
//        }
//        return [HXDatePhotoViewTransition transitionWithType:HXDatePhotoViewTransitionTypePop];
//    }
//}
//- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
//    return self.interactiveTransition.interation ? self.interactiveTransition : nil;
//}
//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    if (self.orientationDidChange) {
//        self.orientationDidChange = NO;
//        [self changeSubviewFrame];
//    }
//}
//- (void)deviceOrientationChanged:(NSNotification *)notify {
//    self.orientationDidChange = YES;
//}
//- (void)deviceOrientationWillChanged:(NSNotification *)notify {
//    self.beforeOrientationIndex = self.currentModelIndex;
//}
//- (XWDatePhotoPreviewViewCell *)currentPreviewCell:(TweetImage *)model {
//    if (!model) {
//        return nil;
//    }
//    return (XWDatePhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
//}
//- (void)changeSubviewFrame {
//    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//    TweetImage *imageModel = self.modelArray[self.currentModelIndex];
//    HXPhotoModel *model = imageModel.beforeModel;
//    if (orientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationPortrait == UIInterfaceOrientationPortraitUpsideDown) {
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//        self.titleLb.hidden = NO;
//        self.customTitleView.frame = CGRectMake(0, 0, 150, 44);
//        self.titleLb.frame = CGRectMake(0, 9, 150, 14);
//        self.subTitleLb.frame = CGRectMake(0, CGRectGetMaxY(self.titleLb.frame) + 4, 150, 12);
//    }else if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//        self.customTitleView.frame = CGRectMake(0, 0, 200, 30);
//        self.titleLb.hidden = YES;
//        self.subTitleLb.frame = CGRectMake(0, 0, 200, 30);
//    }
//    //    CGFloat leftMargin = 0;
//    //    CGFloat rightMargin = 0;
//    CGFloat width = self.view.width;
//    CGFloat itemMargin = 20;
//    if (kDevice_Is_iPhoneX && (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)) {
//        //        leftMargin = 35;
//        //        rightMargin = 35;
//        //        width = self.view.hx_w - 70;
//    }
//    self.flowLayout.itemSize = CGSizeMake(width, self.view.height);
//    self.flowLayout.minimumLineSpacing = itemMargin;
//
//    [self.collectionView setCollectionViewLayout:self.flowLayout];
//
//    //    self.collectionView.contentInset = UIEdgeInsetsMake(0, leftMargin, 0, rightMargin);
//    if (self.outside) {
//        self.navBar.frame = CGRectMake(0, 0, self.view.width, kNavigationBarHeight);
//    }
//    self.collectionView.frame = CGRectMake(-(itemMargin / 2), 0,self.view.width + itemMargin, self.view.height);
//    self.collectionView.contentSize = CGSizeMake(self.modelArray.count * (self.view.width + itemMargin), 0);
//
//    [self.collectionView setContentOffset:CGPointMake(self.beforeOrientationIndex * (self.view.width + itemMargin), 0)];
//
//    [UIView performWithoutAnimation:^{
//        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.beforeOrientationIndex inSection:0]]];
//    }];
//
//    CGFloat bottomViewHeight = self.view.height - bottomHeight;
//    self.bottomView.frame = CGRectMake(0, bottomViewHeight, self.view.width, bottomHeight);
//
//}
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    TweetImage *model = self.modelArray[self.currentModelIndex];
//    self.currentModel = model;
//    XWDatePhotoPreviewViewCell *cell = (XWDatePhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
//    if (!cell) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            XWDatePhotoPreviewViewCell *tempCell = (XWDatePhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
//            self.tempCell = tempCell;
//            [tempCell requestHDImage];
//        });
//    }else {
//        self.tempCell = cell;
//        [cell requestHDImage];
//    }
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
//}
//- (void)viewWillDisappear:(BOOL)animated {
//    XWDatePhotoPreviewViewCell *cell = (XWDatePhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
//    [cell cancelRequest];
//}
- (void)setupUI {
//    self.navigationItem.titleView = self.customTitleView;
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentModelIndex+1,self.modelArray.count];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
//    [self.view addSubview:self.bottomView];
//    self.beforeOrientationIndex = self.currentModelIndex;
//    [self changeSubviewFrame];
}
//- (void)didSelectClick:(UIButton *)button {
//    if (self.modelArray.count <= 0 || self.outside) {
//        return;
//    }
//    TweetImage *model = self.modelArray[self.currentModelIndex];
//    if (button.selected) {
//        button.selected = NO;
//
//    }else {
//        XWDatePhotoPreviewViewCell *cell = (XWDatePhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
//        button.selected = YES;
//        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//        anim.duration = 0.25;
//        anim.values = @[@(1.2),@(0.8),@(1.1),@(0.9),@(1.0)];
//        [button.layer addAnimation:anim forKey:@""];
//    }
//    if (button.selected) {
//        [self.bottomView insertModel:model currentModelIndex:self.currentModelIndex];
//    }else {
//        [self.bottomView deleteModel:model];
//    }
//}
#pragma mark - < UICollectionViewDataSource >
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.modelArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XWDatePhotoPreviewViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DatePreviewCellId" forIndexPath:indexPath];
    TweetImage *model = self.modelArray[indexPath.item];
    cell.model = model;
//    __weak typeof(self) weakSelf = self;
//    [cell setCellDidPlayVideoBtn:^(BOOL play) {
//        if (play) {
//            if (weakSelf.bottomView.userInteractionEnabled) {
//                [weakSelf setSubviewAlphaAnimate:YES];
//            }
//        }else {
//            if (!weakSelf.bottomView.userInteractionEnabled) {
//                [weakSelf setSubviewAlphaAnimate:YES];
//            }
//        }
//    }];
//
//    [cell setCellTapClick:^{
//        [weakSelf setSubviewAlphaAnimate:YES];
//    }];
    return cell;
}
- (void)setSubviewAlphaAnimate:(BOOL)animete {
    BOOL hide = NO;
    if (self.bottomView.alpha == 1) {
        hide = YES;
    }
    if (!hide) {
        [self.navigationController setNavigationBarHidden:hide animated:NO];
    }
    self.bottomView.userInteractionEnabled = !hide;
    if (animete) {
        [[UIApplication sharedApplication] setStatusBarHidden:hide withAnimation:UIStatusBarAnimationFade];
        [UIView animateWithDuration:0.15 animations:^{
            self.navigationController.navigationBar.alpha = hide ? 0 : 1;
            if (self.outside) {
                self.navBar.alpha = hide ? 0 : 1;
            }
            self.view.backgroundColor = hide ? [UIColor blackColor] : [UIColor whiteColor];
            self.collectionView.backgroundColor = hide ? [UIColor blackColor] : [UIColor whiteColor];
            self.bottomView.alpha = hide ? 0 : 1;
        } completion:^(BOOL finished) {
            if (hide) {
                [self.navigationController setNavigationBarHidden:hide animated:NO];
            }
        }];
    }else {
        [[UIApplication sharedApplication] setStatusBarHidden:hide];
        self.navigationController.navigationBar.alpha = hide ? 0 : 1;
        if (self.outside) {
            self.navBar.alpha = hide ? 0 : 1;
        }
        self.view.backgroundColor = hide ? [UIColor blackColor] : [UIColor whiteColor];
        self.collectionView.backgroundColor = hide ? [UIColor blackColor] : [UIColor whiteColor];
        self.bottomView.alpha = hide ? 0 : 1;
        if (hide) {
            [self.navigationController setNavigationBarHidden:hide];
        }
    }
}
//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    [(XWDatePhotoPreviewViewCell *)cell resetScale];
//}
//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    [(XWDatePhotoPreviewViewCell *)cell cancelRequest];
//}
//#pragma mark - < UICollectionViewDelegate >
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView != self.collectionView) {
//        return;
//    }
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat offsetx = self.collectionView.contentOffset.x;
//    NSInteger currentIndex = (offsetx + (width + 20) * 0.5) / (width + 20);
//    if (currentIndex > self.modelArray.count - 1) {
//        currentIndex = self.modelArray.count - 1;
//    }
//    if (currentIndex < 0) {
//        currentIndex = 0;
//    }
//    self.title = [NSString stringWithFormat:@"%ld/%ld",self.modelArray.count,self.currentModelIndex];
//    if (self.modelArray.count > 0) {
//        TweetImage *imageModel = self.modelArray[currentIndex];
//        HXPhotoModel *model = imageModel.beforeModel;
//        if (model.subType == HXPhotoModelMediaSubTypeVideo) {
//            self.bottomView.enabled = NO;
//        }else {
//            self.bottomView.enabled = YES;
//        }
//        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//        if (orientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationPortrait == UIInterfaceOrientationPortraitUpsideDown) {
//            self.titleLb.text = model.barTitle;
//            self.subTitleLb.text = model.barSubTitle;
//        }else if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
//            self.subTitleLb.text = [NSString stringWithFormat:@"%@  %@",model.barTitle,model.barSubTitle];
//        }
//        self.selectBtn.selected = model.selected;
//        [self.selectBtn setTitle:model.selectIndexStr forState:UIControlStateSelected];
//        if (self.outside) {
//        }else {
//        }
//    }
//    self.currentModelIndex = currentIndex;
//}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (self.modelArray.count > 0) {
//        XWDatePhotoPreviewViewCell *cell = (XWDatePhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
//        TweetImage *model = self.modelArray[self.currentModelIndex];
//        self.currentModel = model;
//        [cell requestHDImage];
//    }
//}
//- (void)datePhotoPreviewBottomViewDidItem:(TweetImage *)model currentIndex:(NSInteger)currentIndex beforeIndex:(NSInteger)beforeIndex {
//    if ([self.modelArray containsObject:model]) {
//        NSInteger index = [self.modelArray indexOfObject:model];
//        if (self.currentModelIndex == index) {
//            return;
//        }
//        self.currentModelIndex = index;
//        [self.collectionView setContentOffset:CGPointMake(self.currentModelIndex * (self.view.width + 20), 0) animated:NO];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self scrollViewDidEndDecelerating:self.collectionView];
//        });
//    }else {
//        if (beforeIndex == -1) {
//            [self.bottomView deselectedWithIndex:currentIndex];
//        }
//        self.bottomView.currentIndex = beforeIndex;
//    }
//}
//- (void)datePhotoPreviewBottomViewDidEdit:(XWDatePhotoPreviewBottomView *)bottomView {
////    HXDatePhotoEditViewController *vc = [[HXDatePhotoEditViewController alloc] init];
////    vc.model = [self.modelArray objectAtIndex:self.currentModelIndex];
////    vc.delegate = self;
////    vc.manager = self.manager;
////    if (self.outside) {
////        vc.outside = YES;
////        [self presentViewController:vc animated:NO completion:nil];
////    }else {
////        [self.navigationController pushViewController:vc animated:NO];
////    }
//
//
//    TweetImage *imageModel = [self.modelArray objectAtIndex:self.currentModelIndex];
//    HXPhotoModel *model = imageModel.beforeModel;
//    PHAsset *asset = model.asset;
//    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//    // 同步获得图片, 只会返回1张图片
//    options.synchronous = YES;
//    CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
//    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//
//        if (!result) {
//            return ;
//        }
//        TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:imageModel.image];
//        cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetCustom;
//        cropController.aspectRatioLockEnabled= YES;
//        cropController.resetAspectRatioEnabled = NO;
//        cropController.delegate = self;
//        cropController.doneButtonTitle = @"完成";
//        cropController.cancelButtonTitle = @"取消";
//
//        if (self.outside) {
//            [self presentViewController:cropController animated:NO completion:nil];
//        }else {
//            [self.navigationController pushViewController:cropController animated:NO];
//        }
//    }];
//}
//- (void)datePhotoPreviewBottomViewDidDone:(XWDatePhotoPreviewBottomView *)bottomView {
//
//
//}
//
//- (void)dismissClick {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//#pragma mark - TOCropViewControllerDelegate  修改的裁图回调
//- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
//
//
//    TweetImage *model = self.modelArray[self.currentModelIndex];
//    model.image = image;
//
//    // 处理图片
//
//    self.bottomView.modelArray = self.modelArray;
//    [self.bottomView reloadData];
//
//    self.bottomView.currentIndex = self.currentModelIndex;
//
//    [self.collectionView reloadData];
//
//
//    if (self.outside) {
//        [self dismissClick];
//    } else {
//        [self.navigationController popViewControllerAnimated:NO];
//    }
//
//}
//
//- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
//    if (cancelled) {
//        [cropViewController.navigationController popViewControllerAnimated:NO];
//    }
//}
//
//#pragma mark - < 懒加载 >
//- (HXPhotoCustomNavigationBar *)navBar {
//    if (!_navBar) {
//        CGFloat width = [UIScreen mainScreen].bounds.size.width;
//        _navBar = [[HXPhotoCustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, kNavigationBarHeight)];
//        _navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        [_navBar pushNavigationItem:self.navItem animated:NO];
//    }
//    return _navBar;
//}
//- (UINavigationItem *)navItem {
//    if (!_navItem) {
//        _navItem = [[UINavigationItem alloc] init];
//        _navItem.titleView = self.customTitleView;
//    }
//    return _navItem;
//}
//- (UIView *)customTitleView {
//    if (!_customTitleView) {
//        _customTitleView = [[UIView alloc] init];
//        [_customTitleView addSubview:self.titleLb];
//        [_customTitleView addSubview:self.subTitleLb];
//    }
//    return _customTitleView;
//}
//- (XWDatePhotoPreviewBottomView *)bottomView {
//    if (!_bottomView) {
//        _bottomView = [[XWDatePhotoPreviewBottomView alloc] initWithFrame:CGRectMake(0, self.view.height - 143 , self.view.width, bottomHeight) modelArray:self.modelArray];
//        _bottomView.delagate = self;
//    }
//    return _bottomView;
//}
//- (UIButton *)selectBtn {
//    if (!_selectBtn) {
//        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"Photo_-unselected@2x.png"] forState:UIControlStateNormal];
//        [_selectBtn setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateSelected];
////        if (self.manager.configuration.selectedTitleColor) {
////            [_selectBtn setTitleColor:self.manager.configuration.selectedTitleColor forState:UIControlStateSelected];
////        }
//
//        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        _selectBtn.adjustsImageWhenDisabled = YES;
//        [_selectBtn addTarget:self action:@selector(didSelectClick:) forControlEvents:UIControlEventTouchUpInside];
//        _selectBtn.size = CGSizeMake(24, 24);
//        [_selectBtn setEnlargeEdgeWithTop:0 right:0 bottom:20 left:20];
//        _selectBtn.layer.cornerRadius = 12;
//    }
//    return _selectBtn;
//}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0,self.view.width + 20, self.view.height ) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[XWDatePhotoPreviewViewCell class] forCellWithReuseIdentifier:@"DatePreviewCellId"];
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
//- (void)dealloc {
//    XWDatePhotoPreviewViewCell *cell = (XWDatePhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
//    [cell cancelRequest];
//    if ([UIApplication sharedApplication].statusBarHidden) {
//        [self.navigationController setNavigationBarHidden:NO animated:NO];
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//    }
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
//
//}
@end

@interface XWDatePhotoPreviewViewCell ()<UIScrollViewDelegate,PHLivePhotoViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) CGPoint imageCenter;
@property (strong, nonatomic) UIImage *gifImage;
@property (strong, nonatomic) UIImage *gifFirstFrame;
@property (assign, nonatomic) PHImageRequestID requestID;
@property (strong, nonatomic) PHLivePhotoView *livePhotoView;
@property (assign, nonatomic) BOOL livePhotoAnimating;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) UIButton *videoPlayBtn;
@property (strong, nonatomic) HXCircleProgressView *progressView;
@property (strong, nonatomic) HXPhotoModel *photoModel;
    
@end

@implementation XWDatePhotoPreviewViewCell
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
- (void)setModel:(TweetImage *)model {
    _model = model;
    _photoModel = model.beforeModel;
    [self cancelRequest];
    self.playerLayer.player = nil;
    self.player = nil;
    self.progressView.hidden = YES;
    self.progressView.progress = 0;
    
    [self resetScale];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat imgWidth = self.photoModel.imageSize.width;
    CGFloat imgHeight = self.photoModel.imageSize.height;
    CGFloat w;
    CGFloat h;
    
    imgHeight = width / imgWidth * imgHeight;
    if (imgHeight > height) {
        w = height / self.photoModel.imageSize.height * imgWidth;
        h = height;
        self.scrollView.maximumZoomScale = width / w + 0.5;
    }else {
        w = width;
        h = imgHeight;
        self.scrollView.maximumZoomScale = 2.5;
    }
    self.imageView.frame = CGRectMake(0, 0, w, h);
    self.imageView.center = CGPointMake(width / 2, height / 2);
    
    self.imageView.hidden = NO;
//    __weak typeof(self) weakSelf = self;
    if (self.photoModel.type == HXPhotoModelMediaTypeCameraPhoto || self.photoModel.type == HXPhotoModelMediaTypeCameraVideo) {
        self.imageView.image = _photoModel.thumbPhoto;
        _photoModel.tempImage = nil;
    }else {
        if (self.photoModel.type == HXPhotoModelMediaTypeLivePhoto) {
            if (_photoModel.tempImage) {
                self.imageView.image = _photoModel.tempImage;
                self.photoModel.tempImage = nil;
            }
        }else {
            if (_photoModel.previewPhoto) {
                self.imageView.image = self.photoModel.previewPhoto;
                self.photoModel.tempImage = nil;
            }else {
                if (_photoModel.tempImage) {
                    self.imageView.image = self.photoModel.tempImage;
                    self.photoModel.tempImage = nil;
                }
            }
        }
    }
    if (self.photoModel.subType == HXPhotoModelMediaSubTypeVideo) {
        self.playerLayer.hidden = NO;
        self.videoPlayBtn.hidden = YES;
    }else {
        self.playerLayer.hidden = YES;
        self.videoPlayBtn.hidden = YES;
    }
    
}
- (void)pausePlayerAndShowNaviBar {
    [self.player pause];
    self.videoPlayBtn.selected = NO;
    [self.player.currentItem seekToTime:CMTimeMake(0, 1)];
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
        if (self.photoModel.type == HXPhotoModelMediaTypeLivePhoto) {
            touchPoint = [tap locationInView:self.livePhotoView];
        }else {
            touchPoint = [tap locationInView:self.imageView];
        }
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat xsize = width / newZoomScale;
        CGFloat ysize = height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

#pragma mark - < UIScrollViewDelegate >
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (self.photoModel.type == HXPhotoModelMediaTypeLivePhoto) {
        return self.livePhotoView;
    }else {
        return self.imageView;
    }
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    if (self.photoModel.type == HXPhotoModelMediaTypeLivePhoto) {
        self.livePhotoView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    }else {
        self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    }
}
- (void)didPlayBtnClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [self.player play];
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
    self.scrollView.contentSize = CGSizeMake(self.width, self.height);
    self.progressView.center = CGPointMake(self.width / 2, self.height / 2);
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
    }
    return _imageView;
}
- (PHLivePhotoView *)livePhotoView {
    if (!_livePhotoView) {
        _livePhotoView = [[PHLivePhotoView alloc] init];
        _livePhotoView.clipsToBounds = YES;
        _livePhotoView.contentMode = UIViewContentModeScaleAspectFill;
        _livePhotoView.delegate = self;
    }
    return _livePhotoView;
}
- (UIButton *)videoPlayBtn {
    if (!_videoPlayBtn) {
        _videoPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoPlayBtn setImage:[UIImage imageNamed:@"multimedia_videocard_play@2x.png"] forState:UIControlStateNormal];
        [_videoPlayBtn setImage:[[UIImage alloc] init] forState:UIControlStateSelected];
        [_videoPlayBtn addTarget:self action:@selector(didPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _videoPlayBtn.frame = self.bounds;
        _videoPlayBtn.hidden = YES;
    }
    return _videoPlayBtn;
}
- (HXCircleProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[HXCircleProgressView alloc] init];
        _progressView.hidden = YES;
    }
    return _progressView;
}
- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [[AVPlayerLayer alloc] init];
        _playerLayer.hidden = YES;
    }
    return _playerLayer;
}
- (void)dealloc {
}
@end


