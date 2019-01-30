//
//  XWDatePhotoPreviewViewController.h
//  微博照片选择
//
//  Created by 洪欣 on 2017/10/14.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>
#import "HouseTweet.h"

@class XWDatePhotoPreviewViewController,XWDatePhotoPreviewBottomView,XWDatePhotoPreviewViewCell;
@protocol XWDatePhotoPreviewViewControllerDelegate <NSObject>
@optional
//- (void)datePhotoPreviewControllerDidSelect:(XWDatePhotoPreviewViewController *)previewController model:(HXPhotoModel *)model;
//- (void)datePhotoPreviewControllerDidDone:(XWDatePhotoPreviewViewController *)previewController;
//- (void)datePhotoPreviewDidEditClick:(XWDatePhotoPreviewViewController *)previewController;
//- (void)datePhotoPreviewSingleSelectedClick:(XWDatePhotoPreviewViewController *)previewController model:(HXPhotoModel *)model;
//- (void)datePhotoPreviewDownLoadICloudAssetComplete:(XWDatePhotoPreviewViewController *)previewController model:(HXPhotoModel *)model;
//- (void)datePhotoPreviewSelectLaterDidEditClick:(XWDatePhotoPreviewViewController *)previewController beforeModel:(HXPhotoModel *)beforeModel afterModel:(HXPhotoModel *)afterModel;
@end

@interface XWDatePhotoPreviewViewController : UIViewController<UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) id<XWDatePhotoPreviewViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *modelArray;
@property (assign, nonatomic) NSInteger currentModelIndex;
@property (assign, nonatomic) BOOL outside;
@property (assign, nonatomic) BOOL selectPreview;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) XWDatePhotoPreviewBottomView *bottomView;
- (XWDatePhotoPreviewViewCell *)currentPreviewCell:(TweetImage *)model;
- (void)setSubviewAlphaAnimate:(BOOL)animete;
@end


@interface XWDatePhotoPreviewViewCell : UICollectionViewCell
@property (strong, nonatomic) TweetImage *model;
@property (strong, nonatomic, readonly) UIImageView *imageView;
@property (strong, nonatomic, readonly) UIImage *gifImage;
@property (assign, nonatomic) BOOL dragging;
@property (nonatomic, copy) void (^cellTapClick)();
@property (nonatomic, copy) void (^cellDidPlayVideoBtn)(BOOL play);
@property (nonatomic, copy) void (^cellDownloadICloudAssetComplete)(XWDatePhotoPreviewViewCell *myCell);

- (void)resetScale;
- (void)requestHDImage;
- (void)cancelRequest;
@end
