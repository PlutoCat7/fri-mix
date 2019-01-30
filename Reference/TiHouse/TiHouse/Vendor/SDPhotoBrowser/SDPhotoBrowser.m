//
//  SDPhotoBrowser.m
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "SDBrowserImageView.h"
#import "PSharePopView.h"
#import "HouseInfoViewController.h"
#import "TweetDetailsViewController.h"
#import "Login.h"
#import "HouseTweet.h"
#import "UMShareManager.h"

//  ============在这里方便配置样式相关设置===========

//                      ||
//                      ||
//                      ||
//                     \\//
//                      \/

#import "SDPhotoBrowserConfig.h"

//  =============================================

@interface SDPhotoBrowser()

@property (assign, nonatomic) BOOL collected;
@property (nonatomic, strong) PSharePopView *share;

@end


@implementation SDPhotoBrowser
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
    UILabel *_indexLabel;
    UIButton *_saveButton;
    UIActivityIndicatorView *_indicatorView;
    BOOL _willDisappear;
    UILabel *_countLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SDPhotoBrowserBackgrounColor;
    }
    return self;
}


- (void)didMoveToSuperview
{
    [self setupScrollView];
    if (_browserType == PhotoBrowserTyoeTyoeTimerShaft) {
        [self setupTimerShaftToolbars];
    }
}

- (void)dealloc
{
    [[UIApplication sharedApplication].keyWindow removeObserver:self forKeyPath:@"frame"];
}

- (void)setupTimerShaftToolbars
{
    
    UIView *NavBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kDevice_Is_iPhoneX ? 88 : 64)];
    NavBar.backgroundColor = [UIColor clearColor];
    NavBar.tag = 111;
    [self addSubview:NavBar];
    [self bringSubviewToFront:NavBar];
    // 2.更多
    UIButton *moreButton = [[UIButton alloc] init];
    [moreButton setImage:[UIImage imageNamed:@"c_more"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    [NavBar addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(NavBar);
        make.width.equalTo(@(moreButton.imageView.image.size.width*2.5));
    }];
    
    // 3.评论
    if (self.showCommentButton) {
        UIButton *commentButton = [[UIButton alloc] init];
        [commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [commentButton addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
        [NavBar addSubview:commentButton];
        [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(NavBar);
            make.right.equalTo(NavBar).offset(-50);
            make.width.equalTo(@(moreButton.imageView.image.size.width*2.5));
        }];
    }
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.font = [UIFont systemFontOfSize:16];
    [NavBar addSubview:_countLabel];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moreButton);
        make.centerX.equalTo(NavBar);
    }];
    
    // MARK: - modify by Charles Zou
    _countLabel.text = [NSString stringWithFormat:@"%d / %d", (int)_currentImageIndex + 1, self.dairy ? (int)self.dairy.fileJA.count : (int)self.imageCount];
    
    //    if (self.imageCount == 1) {
    //        _countLabel.text = [NSString stringWithFormat:@"%ld / %ld",(long)_currentImageIndex + 1,self.imageCount];
    //    } else {
    //        _countLabel.text = [NSString stringWithFormat:@"%ld / %lu",(long)_currentImageIndex + 1,(unsigned long)_dairy.arrurlfileArr.count];
    //    }
    
    if (_isVideo) {
        UIButton *closeButton = [[UIButton alloc] init];
        [closeButton setImage:[UIImage imageNamed:@"c_back"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(videoClose) forControlEvents:UIControlEventTouchUpInside];
        [NavBar addSubview:closeButton];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(NavBar);
            make.width.equalTo(@(moreButton.imageView.image.size.width*2.5));
        }];
    }
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    //    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/file/isColl" withParams:@{@"urlfile":_dairy.arrurlfileArr[_currentImageIndex],@"uid":[NSNumber numberWithLong:[Login curLoginUserID]]} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
    //        if ([data[@"success"] intValue]) {
    //            _collected = YES;
    //        }
    //    }];
    
}

