//
//  YHMultiPhotoViewController.m
//  YHMultiPhotoViewController
//
//  Created by wangshiwen on 15/9/14.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import "YAHMultiPhotoViewController.h"
#import "YAHMutiZoomView.h"

#import <AssetsLibrary/AssetsLibrary.h>

#define TOOLbAR_HEIGHT  44.0

typedef NS_ENUM(NSUInteger, ScrollDirection) {
    LEFT,
    RIGHT,
};

@interface YAHMultiPhotoViewController () <
UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) YAHMutiZoomView *prevView;
@property (nonatomic, strong) YAHMutiZoomView *centerView;
@property (nonatomic, strong) YAHMutiZoomView *nextView;
@property (nonatomic, strong) UIToolbar *bottomToolbar;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *photoList;
@property (nonatomic, strong) NSMutableArray *thumbPhotoList;
@property (nonatomic, strong) NSMutableArray *frameList;
@property (nonatomic, strong) ALAssetsLibrary *library;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation YAHMultiPhotoViewController

- (void)dealloc
{
    
}

- (id)initWithImage:(NSArray *)photos thumbImage:(NSArray *)thumbPhotos selectIndex:(NSInteger)index; {
    
    return [self initWithImage:photos thumbImage:thumbPhotos originFrame:nil selectIndex:index];
}

- (id)initWithImage:(NSArray *)photos thumbImage:(NSArray *)thumbPhotos originFrame:(NSArray *)frames selectIndex:(NSInteger)index {
    
    self = [super init];
    if (self) {
        if (photos && thumbPhotos) {
            _photoList = [NSMutableArray arrayWithArray:photos];
            _thumbPhotoList = [NSMutableArray arrayWithArray:thumbPhotos];
        }
        if (frames) {
            _frameList = [NSMutableArray arrayWithArray:frames];
        }
        _currentIndex = index;
        _saveToAlbum = NO;
        _durationAnimation = 0.3f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.bottomToolbar];
    
    [self refreshUI];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

//只支持竖屏
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetX = [self.scrollView contentOffset].x;
    CGFloat width = self.scrollView.frame.size.width;
    
    if (offsetX <= 0 ) {
        [self moveToDirection:RIGHT];
    } else if (offsetX >= width*2){
        [self moveToDirection:LEFT];
    }
}

#pragma mark - Action

- (void)onclose {
    
    if ([self.delegate respondsToSelector:@selector(willHideMultiPhotoView:currentIndex:)]) {
        [self.delegate willHideMultiPhotoView:self currentIndex:self.currentIndex];
    }
    
    self.titleLabel.hidden = YES;
    self.bottomToolbar.hidden = YES;
    if (self.frameList) {
        [self.centerView resumeZoomScale];
        [UIView animateWithDuration:self.durationAnimation animations:^{
            self.maskView.alpha = 0;
            [self.centerView rechangeInitRdct];
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(didHideMultiPhotoView:currentIndex:)]) {
                [self.delegate didHideMultiPhotoView:self currentIndex:self.currentIndex];
            }
        }];
    }else {             //无动画
        if ([self.delegate respondsToSelector:@selector(didHideMultiPhotoView:currentIndex:)]) {
            [self.delegate didHideMultiPhotoView:self currentIndex:self.currentIndex];
        }
    }
}

- (void)saveToAlbumAction:(id)sender {
    
    UIBarButtonItem *saveItem = (UIBarButtonItem *)sender;
    YAHMutiZoomPhoto *photo = [self.photoList objectAtIndex:self.currentIndex];
    UIImage *image = [photo displayImage];
    if (!image) {
        return;
    }
    saveItem.enabled = NO;
    [self performSelector:@selector(saveImageToAblum:) withObject:image afterDelay:0.5f];
}

- (void)saveImageToAblum:(UIImage *)image {
    
    [self.library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            //[[MBProgressHUD_MUIEx instance] showMsg:@"保存图片失败" AutoHideDelay:1.5f];
        }else {
            //[[MBProgressHUD_MUIEx instance] showMsg:@"保存图片成功" AutoHideDelay:1.5f];
        }
        [self.bottomToolbar.items firstObject].enabled = YES;
    }];
}

- (void)startAnimation {
    
    if (self.frameList.count>0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 1.0;
            [self.centerView rechangeNormalRdct];
            self.titleLabel.hidden = (self.photoList.count>1)?NO:YES;
        } completion:^(BOOL finished) {
            self.bottomToolbar.hidden = !self.saveToAlbum;
        }];
    }else {
        self.maskView.alpha = 1.0;
        [self.centerView rechangeNormalRdct];
        self.titleLabel.hidden = (self.photoList.count>1)?NO:YES;
        self.bottomToolbar.hidden = !self.saveToAlbum;
    }
}

#pragma mark - Private

- (void)refreshUI {
    
    if ([self.photoList count] == 0) {
        return;
    }else {
        [self reSetSubView:self.centerView photoIndex:self.currentIndex];
        //动画效果
        [self.centerView rechangeInitRdct];
        [self performSelector:@selector(startAnimation) withObject:nil afterDelay:0.05f];
    }
    
    if ([self.photoList count] > 1) {
        
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width*3, self.scrollView.frame.size.height)];
        
        [self reSetSubView:self.prevView photoIndex:[self getPreIndex]];
        [self reSetSubView:self.nextView photoIndex:[self getNextIndex]];
        
        [self resetFrame];
    } else {
        self.centerView.frame = self.scrollView.bounds;
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        [self.scrollView bringSubviewToFront:self.centerView];
    }
}

