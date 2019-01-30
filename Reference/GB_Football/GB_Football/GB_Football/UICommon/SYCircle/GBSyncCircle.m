//
//  GBSyncCircle.m
//  GB_Football
//
//  Created by Pizza on 16/8/30.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBSyncCircle.h"
#import "XXNibBridge.h"
#import "ZFProgressView.h"
#import <pop/POP.h>

@interface GBSyncCircle()<XXNibBridge>
@property (strong, nonatomic) ZFProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *nomalCircle;
@property (weak, nonatomic) IBOutlet UIImageView *hightlightCircle;

@property (weak, nonatomic) IBOutlet UIImageView *water1;
@property (weak, nonatomic) IBOutlet UIImageView *water2;
@property (weak, nonatomic) IBOutlet UIImageView *water3;
@property (weak, nonatomic) IBOutlet UIImageView *water4;

@property (weak, nonatomic) IBOutlet UIImageView *half1;
@property (weak, nonatomic) IBOutlet UIImageView *half3;
@property (weak, nonatomic) IBOutlet UIImageView *half4;

@property (weak, nonatomic) IBOutlet UIImageView *rectg;
@property (weak, nonatomic) IBOutlet UIImageView *rectc;
@property (weak, nonatomic) IBOutlet UIImageView *rectw;

// 中文标签
@property (weak, nonatomic) IBOutlet UILabel *cnLabelg;
@property (weak, nonatomic) IBOutlet UILabel *cnLabelc;
@property (weak, nonatomic) IBOutlet UILabel *cnLabelw;
// 英文第一行
@property (weak, nonatomic) IBOutlet UILabel *en1Labelg;
@property (weak, nonatomic) IBOutlet UILabel *en1Labelw;
// 英文第二行
@property (weak, nonatomic) IBOutlet UILabel *en2Labelg;
@property (weak, nonatomic) IBOutlet UILabel *en2Labelw;

// 进度标签
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;


// 数字容器
@property (weak, nonatomic) IBOutlet UIView *numberContainer;
// 圆角矩形容器
@property (weak, nonatomic) IBOutlet UIView *rectContainer;
// 同步数据标签容器
@property (weak, nonatomic) IBOutlet UIView *chContainer;
// 英文容器
@property (weak, nonatomic) IBOutlet UIView *en1Container;
@property (weak, nonatomic) IBOutlet UIView *en2Container;
// 正在分析数据
@property (weak, nonatomic) IBOutlet UIView *analysisContainer;

@end

@implementation GBSyncCircle

-(void)awakeFromNib
{
    [super awakeFromNib];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupProgressView];
    });
}

// 环形点进度条条初始化
-(void)setupProgressView
{
    self.progressView = [[ZFProgressView alloc]initWithFrame:CGRectInset(self.bounds, 20, 20)];
    self.progressView.backgroundColor = [UIColor clearColor];
    [self.progressView setProgressStrokeColor:[UIColor clearColor]];
    [self.progressView setProgress:0 Animated:YES];
    [self addSubview:self.progressView];
}

// 流水灯动画开始
-(void)beginLedWithCompletionBlock:(void(^)())completionBlock
{
    [self alpha:self.rectg        fade:YES duration:0.5f beginTime:0 completionBlock:^{}];
    [self alpha:self.rectw        fade:NO duration:0.5f beginTime:0 completionBlock:^{
        [self alpha:self.rectw        fade:YES duration:0.5f beginTime:0 completionBlock:^{}];
        [self alpha:self.rectc        fade:NO duration:0.5f beginTime:0 completionBlock:^{}];
    }];

    self.progressView.timeDuration = 1.f;
    [self.progressView setProgressStrokeColor:[UIColor cyanColor]];
    [self.progressView setProgress:1 Animated:YES];
    
    dispatch_after ( dispatch_time ( DISPATCH_TIME_NOW ,1ull * NSEC_PER_SEC ) , dispatch_get_main_queue ( ) , ^{
        [self endRingWithCompletionBlock:^{
            BLOCK_EXEC(completionBlock);
        }];
    } ) ;
}

// 流水灯结束
-(void)endRingWithCompletionBlock:(void(^)())completionBlock
{
    [self.progressView setProgressStrokeColor:[UIColor clearColor]];
    [self.progressView setProgress:0 Animated:YES];
    [self waterWaveWithCompletionBlock:^{
        BLOCK_EXEC(completionBlock);
    }];
}

