//
//  TallyVoiceInputView.m
//  Demo2018
//
//  Created by AlienJunX on 2018/2/1.
//  Copyright © 2018年 AlienJunX. All rights reserved.
//

#import "TallyVoiceInputView.h"
#import "VoiceInputFlowLayout.h"
#import "TallyVoiceInputTipCell.h"
#import <AVFoundation/AVFoundation.h>


#define kIconSizeW 100

# define COUNTDOWN 60

@interface TallyVoiceInputView()<UICollectionViewDataSource, VoiceInputFlowLayoutDelegate>
@property (nonatomic, weak) UIView *iconContainer;
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, strong) CAReplicatorLayer *replicatorLayer_Circle;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UIImageView *failTipImageView;
@property (nonatomic, weak) UIImageView *voiceBtnTip;
@property (strong, nonatomic) NSArray *array;

@property (strong, nonatomic) AVAudioSession *session;
@property (strong, nonatomic) AVAudioRecorder *recorder;
@property (strong, nonatomic) NSURL *recordFileUrl;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger countDown;  //倒计时

@property (assign, nonatomic) BOOL recording;

@property (nonatomic, strong) NSTimer *recorderPeakerTimer;

@property (nonatomic, weak) UILabel *recognitionLabel;

@end

@implementation TallyVoiceInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // container
        UIView *iconContainer = [UIView new];
        [self addSubview:iconContainer];
        self.iconContainer = iconContainer;
        [iconContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.height.equalTo(@(kIconSizeW));
            if (kDevice_Is_iPhone5) {
                make.top.equalTo(self).offset(100);
            } else {
                make.top.equalTo(self).offset(150);
            }
        }];
        
        
        // icon
        UIImageView *iconImageView = [UIImageView new];
        iconImageView.image = [UIImage imageNamed:@"TallyVoiceInputIcon"];
        [iconContainer addSubview:iconImageView];
        self.iconImageView = iconImageView;
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(iconContainer);
        }];
        
        // failTip
        UIImageView *failTipImageView = [UIImageView new];
        failTipImageView.image = [UIImage imageNamed:@"Tally_voice_fail_tip"];
        [self addSubview:failTipImageView];
        self.failTipImageView = failTipImageView;
        [failTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconContainer.mas_bottom).offset(0);
            make.centerX.equalTo(self);
            make.height.equalTo(@0);
            make.width.equalTo(@230);
        }];
        
        UILabel *tipLabel = [UILabel new];
        tipLabel.text = @"可以试试";
        tipLabel.textColor = [UIColor lightGrayColor];
        tipLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(failTipImageView.mas_bottom).offset(15);
            make.centerX.equalTo(self);
        }];
        
        // uicollectionView
        VoiceInputFlowLayout *layout = [[VoiceInputFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 12;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [collectionView registerClass:[TallyVoiceInputTipCell class] forCellWithReuseIdentifier:@"cell"];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:collectionView];
        self.collectionView = collectionView;
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipLabel.mas_bottom).offset(15);
            make.leading.and.trailing.equalTo(self);
            make.height.equalTo(@150);
        }];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"account_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(20);
            make.top.equalTo(self).offset(40);
            make.width.height.equalTo(@30);
        }];
        
        UIImageView *voiceBtnTip = [UIImageView new];
        voiceBtnTip.image = [UIImage imageNamed:@"Tally_voiceBtnTip"];
        [self addSubview:voiceBtnTip];
        self.voiceBtnTip = voiceBtnTip;
        [voiceBtnTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-70);
            make.width.equalTo(@190);
            make.height.equalTo(@62);
            make.centerX.equalTo(self);
        }];
        
        UILabel *recognitionLabel = [UILabel new];
        [self addSubview:recognitionLabel];
        recognitionLabel.textColor = XWColorFromHex(0x606060);
        recognitionLabel.text = @"识别中...";
        recognitionLabel.font = [UIFont systemFontOfSize:23];
        self.recognitionLabel = recognitionLabel;
        [recognitionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(voiceBtnTip);
            make.centerX.equalTo(self);
        }];
        self.recognitionLabel.hidden = YES;
        
        _array = @[@"设计费用一万五",@"沙发一万八 11月5号送货",@"林内热水器两千块",@"瓷砖退款八百",@"... ..."];
    }
    return self;
}

#pragma mark - action

- (void)closeBtnAction:(UIButton *)sender {
    UIViewController *vc = nil;
    for (UIView *next = [self superview]; next; next = [next superview]) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            vc = (UIViewController *)nextResponder;
            break;
        }
    }
    
    if (vc == nil) {
        return;
    }
    
    [vc.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self removeFromSuperview];
}

