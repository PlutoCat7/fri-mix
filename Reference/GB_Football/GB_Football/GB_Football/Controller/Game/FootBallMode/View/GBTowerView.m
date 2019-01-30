//
//  GBTowerView.m
//  GB_Football
//
//  Created by Pizza on 200.56/0.50/28.
//  Copyright © 200.56年 Go Brother. All rights reserved.
//

#import "GBTowerView.h"
#import "XXNibBridge.h"
#import <pop/POP.h>


@interface GBTowerView()<XXNibBridge>
@property (weak, nonatomic) IBOutlet UIView *towerGroup;
@property (weak, nonatomic) IBOutlet UIView *footballGroup;
@property (weak, nonatomic) IBOutlet UIImageView *towerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *waveNearImageView;
@property (weak, nonatomic) IBOutlet UIImageView *waveMidImageView;
@property (weak, nonatomic) IBOutlet UIImageView *waveFarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *footBallImageView;
@property (assign, nonatomic) BOOL isStop;

@end

@implementation GBTowerView

-(void)showFootBallView:(BOOL)animate
{
    if (animate) {
        [self alpha:self.towerGroup    fade:YES duration:0.5 beginTime:0 completionBlock:^{}];
        [self alpha:self.footballGroup fade:NO duration:0.5 beginTime:0 completionBlock:^{}];
    }
    else{
        self.towerGroup.alpha = 0;
        self.footballGroup.alpha = 1;
    }

}

-(void)showTowerView:(BOOL)animate
{
    if (animate) {
        [self alpha:self.towerGroup    fade:NO  duration:0.5 beginTime:0 completionBlock:^{}];
        [self alpha:self.footballGroup fade:YES duration:0.5 beginTime:0 completionBlock:^{}];
    }
    else{
        self.towerGroup.alpha = 1;
        self.footballGroup.alpha = 0;
    }
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.isStop = YES;
}

-(void)animationStart
{
    self.isStop = NO;
    [self repeatAnimation];
}

-(void)repeatAnimation
{
    @weakify(self)
    [self alpha:self.waveNearImageView fade:YES duration:0.5 beginTime:0 completionBlock:^{}];
    [self alpha:self.waveMidImageView fade:YES duration:0.5 beginTime:0 completionBlock:^{}];
    [self alpha:self.waveFarImageView fade:YES duration:0.5 beginTime:0 completionBlock:^{
    [self alpha:self.waveNearImageView fade:NO duration:0.2 beginTime:0.2 completionBlock:^{
    [self alpha:self.waveMidImageView fade:NO duration:0.2 beginTime:0 completionBlock:^{
    [self alpha:self.waveFarImageView fade:NO duration:0.2 beginTime:0 completionBlock:^{
    @strongify(self)
    if (self.isStop == NO)
    {
        [self repeatAnimation];
        
    }
    }];}];}];}];
}

-(void)animationStop
{
    self.isStop = YES;
}

// alpha动画
-(void)alpha:(UIView*)view fade:(BOOL)fade duration:(CGFloat)duration beginTime:(CGFloat)beginTime completionBlock:(void(^)())completionBlock
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = duration;
    anim.beginTime = CACurrentMediaTime() + beginTime;
    if (fade){
        anim.fromValue = @(1.0);
        anim.toValue   = @(0.0);
    }
    else{
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

@end
