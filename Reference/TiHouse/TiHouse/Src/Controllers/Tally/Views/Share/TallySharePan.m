//
//  TallySharePan.m
//  GB_Football
//
//  Created by Pizza on 2016/11/18.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "TallySharePan.h"
#import "TallyShareItem.h"
#import <objc/runtime.h>
#import <pop/POP.h>
#import "UMShareManager.h"

@interface TallySharePan()<TallyShareItemDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgMaskView;
@property (weak, nonatomic) IBOutlet UIView *panView;
@property (strong, nonatomic) IBOutletCollection(TallyShareItem) NSArray *shareItems;

@property (assign, nonatomic) BOOL showSingle;

@end

@implementation TallySharePan

-(void)awakeFromNib
{
    [super awakeFromNib];
    //[self setup];
}
// 界面展示
-(TallySharePan*)showSharePanWithDelegate:(id<TallySharePanDelegate>)delegate
{
    return [self showSharePanWithDelegate:delegate showSingle:NO];
}

-(TallySharePan*)showSharePanWithDelegate:(id<TallySharePanDelegate>)delegate showSingle:(BOOL)showSingle {
    
    TallySharePan *sharePan = [ [[NSBundle mainBundle]loadNibNamed:@"TallySharePan" owner:nil options:nil] firstObject];
    sharePan.frame = [UIApplication sharedApplication].keyWindow.bounds;
    sharePan.delegate = delegate;
    sharePan.showSingle = showSingle;
    for (TallyShareItem *item in sharePan.shareItems) {
        item.delegate = self;
    }
    [sharePan setup];
    
    [[UIApplication sharedApplication].keyWindow addSubview:sharePan];
    [sharePan animationShow];
    return sharePan;
}

// 直接界面移除
-(void)hide:(void(^)(BOOL success))complete
{
    UIView *view = [UIApplication sharedApplication].keyWindow;
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [TallySharePan class];
    for (UIView *aView in subViewsArray)
    {
        if ([aView isKindOfClass:hudClass])
        {
            TallySharePan *hud = (TallySharePan *)aView;
            [hud animationHide:^(BOOL success){
                complete(success);
            }];
        }
    }
}

// 点击了取消按钮或空白区域
- (IBAction)actionPressCancel:(id)sender
{
    [self animationHide:^(BOOL success){
        if ([self.delegate respondsToSelector:@selector(TallySharePanActionCancel:)])
        {
            [self.delegate TallySharePanActionCancel:self];
        }
    }];
    
    if ([self.delegate respondsToSelector:@selector(TallySharePanActionWillHide:)])
    {
        [self.delegate TallySharePanActionWillHide:self];
    }
}

// 点击了分享按钮ICON
-(void)TallyShareItemAction:(TallyShareItem *)item tag:(SHARE_TYPE)tag
{
    if ([self.delegate respondsToSelector:@selector(TallySharePanAction:tag:)])
    {
        [self.delegate TallySharePanAction:self tag:tag];
    }
}

#pragma --
#pragma mark 动画


- (void)animationShow
{
    if ([self.delegate respondsToSelector:@selector(TallySharePanActionWillShow:)])
    {
        [self.delegate TallySharePanActionWillShow:self];
    }
    
    // 半透明背景
    self.bgMaskView.alpha = 0;
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(1.0);
    anim.completionBlock = ^(POPAnimation * animation, BOOL finish){
        self.hidden = NO;
        self.bgMaskView.alpha = 1.f;
        [self.bgMaskView pop_removeAnimationForKey:@"alpha"];
    };
    [self.bgMaskView pop_addAnimation:anim forKey:@"alpha"];
    
    // 推出弹框
    self.panView.top = self.panView.superview.height;
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.panView.top = self.panView.superview.height - self.panView.height;
    } completion:nil];

    // Items动画
    for (TallyShareItem *item in self.shareItems)
    {
         NSInteger idx = [self.shareItems indexOfObject:item];
        
        [UIView animateWithDuration:0.9+idx*0.1 delay:0 usingSpringWithDamping:0.52 initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect buttonFrame = [item frame];
            buttonFrame.origin.y -= 200;
            item.frame = buttonFrame;
        } completion:^(BOOL finished)
        {
            
        }];
    }
}

-(void)animationHide:(void(^)(BOOL success))complete
{
    // 半透明背景
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(0.0);
    anim.completionBlock = ^(POPAnimation * animation, BOOL finish){
        self.hidden = YES;
        self.bgMaskView.alpha = 0.f;
        [self.bgMaskView pop_removeAnimationForKey:@"alpha"];
        [self removeFromSuperview];
        complete(finish);
    };
    [self.bgMaskView pop_addAnimation:anim forKey:@"alpha"];
    // 推出弹框
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue = @([UIScreen mainScreen].bounds.size.height+self.panView.size.height/2);
    [self.panView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        if (finished){
            [self.panView.layer pop_removeAnimationForKey:@"positionAnimation"];
        }};
}

// 根据手机上是否安装客户端几种情况控制布局
-(void)setup
{
    NSMutableArray *shareList = [[NSMutableArray alloc]init];
    if ([UMShareManager isInstalledWechat])
    {
        [shareList addObject:@"0"];
        [shareList addObject:@"1"];
    }
    if ([UMShareManager isInstalledQQ])
    {
        [shareList addObject:@"2"];
    }
    if ([UMShareManager isInstalledWeiBo])
    {
        [shareList addObject:@"3"];
    }
    if (!self.showSingle) {
        [shareList addObject:@"4"];
        [shareList addObject:@"5"];
    }
    
    char tmpTag[6] = {6,6,6,6,6,6};
    for (int i = 0; i < [shareList count]; i++)
    {
        tmpTag[i] = [shareList[i] integerValue];
    }
    for (TallyShareItem *item in self.shareItems)
    {
        item.tag = tmpTag[[self.shareItems indexOfObject:item]];
    }
}

@end
