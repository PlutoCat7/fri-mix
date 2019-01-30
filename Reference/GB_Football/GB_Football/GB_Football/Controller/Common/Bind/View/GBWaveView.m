//
//  GBWaveView.m
//  GB_Football
//
//  Created by Pizza on 2016/12/20.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBWaveView.h"
#import "XXNibBridge.h"
#import "GBPopAnimateTool.h"
#import <pop/POP.h>

#define Duration   0.88f
#define BeginScale 0.08f
#define BeginColor 0.08f

@interface GBWaveView()<XXNibBridge>
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *items;
@property (weak, nonatomic) IBOutlet UIImageView *pairX;
@end


@implementation GBWaveView
-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)animationStart
{
    for (UIView *item in self.items)
    {
        [GBPopAnimateTool popScale:item x:1 y:item.tag% 2 ? 0.5f:2.f repeat:YES duration:Duration beginTime:BeginScale*item.tag completionBlock:^{}];
        [GBPopAnimateTool popColored:item color:[UIColor greenColor] repeat:YES duration:Duration beginTime:BeginColor*item.tag completionBlock:^{}];
    }
}

-(void)animationReStart
{
    [GBPopAnimateTool popFade:self.pairX fade:YES repeat:NO duration:1.0 beginTime:0 completionBlock:^{}];
    for (UIView *item in self.items)
    {
        [GBPopAnimateTool popScale:item x:1 y:item.tag% 2 ? 0.5f:2.f repeat:YES duration:Duration beginTime:BeginScale*item.tag completionBlock:^{}];
        [GBPopAnimateTool popColored:item color:[UIColor greenColor] repeat:YES duration:Duration beginTime:BeginColor*item.tag completionBlock:^{}];
    }
}

-(void)animationStop
{
    [GBPopAnimateTool popFade:self.pairX fade:NO repeat:NO duration:1.0 beginTime:0 completionBlock:^{}];
    for (UIView *item in self.items)
    {
        [item pop_removeAllAnimations];
        [GBPopAnimateTool popScale:item x:1 y:1 repeat:NO duration:Duration beginTime:BeginScale*item.tag completionBlock:^{}];
        [GBPopAnimateTool popColored:item color:[UIColor colorWithHex:0x3f3f3f] repeat:NO duration:Duration beginTime:BeginScale/4*item.tag completionBlock:^{}];
    }
}

@end
