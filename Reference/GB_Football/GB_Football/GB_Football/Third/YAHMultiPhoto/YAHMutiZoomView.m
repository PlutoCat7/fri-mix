//
//  ZoomView.m
//  YHMultiPhotoViewController
//
//  Created by wangshiwen on 15/9/14.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import "YAHMutiZoomView.h"
#import "HAVPlayer.h"

@interface YAHMutiZoomView () <
UIScrollViewDelegate, HAVPlayerDelegate>

@property (nonatomic,strong) HAVPlayer *player;//播放器对象

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) YAHMutiZoomPhoto *photo;
@property (nonatomic, strong) YAHMutiZoomPhoto *thumbPhoto;
@property (nonatomic, assign) CGRect initRect;              //小图的frame
@property (nonatomic, assign) CGRect scaleOriginRect;       //全屏的frame

@end

@implementation YAHMutiZoomView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.clipsToBounds = YES;
        [self initSubviews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleMWPhotoLoadingDidEndNotification:)
                                                     name:MWPHOTO_LOADING_DID_END_NOTIFICATION
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMWPhotoLoadingFailed:) name:MWPHOTO_FAIl_NOTIFICATION object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleMWPhotoDownloading:)
                                                     name:MWPHOTO_PROGRESS_NOTIFICATION
                                                   object:nil];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch  =[touches anyObject];
    if (2 == touch.tapCount) {
        [self handleDoubleTap:[touch locationInView:self.imageView]];
    }else if(1 == touch.tapCount){
        [self handleSingleTap:[touch locationInView:self.imageView]];
    }
    [[self nextResponder] touchesEnded:touches withEvent:event];
}

#pragma mark - Public

- (void)reloadUIWithPhoto:(YAHMutiZoomPhoto *)photo thumbPhoto:(YAHMutiZoomPhoto *)thumbPhoto initFrame:(CGRect)rect {
    
    [self.indicatorView stopAnimating];
    self.zoomScale = 1.0f;
    _photo = photo;
    _thumbPhoto = thumbPhoto;
    _initRect = rect;
    self.imageView.frame = rect;
    self.imageView.image = nil;   //
    if (self.photo.state == 0) {
        if (self.player) {
            [self.player stopPlayer];
            [self.player removeFromSuperview];
        }
        if ([self.photo displayImage]) {
            [self setImage:[self.photo displayImage]];
        }else {
            [self.photo downLoadDisplayImage];
            if ([self.thumbPhoto displayImage]) {
                [self setImage:[self.thumbPhoto displayImage]];
                self.contentOffset = CGPointZero;
                [self setNeedsLayout];
            }else {
                [self.thumbPhoto downLoadDisplayImage];
            }
        }
    }else {
        if ([self.thumbPhoto displayImage]) {
            [self setImage:[self.thumbPhoto displayImage]];
            self.contentOffset = CGPointZero;
            [self setNeedsLayout];
        }
        self.player = [[HAVPlayer alloc] initWithFrame:self.bounds withShowInView:self url:self.photo.videoUrl];
        self.player.backgroundColor = [UIColor clearColor];
        self.player.delegate = self;
        self.player.isShowPlayButton = YES;
        self.player.isShowCloseButton = YES;
    }
}

- (void)rechangeNormalRdct {
    
    self.imageView.frame = self.scaleOriginRect;
}

- (void)rechangeInitRdct {
    
    self.imageView.frame = self.initRect;
}

- (void)resumeZoomScale {
    
    [self.player restorePlayer];
    self.zoomScale = 1.0f;
}

#pragma mark - NSNotification

- (void)handleMWPhotoLoadingDidEndNotification:(NSNotification *)notification {
    
    YAHMutiZoomPhoto *photo = [notification object];
    if (self.photo == photo ||
        self.thumbPhoto == photo) {
        if ([self.photo displayImage]) {
            [self setImage:[self.photo displayImage]];
        } else if([self.thumbPhoto displayImage]) {
            [self setImage:[self.thumbPhoto displayImage]];
            self.contentOffset = CGPointZero;
            [self setNeedsLayout];
        }
    }
    if (self.photo == photo) {
        [self.indicatorView stopAnimating];
    }
}

