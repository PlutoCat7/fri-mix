//
//  GameSinglePhotoView.h
//  GB_Football
//
//  Created by yahua on 2017/10/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGameSinglePhotoViewWidth kRKBWIDTH(76)
#define kGameSinglePhotoViewHeight kRKBWIDTH(76)

@class GameSinglePhotoView;
@protocol GameSinglePhotoViewDelegate <NSObject>

- (void)clickWithgameSinglePhotoView:(GameSinglePhotoView *)view;

@end

@interface GameSinglePhotoView : UIView

@property (nonatomic, weak) id<GameSinglePhotoViewDelegate> delegate;
@property (nonatomic, strong) UIImage *image;

@end