// alpha动画
-(void)alpha:(UIView*)view fade:(BOOL)fade duration:(CGFloat)duration beginTime:(CGFloat)beginTime completionBlock:(void(^)())completionBlock
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = duration;
    anim.beginTime = CACurrentMediaTime() + beginTime;
    if (fade)
    {
        anim.fromValue = @(1.0);
        anim.toValue   = @(0.0);
    }
    else
    {
        anim.fromValue = @(0.0);
        anim.toValue   = @(1.0);
    }
    anim.completionBlock = ^(POPAnimation *ani, BOOL fin){
        if(fin)
        {
            [view pop_removeAnimationForKey:@"alpha"];
            BLOCK_EXEC(completionBlock);
        }
    };
    [view pop_addAnimation:anim forKey:@"alpha"];
}

-(void)alphaHalf:(UIView*)view fade:(BOOL)fade duration:(CGFloat)duration beginTime:(CGFloat)beginTime completionBlock:(void(^)())completionBlock
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = duration;
    anim.beginTime = CACurrentMediaTime() + beginTime;
    if (fade)
    {
        anim.fromValue = @(0.5);
        anim.toValue   = @(0.0);
    }
    else
    {
        anim.fromValue = @(0.0);
        anim.toValue   = @(0.5);
    }
    anim.completionBlock = ^(POPAnimation *ani, BOOL fin){
        if(fin)
        {
           [view pop_removeAnimationForKey:@"alpha"];
           BLOCK_EXEC(completionBlock);
        }
    };
    [view pop_addAnimation:anim forKey:@"alpha"];
}



-(void)waterWaveWithCompletionBlock:(void(^)())completionBlock
{
    [self alphaHalf:self.water1        fade:NO duration:0.15f  beginTime:0 completionBlock:^{}];
    [self alphaHalf:self.water2        fade:NO  duration:0.15f beginTime:0.075f completionBlock:^{
        [self alphaHalf:self.water1        fade:YES duration:0.15f  beginTime:0 completionBlock:^{
            [self alphaHalf:self.water2        fade:YES duration:0.15f  beginTime:0 completionBlock:^{}];
            [self alpha:self.water3        fade:NO  duration:0.15f  beginTime:0 completionBlock:^{
                [self alpha:self.water3        fade:YES duration:0.15f  beginTime:0.20 completionBlock:^{}];
                [self alpha:self.water4        fade:NO duration:0.15f  beginTime:0 completionBlock:^{
                    BLOCK_EXEC(completionBlock);
                }];
            }];
        }];
    }];
}

-(void)halfRotate
{
     [self alpha:self.half1        fade:NO duration:0.15f  beginTime:0 completionBlock:^{}];
     [self alpha:self.half3        fade:NO duration:0.15f  beginTime:0 completionBlock:^{}];
     [self alpha:self.half4        fade:NO duration:0.15f  beginTime:0 completionBlock:^{
         [self startRotate];
     }];
}

-(void)startRotate
{
    [self rotate:NO   duration:1.8 layer:self.half1.layer];
    [self rotate:NO   duration:1.5 layer:self.half3.layer];
    [self rotate:YES  duration:2.0 layer:self.half4.layer];
}

-(void)stopRotate
{
    [self.half1.layer removeAllAnimations];
    [self.half3.layer removeAllAnimations];
    [self.half4.layer removeAllAnimations];
}

-(void)rotate:(BOOL)isAnti duration:(CGFloat)duration layer:(CALayer*)layer
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat:(isAnti?(-1):1)* M_PI * 2.0];
    animation.removedOnCompletion = NO;
    animation.duration = duration;
    animation.cumulative = YES;
    animation.repeatCount = HUGE_VALF;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [layer addAnimation:animation forKey:@"rotationAnimation"];
}

