//
//  GBSwtich.m
//  GB_TransferMarket
//
//  Created by Pizza on 2017/1/3.
//  Copyright © 2017年 gxd. All rights reserved.
//

#import "GBSwtich.h"
#import "XXNibBridge.h"
#import "GBPopAnimateTool.h"

@interface GBSwtich()<XXNibBridge>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ballPosX;

@end

@implementation GBSwtich

- (IBAction)actionToggle:(id)sender
{
    [UIView animateWithDuration:.15f animations:^{
        [self layoutIfNeeded];
    }completion:^(BOOL ok){
        if (!ok) return;
        BLOCK_EXEC(self.action);
    }];
}

- (void)setOn:(BOOL)on {
    
    _on = on;
    self.ballPosX.constant = on?(self.width/2-1.0f):1.f;
    
    if (!_on) {
        [GBPopAnimateTool popAppear:self.ballGray disappear:self.ballRed duration:0.15f beginTime:0 completionBlock:^{}];
        [GBPopAnimateTool popAppear:self.bgClose disappear:self.bgOpen duration:0.15f beginTime:0 completionBlock:^{}];
    }else {
        [GBPopAnimateTool popAppear:self.ballRed disappear:self.ballGray duration:0.15f beginTime:0 completionBlock:^{}];
        [GBPopAnimateTool popAppear:self.bgOpen disappear:self.bgClose duration:0.15f beginTime:0 completionBlock:^{}];
    }
}

@end
