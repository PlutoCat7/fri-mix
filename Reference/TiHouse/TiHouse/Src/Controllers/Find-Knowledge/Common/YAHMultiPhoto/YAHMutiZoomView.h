//
//  ZoomView.h
//  YHMultiPhotoViewController
//
//  Created by wangshiwen on 15/9/14.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAHMultiPhotoViewController.h"
#import "YAHMutiZoomPhoto.h"

@class YAHMutiZoomView;
@protocol YAHMutiZoomViewDelegate <NSObject>

- (void)didFinishLoadImageWithView:(YAHMutiZoomView *)zoomView;

@end

@interface YAHMutiZoomView : UIScrollView

@property (nonatomic, weak) YAHMultiPhotoViewController *multiPhotoViewCtl;

@property (nonatomic, weak) id<YAHMutiZoomViewDelegate> delegate;

- (void)reloadUIWithPhoto:(YAHMutiZoomPhoto *)photo thumbPhoto:(YAHMutiZoomPhoto *)thumbPhoto initFrame:(CGRect)rect;

//缩小动画
- (void)rechangeInitRdct;

//正常大小
- (void)rechangeNormalRdct;

//恢复正常的zoomScale
- (void)resumeZoomScale;

- (CGRect)currentImageFrame;

@end