-(void)prepareWithCompletionBlock:(void(^)())completionBlock
{
    // 中文标签
    [self alpha:self.cnLabelg           fade:YES duration:0.5f beginTime:0 completionBlock:^{}];
    [self alpha:self.cnLabelw           fade:NO  duration:0.5f beginTime:0 completionBlock:^{
    [self alpha:self.cnLabelw           fade:YES duration:0.5f beginTime:0 completionBlock:^{}];
    [self alpha:self.cnLabelc           fade:NO duration:0.5f beginTime:0 completionBlock:^{}];}];
    
    // 英文标签1
    [self alpha:self.en1Labelg           fade:YES duration:1.f beginTime:0 completionBlock:^{}];
    [self alpha:self.en1Labelw           fade:NO duration:1.f beginTime:0 completionBlock:^{}];
    // 英文标签2
    [self alpha:self.en2Labelg           fade:YES duration:1.f beginTime:0 completionBlock:^{}];
    [self alpha:self.en2Labelw           fade:NO duration:1.f beginTime:0 completionBlock:^{}];
    
    // 圆角矩形
    [self alpha:self.rectg              fade:YES duration:1.f beginTime:0 completionBlock:^{}];
    [self alpha:self.rectw              fade:NO duration:1.f  beginTime:0.25 completionBlock:^{}];
    
    // 内外圈
    [self alpha:self.nomalCircle        fade:YES duration:1.f beginTime:0 completionBlock:^{}];
    [self alpha:self.hightlightCircle   fade:NO  duration:1.f beginTime:0.25 completionBlock:^{
        BLOCK_EXEC(completionBlock);
    }];
    
}

-(void)cancelWithCompletionBlock:(void(^)())completionBlock
{
    // 中文标签
    [self alpha:self.cnLabelc           fade:YES duration:0.5f beginTime:0 completionBlock:^{}];
    [self alpha:self.cnLabelw           fade:NO  duration:0.5f beginTime:0 completionBlock:^{
        [self alpha:self.cnLabelw           fade:YES duration:0.5f beginTime:0 completionBlock:^{}];
        [self alpha:self.cnLabelg           fade:NO duration:0.5f beginTime:0 completionBlock:^{}];}];
    
    // 英文标签1
    [self alpha:self.en1Labelg           fade:NO duration:1.f beginTime:0 completionBlock:^{}];
    [self alpha:self.en1Labelw           fade:YES duration:1.f beginTime:0 completionBlock:^{}];
    // 英文标签2
    [self alpha:self.en2Labelg           fade:NO duration:1.f beginTime:0 completionBlock:^{}];
    [self alpha:self.en2Labelw           fade:YES duration:1.f beginTime:0 completionBlock:^{}];
    
    // 圆角矩形
    [self alpha:self.rectg              fade:NO duration:1.f beginTime:0 completionBlock:^{}];
    [self alpha:self.rectw              fade:YES duration:1.f  beginTime:0.25 completionBlock:^{}];
    
    // 内外圈
    [self alpha:self.nomalCircle        fade:NO duration:1.f beginTime:0 completionBlock:^{}];
    [self alpha:self.hightlightCircle   fade:YES  duration:1.f beginTime:0.25 completionBlock:^{
        BLOCK_EXEC(completionBlock);
    }];
}


-(void)showWithCompletionBlock:(void(^)())completionBlock
{
    // 清空状态
    [self alpha:self.nomalCircle        fade:YES  duration:1.f beginTime:0 completionBlock:^{}];
    [self alpha:self.hightlightCircle   fade:YES  duration:1.f beginTime:0 completionBlock:^{}];
    [self alpha:self.rectw              fade:YES duration:1.f  beginTime:0 completionBlock:^{}];
    [self alpha:self.rectg              fade:NO  duration:1.f beginTime:0 completionBlock:^{
        //流水灯
        [self beginLedWithCompletionBlock:^{BLOCK_EXEC(completionBlock);}];
    
    }];
    // 中文标签
    [self alpha:self.cnLabelw           fade:YES duration:0.5f beginTime:0 completionBlock:^{}];
    [self alpha:self.cnLabelg           fade:NO duration:0.5f beginTime:0 completionBlock:^{}];
    
    // 英文标签
    [self alpha:self.en1Labelg           fade:NO   duration:1.0f beginTime:0 completionBlock:^{}];
    [self alpha:self.en1Labelw           fade:YES  duration:1.0f beginTime:0 completionBlock:^{}];
    [self alpha:self.en2Labelg           fade:NO   duration:0.25f beginTime:0 completionBlock:^{}];
    [self alpha:self.en2Labelw           fade:YES  duration:0.25f beginTime:0 completionBlock:^{
        
        [self alpha:self.en2Labelg           fade:YES   duration:0.25f beginTime:0 completionBlock:^{}];
        [self alpha:self.en2Labelw           fade:NO    duration:0.25f beginTime:0 completionBlock:^{
            [self alpha:self.en2Labelg           fade:NO   duration:0.25f beginTime:0 completionBlock:^{}];
            [self alpha:self.en2Labelw           fade:YES  duration:0.25f beginTime:0 completionBlock:^{}];
            [self alpha:self.en1Labelg           fade:YES   duration:0.25f beginTime:0 completionBlock:^{}];
            [self alpha:self.en1Labelw           fade:NO  duration:0.25f beginTime:0 completionBlock:^{}];
            
        }];
        
    }];
}

