//
//  VideoTtimmerViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/19.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//


#define Annotation_Color [UIColor colorWithRed:(254)/255.0 green:(192)/255.0 blue:(12)/255.0 alpha:1.0]//注释

#import "VideoTtimmerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ICGVideoTrimmerView.h"

@interface VideoTtimmerViewController ()<ICGVideoTrimmerDelegate>

@property (assign, nonatomic) BOOL isPlaying ,restartOnPlay;

@property (strong, nonatomic) ICGVideoTrimmerView *trimmerView;
@property (nonatomic, retain) UIImageView *imageView;

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (assign, nonatomic) CGFloat videoPlaybackPosition;
@property (strong, nonatomic) NSTimer *playbackTimeCheckerTimer;
@property (strong, nonatomic) AVAsset *asset;

@property (assign, nonatomic) CGFloat startTime;
@property (assign, nonatomic) CGFloat stopTime;


@property (strong, nonatomic) AVAssetExportSession *exportSession;
@property (strong, nonatomic) NSString *tempVideoPath;

@end

@implementation VideoTtimmerViewController

static VideoTtimmerViewController *_sharedInstance = nil;
static dispatch_once_t onceToken;

+ (instancetype)sharedInstance
{
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)destorySharedInstance
{
    onceToken = 0;
    _sharedInstance = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"裁剪视频";
    [self wr_setNavBarBarTintColor:XWColorFromHexAlpha(0x44444b, 0.9)];
    [self wr_setNavBarTitleColor:[UIColor whiteColor]];
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.tempVideoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmpMov.mp4"];
    
    [NSObject showHUDQueryStr:@"读取视频"];
    [self getAVAssetWithModel:self.model];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.player pause];
    [self stopPlaybackTimeChecker];
}

-(void)setup{
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:self.asset];
    
    self.player = [AVPlayer playerWithPlayerItem:item];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.contentsGravity = AVLayerVideoGravityResizeAspect;
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [self.view.layer addSublayer:self.playerLayer];
    
    // 扬声器声音
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord
             withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                   error:nil];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnVideoLayer:)];
    [self.view addGestureRecognizer:tap];
    self.view.userInteractionEnabled = YES;
    
    self.videoPlaybackPosition = 0;
    
    //    [self tapOnVideoLayer:tap];
    
    // set properties for trimmer view
    [self trimmerView];
    [self.trimmerView setAsset:self.asset];
    
    // important: reset subviews
    [self.trimmerView resetSubviews];
    //    [self.trimButton setHidden:NO];
    [self imageView];
    
}

- (void)viewDidLayoutSubviews
{
    self.playerLayer.frame = self.view.bounds;
}

#pragma mark - private methods 私有方法
- (void)tapOnVideoLayer:(UITapGestureRecognizer *)tap
{
    
    if (self.isPlaying) {
        [self.player pause];
        [self stopPlaybackTimeChecker];
    }else {
        if (_restartOnPlay){
            [self seekVideoToPos: self.startTime];
            [self.trimmerView seekToTime:self.startTime];
            _restartOnPlay = NO;
        }
        [self.player play];
        [self startPlaybackTimeChecker];
    }
    self.imageView.hidden =self.isPlaying = !self.isPlaying;
    
    [self.trimmerView hideTracker:!self.isPlaying];
}

- (void)startPlaybackTimeChecker
{
    [self stopPlaybackTimeChecker];
    
    self.playbackTimeCheckerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(onPlaybackTimeCheckerTimer) userInfo:nil repeats:YES];
}

- (void)stopPlaybackTimeChecker
{
    if (self.playbackTimeCheckerTimer) {
        [self.playbackTimeCheckerTimer invalidate];
        self.playbackTimeCheckerTimer = nil;
    }
}


