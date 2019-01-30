//
//  GBGameCompletePreview.m
//  GB_Football
//
//  Created by wsw on 16/8/23.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBGameCompletePreview.h"
#import <pop/POP.h>
#import "GBBoxButton.h"

@interface GBGameCompletePreview ()

// 弹出框背景（动画用）
@property (weak, nonatomic) IBOutlet UIView *tipBack;
// 弹出框   （动画用）
@property (weak, nonatomic) IBOutlet UIView *boxView;

@property (weak, nonatomic) IBOutlet UILabel *gameTime;

@property (weak, nonatomic) IBOutlet UILabel *nomalFirstHalfBeginTimeLabel;
// 常规赛上半场结束时间
@property (weak, nonatomic) IBOutlet UILabel *nomalFirstHalfEndTimeLabel;
// 常规赛下半场开始时间
@property (weak, nonatomic) IBOutlet UILabel *nomalSecondHalfBeginTimeLabel;
// 常规赛下半场结束时间
@property (weak, nonatomic) IBOutlet UILabel *nomalSecondHalfEndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherScore;
// 静态国际化标签
@property (weak, nonatomic) IBOutlet UILabel *titleStLabel;
@property (weak, nonatomic) IBOutlet UILabel *wholeStLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstStLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondStLabel;
@property (weak, nonatomic) IBOutlet UILabel *ourStLabel;
@property (weak, nonatomic) IBOutlet UILabel *oppStLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreStLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipStLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tipStLabel2;
@property (weak, nonatomic) IBOutlet UILabel *tipStLabel3;
@property (weak, nonatomic) IBOutlet GBBoxButton *cancelStButton;
@property (weak, nonatomic) IBOutlet GBBoxButton *okStButton;

@property (nonatomic, copy) void(^completeBlock)(NSInteger index);

@end

@implementation GBGameCompletePreview
-(void)localizeUI{
    self.titleStLabel.text = LS(@"post.popbox.title");
    self.wholeStLabel.text = LS(@"post.popbox.label.whole");
    self.firstStLabel.text = LS(@"post.popbox.label.first.half");
    self.secondStLabel.text = LS(@"post.popbox.label.second.half");
    self.ourStLabel.text = LS(@"post.popbox.label.our");
    self.oppStLabel.text = LS(@"post.popbox.label.opp");
    self.scoreStLabel.text = LS(@"post.popbox.label.score");
    self.tipStLabel1.text = LS(@"post.popbox.label.message1");
    self.tipStLabel2.text = LS(@"post.popbox.label.message2");
    self.tipStLabel3.text = LS(@"post.popbox.label.message3");
    [self.cancelStButton setTitle:LS(@"common.btn.cancel") forState:UIControlStateNormal];
    [self.okStButton setTitle:LS(@"common.btn.yes") forState:UIControlStateNormal];
    
}

+ (void)showWithComplete:(void(^)(NSInteger index))complete dataList:(NSArray<NSString *> *)dataList {
    
    if (dataList.count < 7) {
        return;
    }
    
    NSArray *xibArray= [[NSBundle mainBundle]loadNibNamed:@"GBGameCompletePreview" owner:nil options:nil];
    GBGameCompletePreview *preView = [xibArray firstObject];
    preView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [preView localizeUI];
    preView.completeBlock = complete;
    preView.gameTime.text = dataList[0];
    preView.nomalFirstHalfBeginTimeLabel.text = dataList[1];
    preView.nomalFirstHalfEndTimeLabel.text = dataList[2];
    preView.nomalSecondHalfBeginTimeLabel.text = dataList[3];
    preView.nomalSecondHalfEndTimeLabel.text = dataList[4];
    preView.weScoreLabel.text = dataList[5];
    preView.otherScore.text = dataList[6];
    [[UIApplication sharedApplication].keyWindow addSubview:preView];
    [preView showPopBox];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
}

#pragma mark - Action

- (IBAction)cancelEvent:(id)sender {
    
    [self hidePopBox];
    BLOCK_EXEC(self.completeBlock, 0);
}

- (IBAction)okEvent:(id)sender {
    
    [self hidePopBox];
    BLOCK_EXEC(self.completeBlock, 1);
}


#pragma mark - Private

- (void)showPopBox {
    
    self.tipBack.alpha = 0;
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(1.0);
    anim.completionBlock = ^(POPAnimation * animation, BOOL finish){
        self.hidden = NO;
        self.tipBack.alpha = 1.f;
        [self.tipBack pop_removeAnimationForKey:@"alpha"];
    };
    [self.tipBack pop_addAnimation:anim forKey:@"alpha"];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.2, 0.2)];
    scaleAnimation.toValue   = [NSValue valueWithCGSize:CGSizeMake(1,1)];
    scaleAnimation.springBounciness = 15.f;
    scaleAnimation.completionBlock = ^(POPAnimation * animation, BOOL finish){
        [self.boxView.layer pop_removeAnimationForKey:@"scaleAnim"];
    };
    [self.boxView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
}

-(void)hidePopBox
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(0.0);    anim.completionBlock = ^(POPAnimation * animation, BOOL finish){
        self.hidden = YES;
        self.tipBack.alpha = 0.f;
        [self.tipBack pop_removeAnimationForKey:@"alpha"];
        [self removeFromSuperview];
    };
    [self.tipBack pop_addAnimation:anim forKey:@"alpha"];
}

-(void)dealloc
{
    [self.boxView.layer pop_removeAllAnimations];
    [self.tipBack pop_removeAllAnimations];
}
@end