-(void)more{
    if ([self.subviews containsObject:_share]) {
        [_share close];
        _share = nil;
        return;
    }
    NSInteger fileid = 0;
    NSString *fileurl = @"";
    NSString *housename = @"";
    NSString *thumb = @"";
    if (_dairy) {
        FileModel *fileModel = [SHValue value:_dairy.fileJA][_currentImageIndex].value;
        fileurl = fileModel.urlshare;
        fileurl = [SHValue value:fileurl].stringValue;
        thumb = _dairy.urlshare;
        fileid = fileModel.fileid;
        housename = _dairy.housename;
    } else {
        fileurl = _cloudReCollectItem.urlfile;
        fileid = self.cloudReCollectItem.fileid;
        housename = self.cloudReCollectItem.housename;
        thumb = self.cloudReCollectItem.urlshare;
    }
    NSDictionary *params = @{@"fileid": [NSString stringWithFormat:@"%ld", (long)fileid]};
    
    _share = [[PSharePopView alloc]init];
    [self addSubview:_share];
    
    [[TiHouseNetAPIClient sharedJsonClient]
     requestJsonDataWithPath:@"/api/inter/file/isColl"
     withParams:params
     withMethodType:Post
     autoShowError:NO
     andBlock:^(id data, NSError *error) {
         if ([SHValue value:data][@"success"].boolValue) {
             if ([data[@"msg"] isEqualToString:@"有收藏"]) {
                 _share.collected = YES;
             } else {
                 _share.collected = NO;
             }
         }
         [_share show];
     }];
    
    WEAKSELF
    _share.ClickBtnWithTag = ^(NSInteger tag) {
        STRONGSELF
        if (tag<=4) {
            [strongSelf Share:tag file:fileurl housename:housename thumb:thumb];
        }
        if (tag == 5) {
            [[TiHouseNetAPIClient sharedJsonClient]
             requestJsonDataWithPath:@"/api/inter/file/editTypecollect"
             withParams:params
             withMethodType:Post
             autoShowError:YES
             andBlock:^(id data, NSError *error) {
                 
                 if ([SHValue value:data][@"success"].boolValue) {
                     [NSObject showHudTipStr:data[@"msg"]];
                     if ([data[@"msg"] isEqualToString:@"取消收藏成功"]) {
                         strongSelf.collected = NO;
                     } else {
                         strongSelf.collected = YES;
                     }
                 }
             }];
        }
        if (tag == 6) {
            if (strongSelf.isVideo) {
                [strongSelf playerDownload:[self highQualityImageURLForIndex:0]];
            } else {
                [strongSelf saveImage];
            }
        }
    };
}

- (void)videoClose{
    _scrollView.hidden = YES;
    _willDisappear = YES;
    SDBrowserImageView *currentImageView = _scrollView.subviews.firstObject;
    NSInteger currentIndex = currentImageView.tag;
    
    UIView *sourceView = nil;
    if ([self.sourceImagesContainerView isKindOfClass:UICollectionView.class]) {
        UICollectionView *view = (UICollectionView *)self.sourceImagesContainerView;
        // MARK: - bug fix by Marblue
        NSIndexPath *path = [NSIndexPath indexPathForItem:currentIndex inSection:_currentImageSection ? : 0];
        sourceView = [view cellForItemAtIndexPath:path];
    }else {
        sourceView = self.sourceImagesContainerView.subviews[currentIndex];
    }
    
    CGRect targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    //    tempView.contentMode = sourceView.contentMode;
    tempView.contentMode = UIViewContentModeScaleAspectFill;
    tempView.clipsToBounds = YES;
    tempView.image = currentImageView.image;
    CGFloat h = (self.bounds.size.width / currentImageView.image.size.width) * currentImageView.image.size.height;
    
    if (!currentImageView.image) { // 防止 因imageview的image加载失败 导致 崩溃
        h = self.bounds.size.height;
    }
    
    tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
    tempView.center = self.center;
    
    [self addSubview:tempView];
    
    _saveButton.hidden = YES;
    
    [UIView animateWithDuration:SDPhotoBrowserHideImageAnimationDuration animations:^{
        tempView.frame = targetTemp;
        self.backgroundColor = [UIColor clearColor];
        _indexLabel.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_player _deallocPlayer];
        [UIApplication sharedApplication].statusBarHidden = NO;
    }];
}

