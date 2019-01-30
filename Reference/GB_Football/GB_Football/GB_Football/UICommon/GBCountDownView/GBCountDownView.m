//
//  GBCountDownView.m
//  MTCustomCountDownView
//
//  Created by 王时温 on 2017/7/4.
//  Copyright © 2017年 acmeway. All rights reserved.
//

#import "GBCountDownView.h"
#import "NSObject+Block.h"

#define KAnimationOneSecond 1
#define kAnimationDuration 0.55

@interface GBCountDownView ()<CAAnimationDelegate>

@property (nonatomic, copy) void(^completeHandler)();
@property (nonatomic, strong) NSArray<UIColor *> *backgroundColors;
@property (nonatomic, assign) NSInteger countDownNumber;

@end

@implementation GBCountDownView

+ (instancetype)show:(void(^)())handler {
    
    GBCountDownView *downView = [[GBCountDownView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    downView.completeHandler = handler;
    [[UIApplication sharedApplication].keyWindow addSubview:downView];
    [downView startAnimation];
    
    return downView;
}

- (void)dealloc
{
    
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initConfig];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (void)initConfig {
    
    self.backgroundColor = [UIColor colorWithRed:23.0f/255 green:23.0f/255 blue:23.0f/255 alpha:1];
    self.countDownNumber = 3;
    self.backgroundColors = @[[UIColor blackColor], [UIColor colorWithRed:16.0f/255 green:16.0f/255 blue:16.0f/255 alpha:1], [UIColor colorWithRed:23.0f/255 green:23.0f/255 blue:23.0f/255 alpha:1], [UIColor colorWithRed:32.0f/255 green:32.0f/255 blue:32.0f/255 alpha:1]];
}

#pragma mark - Public

- (void)startAnimation {
    
    [self numAction];
    if ([self.delegate respondsToSelector:@selector(didStartAnimation:)]) {
        [self.delegate didStartAnimation:self];
    }
}

#pragma mark - Animation

- (void)numAction
{
    
    if (self.countDownNumber < 0) {
        return;
    }
    UIView *backgroundView = [self backgroundViewWithColor:self.backgroundColors[self.countDownNumber]];
    
    if (self.countDownNumber == 0) {
        UILabel *goLabel = [self lableWithTitle:@"GO"];
        goLabel.textColor = [UIColor colorWithRed:53.f/255 green:205.f/255 blue:104.f/255 alpha:1];
        goLabel.hidden = YES;
        [self performBlock:^{
            [self animationGoWithLabel:goLabel backgroundView:backgroundView];
        } delay:0.1];
        self.countDownNumber--;
        return;
    }
    
    UILabel *numberLabel = [self lableWithTitle:@(self.countDownNumber).stringValue];
    [self animationShow:numberLabel backgroundView:backgroundView];
    [self performBlock:^{
        [self animationNumberWithLabel:numberLabel backgroundView:backgroundView];
    } delay:(KAnimationOneSecond-kAnimationDuration)];
    self.countDownNumber--;
}

- (void)animationShow:(UILabel *)label backgroundView:(UIView *)view {
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.duration = 0.3;
    animation2.fromValue = @(0.0);
    animation2.toValue = @(1.0);
    animation2.removedOnCompletion = YES;
    animation2.fillMode = kCAFillModeForwards;
    [label.layer addAnimation:animation2 forKey:@"addLayerAnimationOpacity"];
    [view.layer addAnimation:animation2 forKey:@"addLayerAnimationOpacity"];
}

- (void)animationNumberWithLabel:(UILabel *)label backgroundView:(UIView *)view {
    
    label.hidden = NO;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.duration = kAnimationDuration;
    animation2.fromValue = @(1.0);
    animation2.toValue = @(0.0);
    animation2.removedOnCompletion = YES;
    animation2.fillMode = kCAFillModeForwards;
    [label.layer addAnimation:animation2 forKey:@"addLayerAnimationOpacity"];
    [view.layer addAnimation:animation2 forKey:@"addLayerAnimationOpacity"];
    
    CABasicAnimation * animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = kAnimationDuration;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = @(1.0);
    animation.toValue = @(2.0);
    
    [label.layer addAnimation:animation forKey:@"addLayerAnimationScale"];
    
    [self performSelector:@selector(numAction) withObject:nil afterDelay:kAnimationDuration-0.15];
    [self performBlock:^{
        [label removeFromSuperview];
        [view removeFromSuperview];
    } delay:(0.5)];
}

- (void)animationGoWithLabel:(UILabel *)label backgroundView:(UIView *)view {
    
    label.hidden = NO;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.duration = 0.15;
    animation2.fromValue = @(0.0);
    animation2.toValue = @(1.0);
    animation2.removedOnCompletion = YES;
    animation2.fillMode = kCAFillModeForwards;
    [label.layer addAnimation:animation2 forKey:@"addLayerAnimationOpacity"];
    [view.layer addAnimation:animation2 forKey:@"addLayerAnimationOpacity"];
    
    CABasicAnimation * animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.15;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = @(2.0);
    animation.toValue = @(1.0);
    
    [label.layer addAnimation:animation forKey:@"addLayerAnimationScale"];
    
    [self performBlock:^{  //停留0.5s
        [self animationNumberWithLabel:label backgroundView:self];
        BLOCK_EXEC(self.completeHandler);
        if ([self.delegate respondsToSelector:@selector(didFinishAnimation:)]) {
            [self.delegate didFinishAnimation:self];
        }
    } delay:(0.15+0.5)];
    
}

#pragma mark - Setter and Getter

- (UILabel *)lableWithTitle:(NSString *)title {
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    [label setFont:[UIFont systemFontOfSize:140]];
    [label setTextColor:[UIColor whiteColor]];
    label.textAlignment = NSTextAlignmentCenter;
    label.opaque = YES;
    label.text = title;
    [self addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

- (UIView *)backgroundViewWithColor:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.center = self.center;
    view.backgroundColor = color;
    
    [self insertSubview:view atIndex:0];
    return view;
}

@end