- (void)startRecord {
    NSLog(@"开始录音");
    self.voiceBtnTip.hidden = YES;
    self.recognitionLabel.hidden = YES;
    [self.failTipImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconContainer.mas_bottom).offset(0);
        make.centerX.equalTo(self);
        make.height.equalTo(@0);
        make.width.equalTo(@230);
    }];
    
    self.iconImageView.image = [UIImage imageNamed:@"TallyVoiceInputIcon"];
    self.countDown = 60;
    [self addTimer];
    
    AVAudioSession *session =[AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if (session == nil) {
        NSLog(@"Error creating session: %@",[sessionError description]);
    } else {
        [session setActive:YES error:nil];
    }
    self.session = session;
    
    //1.获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.filePath = [path stringByAppendingString:@"/VoiceRecord.wav"];
    //2.获取文件路径
    self.recordFileUrl = [NSURL fileURLWithPath:self.filePath];
    
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 16000.0],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSetting error:nil];
    if (_recorder) {
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
    } else {
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
    }
    
    self.replicatorLayer_Circle.instanceCount = 4;
}

- (void)stopRecord {
    [self removeTimer];
    NSLog(@"停止录音");
    
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self.filePath]) {
        if ([self.delegate respondsToSelector:@selector(voiceFinish:)]) {
            [self.delegate voiceFinish:self.filePath];
            
            self.recognitionLabel.hidden = NO;
        }
        
    } else {
        NSLog( @"最多录60秒");
    }
    [self.replicatorLayer_Circle removeFromSuperlayer];
    self.replicatorLayer_Circle = nil;
}

- (void)cancelRecord {
    [self removeTimer];
    NSLog(@"停止录音");
    
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
    
    [self.replicatorLayer_Circle removeFromSuperlayer];
    self.replicatorLayer_Circle = nil;
}


- (void)recogError {
    self.voiceBtnTip.hidden = NO;
    self.recognitionLabel.hidden = YES;
    self.iconImageView.image = [UIImage imageNamed:@"TallyVoiceInputIcon_fail"];
    [self.failTipImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.height.equalTo(@55);
        make.width.equalTo(@230);
        if (kDevice_Is_iPhone5) {
            make.top.equalTo(self.iconContainer.mas_bottom).offset(10);
        } else {
            make.top.equalTo(self.iconContainer.mas_bottom).offset(60);
        }
    }];
}

- (void)recogFinish {
    self.voiceBtnTip.hidden = NO;
    self.recognitionLabel.hidden = YES;
}

/**
 *  添加定时器
 */
- (void)addTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshLabelText) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**
 *  移除定时器
 */
- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
    
    
    if (_recorderPeakerTimer) {
        [_recorderPeakerTimer invalidate];
        _recorderPeakerTimer = nil;
    }
}

- (void)refreshLabelText {
    self.countDown --;
    NSLog(@"%@",[NSString stringWithFormat:@"还剩 %ld 秒",(long)self.countDown]);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TallyVoiceInputTipCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.label.text = _array[indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.frame.size.width, 15);
}

#pragma mark - getter
// 圆圈动画 波纹
- (CALayer *)replicatorLayer_Circle{
    
    if (!_replicatorLayer_Circle) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = CGRectMake(0, 0, kIconSizeW, kIconSizeW);
        shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, kIconSizeW, kIconSizeW)].CGPath;
        shapeLayer.fillColor = XWColorFromHex(0xfdf186).CGColor;
        shapeLayer.opacity = 0.0;
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[[self alphaAnimation],[self scaleAnimation]];
        animationGroup.duration = 2.0;
        animationGroup.autoreverses = NO;
        animationGroup.repeatCount = HUGE;
        animationGroup.removedOnCompletion = NO;
        animationGroup.fillMode = kCAFillModeForwards;
        [shapeLayer addAnimation:animationGroup forKey:@"animationGroup"];
        
        _replicatorLayer_Circle = [CAReplicatorLayer layer];
        _replicatorLayer_Circle.frame = CGRectMake(0, 0, kIconSizeW, kIconSizeW);
        _replicatorLayer_Circle.instanceDelay = 0.5;
        _replicatorLayer_Circle.instanceCount = 0;
        [_replicatorLayer_Circle addSublayer:shapeLayer];
        
        [self.iconContainer.layer insertSublayer:_replicatorLayer_Circle atIndex:0];
    }
    
    return _replicatorLayer_Circle;
}

- (CABasicAnimation *)alphaAnimation{
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.fromValue = @(1.0);
    alpha.toValue = @(0.0);
    return alpha;
}

- (CABasicAnimation *)scaleAnimation{
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    scale.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
    scale.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 2.5, 2.5, 0.0)];
    return scale;
}

@end