- (void)seekVideoToPos:(CGFloat)pos
{
    self.videoPlaybackPosition = pos;
    CMTime time = CMTimeMakeWithSeconds(self.videoPlaybackPosition, self.player.currentTime.timescale);
    //NSLog(@"seekVideoToPos time:%.2f", CMTimeGetSeconds(time));
    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

#pragma mark - PlaybackTimeCheckerTimer
- (void)onPlaybackTimeCheckerTimer
{
    CMTime curTime = [self.player currentTime];
    Float64 seconds = CMTimeGetSeconds(curTime);
    if (seconds < 0){
        seconds = 0; // this happens! dont know why.
    }
    self.videoPlaybackPosition = seconds;
    
    //    [self.trimmerView seekToTime:seconds];
    
    if (self.videoPlaybackPosition >= self.stopTime) {
        self.videoPlaybackPosition = self.startTime;
        [self seekVideoToPos: self.startTime];
        [self.trimmerView seekToTime:self.startTime];
    }
}

#pragma mark - ICGVideoTrimmerDelegate

- (void)trimmerView:(ICGVideoTrimmerView *)trimmerView didChangeLeftPosition:(CGFloat)startTime rightPosition:(CGFloat)endTime
{
    
    _restartOnPlay = YES;
    [self.player pause];
    self.isPlaying = NO;
    [self stopPlaybackTimeChecker];
    
    [self.trimmerView hideTracker:true];
    
    if (startTime != self.startTime) {
        //then it moved the left position, we should rearrange the bar
        [self seekVideoToPos:startTime];
    }
    else{ // right has changed
        [self seekVideoToPos:endTime];
    }
    self.startTime = startTime;
    self.stopTime = endTime;
    
}

#pragma mark - event response
-(void)finish{

    [self deleteTempFile];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:self.asset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        
        self.exportSession = [[AVAssetExportSession alloc]
                              initWithAsset:self.asset presetName:AVAssetExportPresetPassthrough];
        // Implementation continues.
        
        NSURL *furl = [NSURL fileURLWithPath:self.tempVideoPath];
        
        self.exportSession.outputURL = furl;
        self.exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        
        CMTime start = CMTimeMakeWithSeconds(self.startTime, self.asset.duration.timescale);
        CMTime duration = CMTimeMakeWithSeconds(self.stopTime - self.startTime, self.asset.duration.timescale);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        self.exportSession.timeRange = range;
        WEAKSELF
        [self.exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([self.exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    
                    XWLog(@"Export failed: %@", [[self.exportSession error] localizedDescription]);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    
                    XWLog(@"Export canceled");
                    break;
                default:
                    XWLog(@"NONE");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSURL *movieUrl = [NSURL fileURLWithPath:self.tempVideoPath];
                        if ([weakSelf.delegate respondsToSelector:@selector(videoViewController:didCropToURL:videoTime: assest:)]) {
                            [weakSelf.delegate videoViewController:weakSelf didCropToURL:movieUrl videoTime:0.01 assest:weakSelf.model.asset];
                        }
                        
                        if (_againEdit) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }

                    });
                    
                    break;
            }
        }];
        
    }
    
}

//写入相册回调
- (void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
        //                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Actions
- (void)deleteTempFile
{
    NSURL *url = [NSURL fileURLWithPath:self.tempVideoPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL exist = [fm fileExistsAtPath:url.path];
    NSError *err;
    if (exist) {
        [fm removeItemAtURL:url error:&err];
        NSLog(@"file deleted");
        if (err) {
            NSLog(@"file remove error, %@", err.localizedDescription );
        }
    } else {
        NSLog(@"no file by that name");
    }
}



-(void)getAVAssetWithModel:(HXPhotoModel *)model{
    
    WEAKSELF
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
    options.networkAccessAllowed = NO;
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:model.asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && asset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSObject hideHUDQuery];
                weakSelf.view.backgroundColor = [UIColor blackColor];
                weakSelf.asset = asset;
                [weakSelf setup];
            });
        }
    }];
    
}


-(ICGVideoTrimmerView *)trimmerView{
    
    if (!_trimmerView) {
        _trimmerView = [[ICGVideoTrimmerView alloc]initWithAsset:self.asset];
        _trimmerView.backgroundColor = XWColorFromHexAlpha(0x44444b, 0.9);
        [self.view addSubview:_trimmerView];
        _trimmerView.frame = CGRectMake(0, 0, self.view.width, 143);
        _trimmerView.bottom = self.view.height;
        _trimmerView.themeColor = Annotation_Color;
        _trimmerView.delegate = self;
        _trimmerView.showsRulerView = NO;
        _trimmerView.rulerLabelInterval = 10;
        _trimmerView.trackerColor = [UIColor cyanColor];    }
    return _trimmerView;
}


-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        UIImage *image = [UIImage imageNamed:@"video_icon"];
        _imageView.image = image;
        _imageView.size = image.size;
//        _imageView.center = CGPointMake(self.view.width/2, (kScreen_Height-kNavigationBarHeight-143)/2+kNavigationBarHeight);
        _imageView.center = CGPointMake(self.view.width/2, self.view.height/2);

        [self.view addSubview:_imageView];
    }
    return _imageView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

