//
//  GBPairView.m
//  GB_Football
//
//  Created by Pizza on 2016/12/20.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBPairView.h"
#import "XXNibBridge.h"
#import "UIImage+RTTint.h"
#import "GBPopAnimateTool.h"
#import "GBWaveView.h"
@interface GBPairView()<XXNibBridge>

@property (weak, nonatomic) IBOutlet UIView      *phoneGroup;
@property (weak, nonatomic) IBOutlet UIImageView *phoneGray;
@property (weak, nonatomic) IBOutlet UIImageView *phoneGreen;
@property (weak, nonatomic) IBOutlet UIView      *ringGroup;
@property (weak, nonatomic) IBOutlet UIImageView *ringGreen;
@property (weak, nonatomic) IBOutlet UIImageView *ringGray;
@property (weak, nonatomic) IBOutlet UIImageView *shake;
@property (weak, nonatomic) IBOutlet GBWaveView *waveView;

@end

@implementation GBPairView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.waveView animationStart];
}

-(void)dealloc
{
    [self.waveView pop_removeAllAnimations];
    [self.phoneGroup pop_removeAllAnimations];
    [self.ringGroup pop_removeAllAnimations];
    [self.phoneGray pop_removeAllAnimations];
    [self.phoneGreen pop_removeAllAnimations];
    [self.ringGreen pop_removeAllAnimations];
    [self.ringGray pop_removeAllAnimations];
    [self.shake pop_removeAllAnimations];
}

// 从连接中到连接成功
-(void)connectingTurnToConnected:(void(^)())completionBlock
{
    [GBPopAnimateTool popFade:self.waveView   fade:YES repeat:NO duration:1.0 beginTime:2.0 completionBlock:^{}];
    [GBPopAnimateTool popFade:self.phoneGroup fade:YES repeat:NO duration:1.0 beginTime:2.0 completionBlock:^{
        [GBPopAnimateTool popCenter:self.ringGroup x:self.centerX y:self.ringGroup.centerY repeat:NO duration:0.5 beginTime:0 completionBlock:^{
            [GBPopAnimateTool popAppear:self.ringGreen disappear:self.ringGray duration:0.5 beginTime:0 completionBlock:^{}];
            [GBPopAnimateTool popScale:self.ringGroup x:1.21 y:1.21 repeat:NO duration:0.5 beginTime:0 completionBlock:^{
                [GBPopAnimateTool popFade:self.shake fade:NO repeat:NO duration:0.5 beginTime:0 completionBlock:^{
                        BLOCK_EXEC(completionBlock);
                }];
            }];
        }];
    }];
}

// 从成功连接到正在连接
-(void)connectedTurnToConnecting:(void(^)())completionBlock
{
    [GBPopAnimateTool popFade:self.shake fade:YES repeat:NO duration:0.5 beginTime:0 completionBlock:^{
        [GBPopAnimateTool popAppear:self.ringGray disappear:self.ringGreen duration:0.5 beginTime:0 completionBlock:^{}];
        [GBPopAnimateTool popScale:self.ringGroup x:1.0 y:1.0 repeat:NO duration:0.5 beginTime:0 completionBlock:^{
            [GBPopAnimateTool popCenter:self.ringGroup x:[UIScreen mainScreen].bounds.size.width*0.75
                                      y:self.ringGroup.centerY repeat:NO duration:0.5 beginTime:0 completionBlock:^{
                                          [GBPopAnimateTool popFade:self.waveView   fade:NO repeat:NO duration:1.0 beginTime:0 completionBlock:^{}];
                                          [GBPopAnimateTool popFade:self.phoneGroup fade:NO repeat:NO duration:1.0 beginTime:0 completionBlock:^{
                                              BLOCK_EXEC(completionBlock);
                                          }];
                                      }];
        }];
    }];
}

// 从连接中到连接失败
-(void)connectingTurnToFailed:(void(^)())completionBlock
{
    [self.waveView animationStop];
    [GBPopAnimateTool popAppear:self.phoneGray disappear:self.phoneGreen duration:1.0 beginTime:0 completionBlock:^{
         BLOCK_EXEC(completionBlock);
    }];
}

// 从失败到连接中
-(void)failedTurnToConnecting:(void(^)())completionBlock
{
    [self.waveView animationReStart];
    [GBPopAnimateTool popAppear:self.phoneGreen disappear:self.phoneGray duration:1.0 beginTime:0 completionBlock:^{
        BLOCK_EXEC(completionBlock);
    }];
}

@end
