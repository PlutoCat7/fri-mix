//
//  PreviewVC.h
//  微博照片选择
//
//  Created by 陈晨昕 on 2018/1/31.
//  Copyright © 2018年 洪欣. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <PhotosUI/PhotosUI.h>
#import "HXPhotoManager.h"

@class PreviewVC,HXDatePhotoPreviewBottomView,PreviewVCViewCell,HXPhotoView;
@protocol PreviewVCDelegate <NSObject>
@optional
- (void)datePhotoPreviewControllerDidSelect:(PreviewVC *)previewController model:(HXPhotoModel *)model;
- (void)datePhotoPreviewControllerDidDone:(PreviewVC *)previewController;
- (void)datePhotoPreviewDidEditClick:(PreviewVC *)previewController;
- (void)datePhotoPreviewSingleSelectedClick:(PreviewVC *)previewController model:(HXPhotoModel *)model;
- (void)datePhotoPreviewDownLoadICloudAssetComplete:(PreviewVC *)previewController model:(HXPhotoModel *)model;
- (void)datePhotoPreviewSelectLaterDidEditClick:(PreviewVC *)previewController beforeModel:(HXPhotoModel *)beforeModel afterModel:(HXPhotoModel *)afterModel;
@end

@interface PreviewVC : UIViewController<UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) id<PreviewVCDelegate> delegate;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) NSMutableArray *modelArray;
@property (strong, nonatomic) NSArray *cloudReCollectItemArray;
@property (assign, nonatomic) NSInteger currentModelIndex;
@property (assign, nonatomic) BOOL outside;
@property (assign, nonatomic) BOOL selectPreview;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIView * previewBottomView;
@property (strong, nonatomic) HXDatePhotoPreviewBottomView *bottomView;
@property (strong, nonatomic) HXPhotoView *photoView;
- (PreviewVCViewCell *)currentPreviewCell:(HXPhotoModel *)model;
- (void)setSubviewAlphaAnimate:(BOOL)animete;
@property (copy, nonatomic) void (^backRefreshBlock)(void);
@end


@interface PreviewVCViewCell : UICollectionViewCell
@property (strong, nonatomic) HXPhotoModel *model;
@property (strong, nonatomic, readonly) UIImageView *imageView;
@property (strong, nonatomic, readonly) UIImage *gifImage;
@property (assign, nonatomic) BOOL dragging;
@property (nonatomic, copy) void (^cellTapClick)();
@property (nonatomic, copy) void (^cellDidPlayVideoBtn)(BOOL play);
@property (nonatomic, copy) void (^cellDownloadICloudAssetComplete)(PreviewVCViewCell *myCell);

- (void)resetScale;
- (void)requestHDImage;
- (void)cancelRequest;

@end