-(void)syncWithCompletionBlock:(void(^)())completionBlock
{
    [self alpha:self.rectContainer      fade:YES  duration:1.f beginTime:0 completionBlock:^{}];
    [self alpha:self.chContainer        fade:YES  duration:1.f beginTime:0 completionBlock:^{}];
    [self alpha:self.en1Container       fade:YES  duration:1.f beginTime:0 completionBlock:^{}];
    [self alpha:self.en2Container       fade:YES  duration:1.f beginTime:0 completionBlock:^{}];
    [self alpha:self.numberContainer    fade:NO  duration:1.f beginTime:0 completionBlock:^{}];
    [self alphaHalf:self.water4  fade:YES duration:0.15f  beginTime:0 completionBlock:^{
        [self halfRotate];
    }];
}

// 分析数据
-(void)analysisWithCompletionBlock:(void(^)())completionBlock
{
    [self alpha:self.numberContainer      fade:YES  duration:1.f beginTime:0 completionBlock:^{}];
    [self alpha:self.analysisContainer    fade:NO  duration:1.f beginTime:0 completionBlock:^{
        BLOCK_EXEC(completionBlock);
    }];
}

// 设置为空闲状态
-(void)idleWithCompletionBlock:(void(^)())completionBlock analysisOK:(BOOL)analysisOK
{
    [self alpha:self.rectContainer      fade:NO  duration:1.f beginTime:0 completionBlock:^{}];
    [self alpha:self.chContainer        fade:NO  duration:1.f beginTime:0 completionBlock:^{}];
    [self alpha:self.en1Container       fade:NO  duration:1.f beginTime:0 completionBlock:^{}];
    [self alpha:self.en2Container       fade:NO  duration:1.f beginTime:0 completionBlock:^{}];
    // 同步数据成功
    if (analysisOK)
    {
        [self alpha:self.analysisContainer  fade:YES duration:1.f beginTime:0 completionBlock:^{}];
    }
    // 还没到分析数据 蓝牙同步就失败
    else
    {
        [self alpha:self.numberContainer      fade:YES  duration:1.f beginTime:0 completionBlock:^{}];
    }
    
    [self alpha:self.half1        fade:YES duration:0.15f  beginTime:0 completionBlock:^{}];
    [self alpha:self.half3        fade:YES duration:0.15f  beginTime:0 completionBlock:^{}];
    [self alpha:self.half4        fade:YES duration:0.15f  beginTime:0 completionBlock:^{
        [self stopRotate];
    }];
    [self alpha:self.rectc        fade:YES duration:1.f  beginTime:0.25 completionBlock:^{}];
    [self cancelWithCompletionBlock:^{
        BLOCK_EXEC(completionBlock);
    }];
}

-(void)setPercent:(CGFloat)percent
{
    _percent = percent;
    self.numberLabel.text = [NSString stringWithFormat:@"%d",(int)percent];
    NSInteger integer = (int)percent;
    NSInteger ten = integer/10;
    NSInteger sigle = ten%2;
    CGFloat p = (integer%10)*0.1;
    // 偶数区间
    if (sigle == 1)
    {
        self.numberLabel.textColor = [UIColor colorWithRed:p*0xff/255.f
                                                     green:0xff/255.f blue:0xff/255.f alpha:1];
    }
    //奇数区间
    else if (sigle == 0)
    {
        self.numberLabel.textColor = [UIColor colorWithRed:(1-p)*0xff/255.f
                                                     green:0xff/255.f blue:0xff/255.f alpha:1];
    }
    // 超过100
    if (percent >= 100.0) {
        self.numberLabel.textColor = [UIColor whiteColor];;
    }
}



@end