- (void)setupToolbars
{
    
    UIView *NavBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kDevice_Is_iPhoneX ? 88 : 64)];
    NavBar.backgroundColor = XWColorFromHexAlpha(0x44444b, 0.9);
    [self addSubview:NavBar];
    
    
    // 1. 序标
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.bounds = CGRectMake(0, 0, 80, 44);
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont fontWithName:@"Heiti SC" size:15];
    indexLabel.layer.cornerRadius = indexLabel.bounds.size.height * 0.5;
    indexLabel.clipsToBounds = YES;
    if (self.imageCount > 1) {
        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
    }
    _indexLabel = indexLabel;
    [NavBar addSubview:indexLabel];
    
    // 2.保存按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    saveButton.layer.cornerRadius = 5;
    saveButton.clipsToBounds = YES;
    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    _saveButton = saveButton;
    [self addSubview:saveButton];
}

- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    UIImageView *currentImageView = _scrollView.subviews[index];
    
    UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    //    [NSObject showHudTipStr:@"图片保存成功！"];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = SDPhotoBrowserSaveImageFailText;
    }   else {
        label.text = SDPhotoBrowserSaveImageSuccessText;
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_scrollView];
    
    for (int i = 0; i < self.imageCount; i++) {
        SDBrowserImageView *imageView = [[SDBrowserImageView alloc] init];
        imageView.tag = i;
        
        // 单击图片
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        
        // 双击放大图片
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTaped:)];
        doubleTap.numberOfTapsRequired = 2;
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        [imageView addGestureRecognizer:singleTap];
        [imageView addGestureRecognizer:doubleTap];
        [_scrollView addSubview:imageView];
    }
    
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    SDBrowserImageView *imageView = _scrollView.subviews[index];
    self.currentImageIndex = index;
    if (imageView.hasLoadedImage) return;
    NSURL *url = [self highQualityImageURLForIndex:index];
    
    if (url) {
        if (self.isVideo) {
            //            url = [NSURL URLWithString:[_dairy.fileJA firstObject].fileurl];
            url = _dairy.fileJA.count == 0 ? url : [NSURL URLWithString:[_dairy.fileJA firstObject].fileurl];
            SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
            configuration.shouldAutoPlay = YES;
            configuration.supportedDoubleTap = YES;
            configuration.shouldAutorotate = YES;
            //            configuration.repeatPlay = YES;
            configuration.statusBarHideState = SelStatusBarHideStateFollowControls;
            configuration.sourceUrl = url;
            configuration.videoGravity = SelVideoGravityResizeAspect;
            CGFloat width = self.frame.size.width;
            self.player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, 0, width, self.frame.size.height) configuration:configuration];
            [self addSubview:self.player];
            
        }else{
            [imageView setImageWithURL:url placeholderImage:[self placeholderImageForIndex:index]];
        }
    } else {
        if (self.isVideo) {
            //            url = [NSURL URLWithString:[_dairy.fileJA firstObject].fileurl];
            url = _dairy.fileJA.count == 0 ? url : [NSURL URLWithString:[_dairy.fileJA firstObject].fileurl];
            SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
            configuration.shouldAutoPlay = YES;
            configuration.supportedDoubleTap = YES;
            configuration.shouldAutorotate = YES;
            //            configuration.repeatPlay = YES;
            configuration.statusBarHideState = SelStatusBarHideStateFollowControls;
            configuration.sourceUrl = url;
            configuration.videoGravity = SelVideoGravityResizeAspect;
            CGFloat width = self.frame.size.width;
            self.player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, 0, width, self.frame.size.height) configuration:configuration];
            [self addSubview:self.player];
        } else {
            imageView.image = [self placeholderImageForIndex:index];
        }
    }
    imageView.hasLoadedImage = YES;
}

- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    _scrollView.hidden = YES;
    _willDisappear = YES;
    
    SDBrowserImageView *currentImageView = (SDBrowserImageView *)recognizer.view;
    NSInteger currentIndex = currentImageView.tag;
    
    UIView *sourceView = nil;
    if ([self.sourceImagesContainerView isKindOfClass:UICollectionView.class]) {
        UICollectionView *view = (UICollectionView *)self.sourceImagesContainerView;
        // MARK: - bug fix by Marblue
        NSIndexPath *path = [NSIndexPath indexPathForItem:currentIndex inSection:_currentImageSection ? : 0];
        sourceView = [view cellForItemAtIndexPath:path];
    }else {
        sourceView = self.sourceImagesContainerView.subviews[currentIndex];
    }
    
    
    
    CGRect targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    //    tempView.contentMode = sourceView.contentMode;
    tempView.contentMode = UIViewContentModeScaleAspectFill;
    tempView.clipsToBounds = YES;
    tempView.image = currentImageView.image;
    CGFloat h = (self.bounds.size.width / currentImageView.image.size.width) * currentImageView.image.size.height;
    
    if (!currentImageView.image) { // 防止 因imageview的image加载失败 导致 崩溃
        h = self.bounds.size.height;
    }
    
    tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
    tempView.center = self.center;
    
    [self addSubview:tempView];
    
    _saveButton.hidden = YES;
    
    [UIView animateWithDuration:SDPhotoBrowserHideImageAnimationDuration animations:^{
        tempView.frame = targetTemp;
        self.backgroundColor = [UIColor clearColor];
        _indexLabel.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [UIApplication sharedApplication].statusBarHidden = NO;
    }];
}

- (void)imageViewDoubleTaped:(UITapGestureRecognizer *)recognizer
{
    SDBrowserImageView *imageView = (SDBrowserImageView *)recognizer.view;
    CGFloat scale;
    if (imageView.isScaled) {
        scale = 1.0;
    } else {
        scale = 2.0;
    }
    
    SDBrowserImageView *view = (SDBrowserImageView *)recognizer.view;
    
    [view doubleTapToZommWithScale:scale];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.width += SDPhotoBrowserImageViewMargin * 2;
    
    _scrollView.bounds = rect;
    _scrollView.center = self.center;
    
    CGFloat y = 0;
    CGFloat w = _scrollView.frame.size.width - SDPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;
    
    
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(SDBrowserImageView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = SDPhotoBrowserImageViewMargin + idx * (SDPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
    
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    
    _indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, _indexLabel.superview.height-kDevice_Is_iPhoneX?44:20);
    _saveButton.frame = CGRectMake(30, self.bounds.size.height - 70, 50, 25);
    
    for (UIView *tmpView in self.subviews)
    {
        if (tmpView.tag == 111)
        {
            [self bringSubviewToFront:tmpView];
        }
    }
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addObserver:self forKeyPath:@"frame" options:0 context:nil];
    [window addSubview:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        self.frame = object.bounds;
        SDBrowserImageView *currentImageView = _scrollView.subviews[_currentImageIndex];
        if ([currentImageView isKindOfClass:[SDBrowserImageView class]]) {
            [currentImageView clear];
        }
    }
}

