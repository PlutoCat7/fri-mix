//
//  GameSinglePhotoView.h
//  GB_Football
//
//  Created by yahua on 2017/10/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGameSinglePhotoViewWidth (70*kAppScale)
#define kGameSinglePhotoViewHeight (68*kAppScale)

@class GameSinglePhotoView;
@protocol GameSinglePhotoViewDelegate <NSObject>

- (void)deleteWithgameSinglePhotoView:(GameSinglePhotoView *)view;
- (void)clickWithgameSinglePhotoView:(GameSinglePhotoView *)view;

@end

@interface GameSinglePhotoView : UIView

@property (nonatomic, weak) id<GameSinglePhotoViewDelegate> delegate;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *fullImage;


@end
