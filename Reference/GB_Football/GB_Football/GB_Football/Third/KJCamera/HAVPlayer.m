//
//  HAVPlayer.m
//  Join
//
//  Created by 黄克瑾 on 2017/1/11.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "HAVPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface HAVPlayer ()

@property (nonatomic,strong) AVPlayer *player;//播放器对象
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *playButton;

@end

@implementation HAVPlayer

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame withShowInView:(UIView *)bgView url:(NSURL *)url {
    if (self = [self initWithFrame:frame]) {
        //创建播放器层
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        playerLayer.frame = self.bounds;
        
        [self.layer addSublayer:playerLayer];
        if (url) {
            self.videoUrl = url;
        }
        
        [bgView addSubview:self];
    }
    return self;
}

- (void)dealloc {
    
    [self removeAvPlayerNtf];
    [self stopPlayer];
    self.player = nil;
}

#pragma mark - Public

- (void)startPlayer {
    
    if (self.player.rate == 0) {
        [self.player play];
    }
}

- (void)stopPlayer {
    if (self.player.rate == 1) {
        [self.player pause];//如果在播放状态就停止
    }
    if (_playButton) {
        [self.playButton setImage:[UIImage imageNamed:@"play298_wubg"] forState:UIControlStateNormal];
    }
}

- (void)restorePlayer {
    
    [self stopPlayer];
}

- (void)setIsShowCloseButton:(BOOL)isShowCloseButton {
    
    _isShowCloseButton = isShowCloseButton;
    if (isShowCloseButton) {
        self.closeButton.hidden = NO;
    }else {
        self.closeButton.hidden = YES;
    }
}

- (void)setIsShowPlayButton:(BOOL)isShowPlayButton {
    
    _isShowPlayButton = isShowPlayButton;
    if (isShowPlayButton) {
        self.playButton.hidden = NO;
    }else {
        self.playButton.hidden = YES;
    }
}

#pragma mark - Action

- (void)closeAVPlayer {
    
    [self stopPlayer];
    if (self.delegate && [self.delegate respondsToSelector:@selector(HAVPlayerDidClose:)]) {
        [self.delegate HAVPlayerDidClose:self];
    }
    [self removeFromSuperview];
}

- (void)playAVPlayer {
    
    if (self.player.rate == 0) {
        [self.player play];
        [self.playButton setImage:nil forState:UIControlStateNormal];
    }else {
        [self.player pause];
        [self.playButton setImage:[UIImage imageNamed:@"play298_wubg"] forState:UIControlStateNormal];
    }
}

#pragma mark - Setter And Getter

- (AVPlayer *)player {
    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:[self getAVPlayerItem]];
        [self addAVPlayerNtf:_player.currentItem];
        
    }
    
    return _player;
}

- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
    [self removeAvPlayerNtf];
    [self nextPlayer];
}

- (UIButton *)closeButton {
    
    if (!_closeButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 70, 70);
        [button setImage:[UIImage imageNamed:@"hvideo_close"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeAVPlayer) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = YES;
        _closeButton = button;
        [self addSubview:button];
    }
    return _closeButton;
}
- (UIButton *)playButton {
    
    if (!_playButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;
        [button setImage:[UIImage imageNamed:@"play298_wubg"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(playAVPlayer) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = YES;
        _playButton = button;
        [self addSubview:button];
    }
    return _playButton;
}

#pragma mark - Private

- (AVPlayerItem *)getAVPlayerItem {
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:self.videoUrl];
    return playerItem;
}

- (void)nextPlayer {
    [self.player seekToTime:CMTimeMakeWithSeconds(0, _player.currentItem.duration.timescale)];
    [self.player replaceCurrentItemWithPlayerItem:[self getAVPlayerItem]];
    [self addAVPlayerNtf:self.player.currentItem];
    
}

- (void) addAVPlayerNtf:(AVPlayerItem *)playerItem {
    //监控状态属性
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)removeAvPlayerNtf {
    AVPlayerItem *playerItem = self.player.currentItem;
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f",totalBuffer);
    }
}

- (void)playbackFinished:(NSNotification *)ntf {

    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}

@end