- (void)moveToDirection:(ScrollDirection)dir {
    
    YAHMutiZoomView *temp  = nil;
    if (dir == LEFT) {
        
        self.currentIndex = [self getNextIndex];

        temp  = self.prevView;
        self.prevView = self.centerView;
        self.centerView = self.nextView;
        self.nextView = temp;
        
        
        [self reSetSubView:self.nextView photoIndex:[self getNextIndex]];
    } else if (dir == RIGHT) {
        
        self.currentIndex = [self getPreIndex];
        
        temp = self.nextView;
        self.nextView = self.centerView;
        self.centerView = self.prevView;
        self.prevView = temp;
        
        
        [self reSetSubView:self.prevView photoIndex:[self getPreIndex]];
    }
    [self.prevView resumeZoomScale];
    [self.nextView resumeZoomScale];
    
    [self resetFrame];
}

- (void)reSetSubView:(YAHMutiZoomView *)pageView photoIndex:(NSInteger )index {
    
    if (index<0 || index>= self.photoList.count) {
        return;
    }

    CGRect originFrame = CGRectZero;
    if (self.frameList) {
        originFrame = [[self.frameList objectAtIndex:index] CGRectValue];
    }
    [pageView reloadUIWithPhoto:[self.photoList objectAtIndex:index] thumbPhoto:[self.thumbPhotoList objectAtIndex:index] initFrame:originFrame];
}

- (void)resetFrame {
    
    if ([self.photoList count] >1) {
        
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = 0;
        [self.prevView setFrame:frame];
        
        frame.origin.x = self.scrollView.frame.size.width;
        [self.centerView setFrame:frame];
        
        frame.origin.x = self.scrollView.frame.size.width*2;
        [self.nextView setFrame:frame];
        
        CGPoint point = CGPointMake(self.scrollView.frame.size.width, 0);
        [self.scrollView setContentOffset:point];
    }
}

- (NSInteger)getNextIndex {
    
    NSInteger index = self.currentIndex +1;
    
    if (index == [self.photoList count]) {
        index = 0;
    }
    
    return index;
}

- (NSInteger)getPreIndex {
    
    NSInteger index = self.currentIndex -1;
    
    if (index < 0) {
        index = [self.photoList count] -1;
    }
    
    return index;
}

#pragma mark - Custom Accessors

- (ALAssetsLibrary *)library {
    
    if (!_library) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    return _library;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:20.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45f];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        _titleLabel.text = [NSString stringWithFormat:@"%td/%td", self.currentIndex+1, self.photoList.count];
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}

- (UIView *)maskView {
    
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0;
    }
    return _maskView;
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        [_scrollView setDelegate:self];
        [_scrollView setPagingEnabled:YES];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        
        self.prevView = [[YAHMutiZoomView alloc] initWithFrame:self.scrollView.bounds];
        self.prevView.multiPhotoViewCtl = self;
        [_scrollView addSubview:self.prevView];
        
        self.centerView = [[YAHMutiZoomView alloc] initWithFrame:self.scrollView.bounds];
        self.centerView.multiPhotoViewCtl = self;
        [_scrollView addSubview:self.centerView];
        
        self.nextView = [[YAHMutiZoomView alloc] initWithFrame:self.scrollView.bounds];
        self.nextView.multiPhotoViewCtl = self;
        [_scrollView addSubview:self.nextView];
    }
    return _scrollView;
}

- (YAHMutiZoomView *)prevView {
    
    if (!_prevView) {
        _prevView = [[YAHMutiZoomView alloc] initWithFrame:self.scrollView.bounds];
        _prevView.multiPhotoViewCtl = self;
        [self.scrollView addSubview:_prevView];
    }
    
    return _prevView;
}

- (YAHMutiZoomView *)centerView {
    
    if (!_centerView) {
        _centerView = [[YAHMutiZoomView alloc] initWithFrame:self.scrollView.bounds];
        _centerView.multiPhotoViewCtl = self;
        [self.scrollView addSubview:_centerView];
    }
    
    return _centerView;
}

- (YAHMutiZoomView *)nextView{
    
    if (!_nextView) {
        _nextView = [[YAHMutiZoomView alloc] initWithFrame:self.scrollView.bounds];
        _nextView.multiPhotoViewCtl = self;
        [self.scrollView addSubview:_nextView];
    }
    
    return _nextView;
}

- (UIToolbar *)bottomToolbar {
    
    if (!_bottomToolbar) {
        _bottomToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - TOOLbAR_HEIGHT, self.view.frame.size.width, TOOLbAR_HEIGHT)];
        _bottomToolbar.barStyle = UIBarStyleBlackTranslucent;
        _bottomToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _bottomToolbar.hidden = YES;
        //添加下方工具栏按键
        NSMutableArray  *captionItem =[[NSMutableArray alloc] initWithCapacity:1];
        if (self.saveToAlbum) {
            UIBarButtonItem *saveBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveToAlbumAction:)];
            [captionItem addObject:saveBarItem];
        }
        [_bottomToolbar setItems:captionItem];
    }
    return _bottomToolbar;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    _currentIndex = currentIndex;
    self.titleLabel.text = [NSString stringWithFormat:@"%td/%td", _currentIndex+1, self.photoList.count];
}

@end
