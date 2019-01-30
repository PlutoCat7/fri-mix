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
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (strong, nonatomic) IBOutletCollection(GBShareItem) NSArray *shareItems;

@end

@implementation GBSharePan

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}
// 界面展示
-(GBSharePan*)showSharePanWithDelegate:(id<GBSharePanDelegate>)delegate
{
    GBSharePan *sharePan = [ [[NSBundle mainBundle]loadNibNamed:@"GBSharePan" owner:nil options:nil] firstObject];
    sharePan.frame = [UIApplication sharedApplication].keyWindow.bounds;
    sharePan.delegate = delegate;
    [sharePan.buttonCancel setTitle:LS(@"share.btn.cancel") forState:UIControlStateNormal];
    for (GBShareItem *item in sharePan.shareItems)
    {
        item.delegate = self;
    }
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
                    BLOCK_EXEC(complete,success);
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
    
    // 推出弹框
    self.panView.top = self.panView.superview.height;
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.panView.top = self.panView.superview.height - self.panView.height;
    } completion:nil];

    // Items动画
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
        BLOCK_EXEC(complete,finish);
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
        [shareList addObject:@"3"];
    }
    if ([UMShareManager isInstalledWeiBo])
    {
        [shareList addObject:@"4"];
    }
    char tmpTag[5] = {5,5,5,5,5};
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
