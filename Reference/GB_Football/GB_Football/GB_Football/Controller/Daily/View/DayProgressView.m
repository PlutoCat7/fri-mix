//
//  DayProgressView.m
//  GB_Football
//
//  Created by wsw on 16/8/26.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "DayProgressView.h"
#import "POPNumberAnimation.h"
#import "XXNibBridge.h"

#import "GBStepPicker.h"
#import "UserRequest.h"

#define kAppScale ([UIScreen mainScreen].bounds.size.width*1.0/375)

@interface DayProgressView ()<XXNibBridge,
POPNumberAnimationDelegate>

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetStepLabel;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (strong, nonatomic) POPNumberAnimation* numberAnimation;
@property (nonatomic, assign) CGFloat endAnlge;
@property (nonatomic, assign) NSInteger percentLength;

@property (nonatomic, assign) NSInteger step;

@end

@implementation DayProgressView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.numberAnimation = [[POPNumberAnimation alloc]init];
    self.numberAnimation.delegate = self;
    self.numberAnimation.fromValue      = 0;
    self.numberAnimation.duration       = 2.f;

    UIBezierPath *path=[UIBezierPath bezierPath];
    CGRect rect= self.bounds;
    rect.size = CGSizeMake(rect.size.width*kAppScale, rect.size.height*kAppScale);
    [path addArcWithCenter:CGPointMake(rect.size.width/2,rect.size.height/2) radius:rect.size.width/2 startAngle:0 endAngle:2*M_PI clockwise:NO];
    CAShapeLayer *arcLayer=[CAShapeLayer layer];
    arcLayer.path=path.CGPath;
    arcLayer.fillColor=[UIColor clearColor].CGColor;
    arcLayer.strokeColor=[UIColor blackColor].CGColor;
    arcLayer.lineWidth = 5*kAppScale;
    arcLayer.frame=rect;
    [self.layer addSublayer:arcLayer];
    
    [self updateTargetStepView];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self.progressLabel centerXInContainer];
}

- (void)setStep:(NSInteger)step {
    _step = step;
    
    NSInteger curTargetStep = [RawCacheManager sharedRawCacheManager].stepNumberGoal;
    CGFloat percent = (CGFloat)step/curTargetStep;
    if (percent > 9.99) {
        percent = 9.99;
    }
    
    self.endAnlge = (percent*2*M_PI) + 1.5*M_PI;
    self.progressLabel.text = [NSString stringWithFormat:@"%td", step];
    self.percentLength = self.progressLabel.text.length;
    [self.progressLabel resizeLabelHorizontal];
    self.progressLabel.width += 7*self.percentLength;
    
    self.progressLabel.text = @"0";
    self.numberAnimation.toValue = step;
    [self.numberAnimation saveValues];
    [self.numberAnimation startAnimation];
    
    [self setNeedsLayout];
    [self addProgressAnimation];
}

- (void)updateTargetStepView {
    [self.targetStepLabel setText:[NSString stringWithFormat:@"%@%td%@", LS(@"today.label.goal"), [RawCacheManager sharedRawCacheManager].stepNumberGoal, LS(@"today.label.step.single")]];
    
    [self setStep:self.step];
}

#pragma mark - action
- (IBAction)actionSetStep:(id)sender {
    @weakify(self)
    [GBStepPicker showWithSelectStep:[RawCacheManager sharedRawCacheManager].stepNumberGoal complete:^(NSInteger step) {
        
        @strongify(self)
        // 不相同才用重新设置
        if ([RawCacheManager sharedRawCacheManager].stepNumberGoal != step) {
            [self showLoadingToastWithText:nil];
            [UserRequest updateUserConfig:step handler:^(id result, NSError *error) {
                [self dismissToast];
                if (error) {
                    [self showToastWithText:error.domain];
                }else {
                    if (![RawCacheManager sharedRawCacheManager].userInfo.config) {  //第一次注册登录  config为空
                        
                        ConfigInfo *info = [[ConfigInfo alloc] init];
                        [RawCacheManager sharedRawCacheManager].userInfo.config = info;
                    }
                    [RawCacheManager sharedRawCacheManager].stepNumberGoal = step;
                    [RawCacheManager sharedRawCacheManager].userInfo.config.stepNumberGoal = step;
                    [[RawCacheManager sharedRawCacheManager].userInfo saveCache];
                    
                    [self updateTargetStepView];
                }
            }];
        }
    }];
}

#pragma mark - POPNumberAnimationDelegate

- (void)POPNumberAnimation:(POPNumberAnimation *)numberAnimation currentValue:(CGFloat)currentValue
{
    self.progressLabel.text = [NSString stringWithFormat:@"%td", (NSInteger)(currentValue)];
}

#pragma mark - Private

- (void)addProgressAnimation {
    [self.progressLayer removeAllAnimations];
    [self.progressLayer removeFromSuperlayer];
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGRect rect= self.bounds;
    [path addArcWithCenter:CGPointMake(rect.size.width/2,rect.size.height/2) radius:rect.size.width/2 startAngle:1.5*M_PI endAngle:self.endAnlge clockwise:YES];
    CAShapeLayer *arcLayer=[CAShapeLayer layer];
    arcLayer.path=path.CGPath;
    arcLayer.fillColor=[UIColor clearColor].CGColor;
    arcLayer.strokeColor=[UIColor colorWithHex:0x01e672].CGColor;
    arcLayer.lineWidth = 5*kAppScale;
    arcLayer.frame=rect;
    self.progressLayer = arcLayer;
    [self.layer addSublayer:arcLayer];
    [self drawLineAnimation:arcLayer];
}

-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=2;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue= @(1);
    [layer addAnimation:bas forKey:@"key"];
}

@end
