//
//  GBPositionSelectView.m
//  GB_Team
//
//  Created by Pizza on 16/9/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBPositionSelectView.h"
#import "GBPostionItem.h"
#import "GBHightLightButton.h"
#import <pop/POP.h>
#import "XXNibBridge.h"

@interface GBPositionSelectView ()<XXNibBridge>
@property (strong, nonatomic) IBOutletCollection(GBPostionItem) NSArray *positonItemCollection;
@property (weak, nonatomic) IBOutlet GBHightLightButton *okButton;
// 变色背景
@property (weak, nonatomic) IBOutlet UIView *backView;
// 弹出框
@property (weak, nonatomic) IBOutlet UIView *popBox;
@property (nonatomic, strong) NSMutableArray<NSString *> *selectIndexList;

@end

@implementation GBPositionSelectView

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}


#pragma mark - Action

- (IBAction)okButtonAction:(id)sender {
    BLOCK_EXEC(self.saveBlock, [self.selectIndexList copy]);
}
- (IBAction)actionClose:(id)sender {
    [GBPositionSelectView hide];
}

#pragma mark - Private

-(void)setupUI
{
    [self.positonItemCollection enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GBPostionItem *item = obj;
        @weakify(self)
        [item.button addActionHandler:^(NSInteger tag) {
            
            @strongify(self)
            if (self.selectIndexList.count == 2 && !item.selected) {
                [self showToastWithText:LS(@"只能选择两个擅长位置")];
                return;
            }
            if (item.selected) {
                [self.selectIndexList removeObject:@(item.tag).stringValue];
            }else {
                [self.selectIndexList addObject:@(item.tag).stringValue];
            }
            item.selected = !item.selected;
            self.okButton.enabled = (self.selectIndexList.count == 2);
        }];
    }];
    
    [self.positonItemCollection enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GBPostionItem *item = obj;
        for (NSString *number in self.selectIndexList) {
            if (item.tag==number.integerValue) {
                item.selected = YES;
                break;
            }else {
                item.selected = NO;
            }
        }
    }];
}


-(void)popAnimation
{
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.duration = 0.5f;
    positionAnimation.fromValue = @([UIScreen mainScreen].bounds.size.width);
    positionAnimation.toValue   = @([UIScreen mainScreen].bounds.size.width-470/2);
    [self.popBox.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){if (finished)
    {
        [self.popBox.layer pop_removeAnimationForKey:@"positionAnimation"];
    }};
    
    [self alphaHalf:self.backView  fade:NO duration:0.5f  beginTime:0 completionBlock:^{}];
    
}

-(void)hideAnimation:(void(^)())completionBlock;
{
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.duration    = 0.5f;
    positionAnimation.fromValue   = @([UIScreen mainScreen].bounds.size.width-470/2);
    positionAnimation.toValue     = @([UIScreen mainScreen].bounds.size.width+470/2);
    [self.popBox.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        if (finished){
            [self.popBox.layer pop_removeAnimationForKey:@"positionAnimation"];
            [self.popBox removeFromSuperview];
            BLOCK_EXEC(completionBlock);
        }};
    [self alphaHalf:self.backView  fade:YES duration:0.5f  beginTime:0 completionBlock:^{}];
}

-(void)alphaHalf:(UIView*)view fade:(BOOL)fade duration:(CGFloat)duration beginTime:(CGFloat)beginTime completionBlock:(void(^)())completionBlock
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = duration;
    anim.beginTime = CACurrentMediaTime() + beginTime;
    if (fade)
    {
        anim.fromValue = @(0.7);
        anim.toValue   = @(0.0);
    }
    else
    {
        anim.fromValue = @(0.0);
        anim.toValue   = @(0.7);
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

#pragma mark - Getters & Setters

// 弹出
+(GBPositionSelectView *)showWithSelectList:(NSArray<NSString *> *)selectList
{
    GBPositionSelectView *selectView = [[[NSBundle mainBundle] loadNibNamed:@"GBPositionSelectView" owner:nil options:nil]
                                        lastObject];
    selectView.backView.alpha = 0.0f;
    selectView.selectIndexList = [NSMutableArray arrayWithArray:selectList];
    selectView.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:selectView];
    [selectView popAnimation];
    [selectView setupUI];
    return selectView;
}

// 收起
+(void)hide
{
    GBPositionSelectView *selectView = [GBPositionSelectView HUDForView];
    if (selectView)
    {

        [selectView hideAnimation:^(void){
             [selectView removeFromSuperview];
        }];
    }
}

+ (GBPositionSelectView *)HUDForView
{
    GBPositionSelectView *hud = nil;
    NSArray *subViewsArray = [UIApplication sharedApplication].keyWindow.subviews;
    Class hudClass = [GBPositionSelectView class];
    for (UIView *aView in subViewsArray)
    {
        if ([aView isKindOfClass:hudClass])
        {
            hud = (GBPositionSelectView *)aView;
        }
    }
    return hud;
}

@end

