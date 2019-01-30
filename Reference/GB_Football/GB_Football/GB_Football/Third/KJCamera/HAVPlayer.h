//
//  HAVPlayer.h
//  Join
//
//  Created by 黄克瑾 on 2017/1/11.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HAVPlayer;
@protocol HAVPlayerDelegate <NSObject>

- (void)HAVPlayerDidClose:(HAVPlayer *)player;

@end

@interface HAVPlayer : UIView

@property (copy, nonatomic) NSURL *videoUrl;
@property (nonatomic, assign) BOOL isShowPlayButton;
@property (nonatomic, assign) BOOL isShowCloseButton;

@property (nonatomic, weak) id<HAVPlayerDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withShowInView:(UIView *)bgView url:(NSURL *)url;

- (void)startPlayer;
- (void)stopPlayer;
- (void)restorePlayer;  //恢复

@end