- (void)showFirstImage
{
    UIView *sourceView = nil;
    
    if ([self.sourceImagesContainerView isKindOfClass:UICollectionView.class]) {
        UICollectionView *view = (UICollectionView *)self.sourceImagesContainerView;
        // MARK: - bug fix by Marblue
        NSIndexPath *path = [NSIndexPath indexPathForItem:self.currentImageIndex inSection:_currentImageSection ? : 0];
        sourceView = [view cellForItemAtIndexPath:path];
    }else {
        sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
    }
    CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
    
    [self addSubview:tempView];
    
    CGRect targetTemp = [_scrollView.subviews[self.currentImageIndex] bounds];
    
    tempView.frame = rect;
    //    tempView.contentMode = [_scrollView.subviews[self.currentImageIndex] contentMode];
    tempView.contentMode = UIViewContentModeScaleAspectFit;
    _scrollView.hidden = YES;
    
    
    [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
        tempView.center = self.center;
        tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
    } completion:^(BOOL finished) {
        _hasShowedFistView = YES;
        [tempView removeFromSuperview];
        _scrollView.hidden = NO;
    }];
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    
    // 有过缩放的图片在拖动一定距离后清除缩放
    CGFloat margin = 150;
    CGFloat x = scrollView.contentOffset.x;
    if ((x - index * self.bounds.size.width) > margin || (x - index * self.bounds.size.width) < - margin) {
        SDBrowserImageView *imageView = _scrollView.subviews[index];
        if (imageView.isScaled) {
            [UIView animateWithDuration:0.5 animations:^{
                imageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [imageView eliminateScale];
            }];
        }
    }
    
    
    if (!_willDisappear) {
        _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    }
    [self setupImageOfImageViewForIndex:index];
    //    _countLabel.text = [NSString stringWithFormat:@"%d / %lu", index + 1,(unsigned long) _dairy.arrurlfileArr.count];
    
    _countLabel.text = [NSString stringWithFormat:@"%d / %d", (int)_currentImageIndex + 1, self.dairy ? (int)self.dairy.fileJA.count : (int)self.imageCount];
}


//分享
-(void)Share:(NSInteger)tag file:(NSString*)file housename:(NSString *)housename thumb:(NSString *)thumb {
    WEAKSELF
    NSString *platform;
    NSInteger UMSocialPlatformType = 0;
    switch (tag) {
        case 1:
            UMSocialPlatformType = UMSocialPlatformType_WechatSession;
            platform = @"1";
            break;
            
        case 2:
            UMSocialPlatformType = UMSocialPlatformType_WechatTimeLine;
            platform = @"2";
            break;
            
        case 3:
            UMSocialPlatformType = UMSocialPlatformType_QQ;
            platform = @"3";
            break;
            
        case 4:
            UMSocialPlatformType = UMSocialPlatformType_Sina;
            platform = @"4";
            break;
        default:
            break;
            
    }
    
    if ([file containsString:@".mp4"]) {
        
        NSString *content;
        NSString *url;
        if (!_dairy) {
            content = self.cloudReCollectItem.dairydesc.length > 0 ? [self.cloudReCollectItem.dairydesc stringByRemovingPercentEncoding] :[NSString stringWithFormat:@"快来看看“%@”哪里不一样了呢?", housename];
            url = self.cloudReCollectItem.linkshare;
        } else {
            content = _dairy.dairydesc.length > 0 ? [_dairy.dairydesc stringByRemovingPercentEncoding] :[NSString stringWithFormat:@"快来看看“%@”哪里不一样了呢?", housename];
            url = _dairy.linkshare;
        }
        
        UMShareWebpageObject *WebpageObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"“%@”的新变化", housename] descr:content thumImage:thumb];
        WebpageObject.webpageUrl = url;
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObjectWithMediaObject:WebpageObject];
        if ([platform isEqualToString:@"4"]) {
            [[[UMShareManager alloc] init] webShare:[platform integerValue] - 1 title:[NSString stringWithFormat:@"快来看看“%@”的新变化吧！%@", housename, url] content:@"" url:_dairy.linkshare image:thumb complete:^(NSInteger state) {
                switch (state) {
                    case 0: {
                        [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@(1),@"typeid":@(weakSelf.dairy.dairyid),@"platform":platform} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
                            
                        }];
                    }
                        break;
                    case 1: {
                        
                    }
                        break;
                    default:
                        break;
                }
            }];

        } else {
                    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType messageObject:messageObject currentViewController:[HouseInfoViewController new] completion:^(id result, NSError *error) {
                        if (!error) {
                            [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@(1),@"typeid":@(weakSelf.dairy.dairyid),@"platform":platform} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
            
                            }];
                        }
                    }];

        }
        
    } else {
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        [shareObject setShareImage:thumb];
//        if (UMSocialPlatformType == UMSocialPlatformType_Sina) {
//            [shareObject setTitle:[NSString stringWithFormat:@"快来看看“%@”的新变化吧！%@", _dairy.housename, _dairy.linkshare]];
//        }
        messageObject.shareObject = shareObject;
        if ([platform isEqualToString:@"4"]) {
            
            NSString *mainTitle;
            NSString *url;
            if (_dairy.linkshare.length > 0) {
                mainTitle = [NSString stringWithFormat:@"快来看看“%@”的新变化吧！%@", housename, _dairy.linkshare];
                url = _dairy.linkshare;
            } else {
                mainTitle = [NSString stringWithFormat:@"快来看看“%@”的新变化吧！%@", housename, self.cloudReCollectItem.linkshare];
                url = self.cloudReCollectItem.linkshare;
            }
            
            [[[UMShareManager alloc] init] webShare:[platform integerValue] - 1 title:mainTitle content:@"" url:url image:thumb complete:^(NSInteger state) {
                switch (state) {
                    case 0: {
                        [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@(1),@"typeid":@(weakSelf.dairy.dairyid),@"platform":platform} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
                            
                        }];
                    }
                        break;
                    case 1: {
                        
                    }
                        break;
                    default:
                        break;
                }
            }];
        } else {
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
                if (!error) {
                    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/inter/share/notifySuccess" withParams:@{@"type":@(1),@"typeid":@(weakSelf.dairy.dairyid),@"platform":platform} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
                        
                    }];
                }else{
                    NSLog(@"************Share fail with error %@*********",error);
                }
            }];

        }
        
    }
}

