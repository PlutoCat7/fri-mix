//
//  SDPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"
#import "AppDelegate.h"
#import <Masonry.h>
#import "Dairy.h"
#import "CloudReCollectItemModel.h"
@class FileModel;
@class TweetDetailsViewController;

typedef NS_ENUM(NSInteger,PhotoBrowserType) {
    PhotoBrowserTyoeTyoeTimerShaft = 0,
    PhotoBrowserTyoeTweet,
   PhotoBrowserTyoeMoveTweet
};

@class SDButton, SDPhotoBrowser;

@protocol SDPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end


@interface SDPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, assign) PhotoBrowserType browserType;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, assign) BOOL showCommentButton;
@property (nonatomic, strong) SelVideoPlayer *player;
@property (nonatomic, strong) Dairy *dairy;
// MARK: - bug fix by Marblue
@property (nonatomic, assign) NSInteger currentImageSection;
@property (nonatomic, strong) CloudReCollectItemModel *cloudReCollectItem;
@property (nonatomic, weak) id<SDPhotoBrowserDelegate> delegate;

@property (nonatomic, copy) void(^showCommentBlock)(TweetDetailsViewController *detailVC);

- (void)show;

@end