- (void)handleMWPhotoLoadingFailed:(NSNotification *)notification{
    
    YAHMutiZoomPhoto *photo = [notification object];
    if (self.photo == photo) {
        [self.indicatorView stopAnimating];
    }
}

- (void)handleMWPhotoDownloading:(NSNotification *)notification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic =(NSDictionary *)notification.object;
        YAHMutiZoomPhoto *ph = [dic objectForKey:@"photo"];
        if (ph == self.photo) {
            [self.indicatorView startAnimating];
        }
    });
}

#pragma mark - Custom Accessors

- (void)setImage:(UIImage *)image {
    
    self.maximumZoomScale = 1;
    self.zoomScale = 1;
    //self.contentSize = CGSizeMake(0, 0);
    
    if (image) {
        self.imageView.image = image;
        CGRect photoImageViewFrame;
        photoImageViewFrame.origin = CGPointZero;
        photoImageViewFrame.size = image.size;
        self.scaleOriginRect = photoImageViewFrame;
        
        // 设置控件的缩放比例，使图片全屏显示
        [self setMaxMinZoomScalesForCurrentBounds];
    }
    self.contentSize = self.scaleOriginRect.size;
    self.scaleOriginRect = [self rectToCenter:self.scaleOriginRect];
    self.imageView.frame = self.scaleOriginRect;
}

- (UIActivityIndicatorView *)indicatorView {
    
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:_indicatorView];
        _indicatorView.center = self.center;
    }
    return _indicatorView;
}

#pragma mark - scrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    [self judegeScrollEnabled];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark HAVPlayerDelegate

- (void)HAVPlayerDidClose:(HAVPlayer *)player {
    
    [_multiPhotoViewCtl performSelector:@selector(onclose) withObject:nil];
}

#pragma mark - Private

- (void)initSubviews {
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.imageView];
    
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)setMaxMinZoomScalesForCurrentBounds {
    
    self.maximumZoomScale = 3.0f;
    self.zoomScale = 1;
    
    if (self.imageView.image == nil) return;
    
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = self.imageView.image.size;
    CGFloat xScale = boundsSize.width / imageSize.width;    // 自动适应图片宽度
    CGFloat yScale = boundsSize.height / imageSize.height;  // 自动适应图片高度
    CGFloat minScale = MIN(xScale, yScale);                 // 使图片全屏显示
    
    // 如果图片比控件小则不放大!
    if (xScale >= 1 && yScale >= 1) {
        minScale = 1.0;
    }
    
    // 重新定位控件
    self.scaleOriginRect = CGRectMake(0, 0, self.scaleOriginRect.size.width*minScale, self.scaleOriginRect.size.height*minScale);

    [self setNeedsLayout];
    
}

- (CGRect)rectToCenter:(CGRect)rect {
    
    // 将图片置于屏幕中心
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = rect;
    
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    return frameToCenter;
}

- (void)handleSingleTap:(CGPoint)touchPoint {
    
    //0.3s 表示等待第二次点击响应的时间
    [_multiPhotoViewCtl performSelector:@selector(onclose) withObject:nil afterDelay:0.3];
}

- (void)handleDoubleTap:(CGPoint)touchPoint {
    
    //视频不响应双击事件
    if (self.photo.state == 1) {
        return;
    }
    
    // 取消handleSingleTap
    [NSObject cancelPreviousPerformRequestsWithTarget:_multiPhotoViewCtl];
    
    // 方法图片回缩
    if (self.zoomScale > 1) {
        [UIView animateWithDuration:0.3 animations:^{
            
            [self setZoomScale:1 animated:NO];
            self.imageView.frame = [self rectToCenter:self.imageView.frame];
        }];
    } else {
        // 放大两倍，异型图则减少放大倍数
        CGFloat newZoomScale = 3;
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:NO];
            [self judegeScrollEnabled];
            self.imageView.frame = [self rectToCenter:self.imageView.frame];
        }];
    }
}

- (void)judegeScrollEnabled {
    
    self.scrollEnabled = self.zoomScale>1;
}

#pragma mark - Getters and Setters

- (void)setZoomScale:(CGFloat)scale animated:(BOOL)animated {
    
    [super setZoomScale:scale animated:animated];
    self.scrollEnabled = scale>1;
}

@end