//-----下载视频--
- (void)playerDownload:(NSURL *)url{
    [NSObject showHUDQueryStr:@"正在保存视频"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"jaibaili.mp4"];
    //    NSURL *urlNew = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task =
    [manager downloadTaskWithRequest:request
                            progress:nil
                         destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                             return [NSURL fileURLWithPath:fullPath];
                         }
                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                       if (error == nil) {
                           [self saveVideo:fullPath];
                       }
                   }];
    [task resume];
    
}

//videoPath为视频下载到本地之后的本地路径
- (void)saveVideo:(NSString *)videoPath{
    
    if (videoPath) {
        NSURL *url = [NSURL URLWithString:videoPath];
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
        if (compatible)
        {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}


//保存视频完成之后的回调
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    [NSObject hideHUDQuery];
    if (error) {
        XWLog(@"保存视频失败%@", error.localizedDescription);
        [NSObject showHudTipStr:@"视频保存失败！"];
    }
    else {
        XWLog(@"保存视频成功");
        
        [NSObject showHudTipStr:@"视频保存成功！"];
    }
}


# pragma 评论
- (void) comment {
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"/api/inter/dairy/getnew" withParams:@{@"dairyid":@(_cloudReCollectItem.dairyid)} withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            if (_isVideo) [self videoClose];
            TweetDetailsViewController *tweetDetailsVC = [[TweetDetailsViewController alloc] init];
            Dairy *newDairy = [Dairy mj_objectWithKeyValues:[SHValue value:data][@"data"].dictionaryValue];
            modelDairy *dairy = [modelDairy alloc];
            dairy.dairy = newDairy;
            dairy.nickname = newDairy.nickname;
            tweetDetailsVC.modelDairy = dairy;
            House *house = [House alloc];
            house.houseid = dairy.dairy.houseid;
            house.housename = dairy.dairy.housename;
            tweetDetailsVC.house = house;
            tweetDetailsVC.title = self.cloudReCollectItem.housename;
            tweetDetailsVC.dairyid = dairy.dairy.dairyid;
            if (_showCommentBlock) {
                _showCommentBlock(tweetDetailsVC);
            }
        }
    }];
    
    
}

@end

