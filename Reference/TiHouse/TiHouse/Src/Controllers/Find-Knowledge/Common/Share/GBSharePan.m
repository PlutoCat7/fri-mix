//
//  GBSharePan.m
//  GB_Football
//
//  Created by Pizza on 2016/11/18.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBSharePan.h"
#import "GBShareItem.h"
#import <objc/runtime.h>
#import <pop/POP.h>
#import "UMShareManager.h"

@interface GBSharePan()<GBShareItemDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgMaskView;
@property (weak, nonatomic) IBOutlet UIView *panView;
@property (strong, nonatomic) IBOutletCollection(GBShareItem) NSArray *shareItems;
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;

@property (assign, nonatomic) BOOL showSingle;
@property (assign, nonatomic) NSInteger favorState;

@end

@implementation GBSharePan

-(void)awakeFromNib
{
    [super awakeFromNib];
    //[self setup];
}
// 界面展示
-(GBSharePan*)showSharePanWithDelegate:(id<GBSharePanDelegate>)delegate {
    return [self showSharePanWithDelegate:delegate showSingle:NO favorState:0];
}

-(GBSharePan*)showSharePanWithDelegate:(id<GBSharePanDelegate>)delegate favorState:(NSInteger)favorState {
    return [self showSharePanWithDelegate:delegate showSingle:NO favorState:favorState];
}

-(GBSharePan*)showSharePanWithDelegate:(id<GBSharePanDelegate>)delegate showSingle:(BOOL)showSingle {
    return [self showSharePanWithDelegate:delegate showSingle:showSingle favorState:0];
}

-(GBSharePan*)showSharePanWithDelegate:(id<GBSharePanDelegate>)delegate showSingle:(BOOL)showSingle favorState:(NSInteger)favorState {
    
    GBSharePan *sharePan = [ [[NSBundle mainBundle]loadNibNamed:@"GBSharePan" owner:nil options:nil] firstObject];
    sharePan.frame = [UIApplication sharedApplication].keyWindow.bounds;
    sharePan.delegate = delegate;
    sharePan.showSingle = showSingle;
    sharePan.favorState = favorState;
    for (GBShareItem *item in sharePan.shareItems) {
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
    Class hudClass = [GBSharePan class];
    for (UIView *aView in subViewsArray)
    {
        if ([aView isKindOfClass:hudClass])
        {
            GBSharePan *hud = (GBSharePan *)aView;
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
        if ([self.delegate respondsToSelector:@selector(GBSharePanActionCancel:)])
        {
            [self.delegate GBSharePanActionCancel:self];
        }
    }];
    
    if ([self.delegate respondsToSelector:@selector(GBSharePanActionWillHide:)])
    {
        [self.delegate GBSharePanActionWillHide:self];
    }
}

// 点击了分享按钮ICON
-(void)GBShareItemAction:(GBShareItem *)item tag:(SHARE_TYPE)tag
{
    if ([self.delegate respondsToSelector:@selector(GBSharePanAction:tag:)])
    {
        [self.delegate GBSharePanAction:self tag:tag];
    }
}

#pragma --
#pragma mark 动画


- (void)animationShow
{
    if ([self.delegate respondsToSelector:@selector(GBSharePanActionWillShow:)])
    {
        [self.delegate GBSharePanActionWillShow:self];
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
    NSInteger count = 0;
    for (GBShareItem *shareItem in self.shareItems) {
        if ([shareItem isShow]) {
            count++;
        }
    }
    // 简单处理背景颜色
    self.bottomBgView.backgroundColor = count > 4 ? [UIColor colorWithRGBHex:0x161618] : [UIColor colorWithRGBHex:0xffffff];
    
    // 推出弹框
    self.panView.top = self.panView.superview.height;
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.panView.top = self.panView.superview.height - self.panView.height;
    } completion:nil];

    // Items动画
    /*
    for (GBShareItem *item in self.shareItems)
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
     */
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
        if (self.favorState == 0) {
            [shareList addObject:@"4"];
        } else {
            [shareList addObject:@"5"];
        }
        
        [shareList addObject:@"6"];
    }
    
    char tmpTag[7] = {7,7,7,7,7,7,7};
    for (int i = 0; i < [shareList count]; i++)
    {
        tmpTag[i] = [shareList[i] integerValue];
    }
    for (GBShareItem *item in self.shareItems)
    {
        item.tag = tmpTag[[self.shareItems indexOfObject:item]];
    }
}

@end
