//
//  GamePhotoView.h
//  GB_Football
//
//  Created by yahua on 2017/10/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNibBridge.h"
#import "MatchGamePhotosUploadManager.h"

@class GamePhotoSelectView;
@protocol GamePhotoSelectViewDelegate <NSObject>

- (void)mediaCountChange:(BOOL)isAdd view:(GamePhotoSelectView *)view;

@end

@interface GamePhotoSelectView : UIView <XXNibBridge>

@property (nonatomic, weak) UIViewController *superViewController;
@property (nonatomic, assign) NSInteger maxImageCount;
@property (nonatomic, weak) id<GamePhotoSelectViewDelegate> delegate;

- (NSArray<MatchGamePhotoUploadObject *> *)getMatchImageUploadObjectList;

@end
