//
//  RunLightView.m
//  GB_Football
//
//  Created by gxd on 17/7/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "RunLightView.h"


#define DefaultLineWidth 2.f
static NSString *timerName = @"AnimationTimer";

typedef enum {
    AnimType_Unknow = -1,
    AnimType_Stretch = 0,
    AnimType_Shrink
}AnimType;

@interface RunLightView () <CAAnimationDelegate>

@property (nonatomic,strong) CAShapeLayer *backgroundLayer;
@property (nonatomic,strong) CAShapeLayer *progressLayer;
@property (nonatomic,strong) CALayer *imageLayer;

@property (nonatomic,assign) AnimType animType;
@property (nonatomic,assign) BOOL animStart;

@property (nonatomic, strong) NSTimer *runningTimer;

@end

@implementation RunLightView

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        self.startAngle = -90 *(M_PI / 180.0);
        self.endAngle = (-90 + 360) *(M_PI / 180.0);
        [self layoutViews];
        self.GapWidth = 10.0;
        self.backgourndLineWidth = DefaultLineWidth;
        self.progressLineWidth = DefaultLineWidth;
        _timeDuration = 5.0;
        _animType = AnimType_Unknow;
    }
    return self;
}


-(void) layoutViews
{
    if (!_backgroundLayer) {
        _backgroundLayer = [CAShapeLayer layer];
        dispatch_async(dispatch_get_main_queue(), ^{
            _backgroundLayer.frame = self.bounds;
        });
        _backgroundLayer.fillColor = nil;
        _backgroundLayer.strokeColor = [UIColor blackColor].CGColor;
    }
    
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        dispatch_async(dispatch_get_main_queue(), ^{
            _progressLayer.frame = self.bounds;
        });
        _progressLayer.fillColor = nil;
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    }
    _backgroundLayer.lineCap = kCALineCapRound;
    _backgroundLayer.lineJoin = kCALineCapRound;
    
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineJoin = kCALineCapRound;
    [_imageLayer removeFromSuperlayer];
    _imageLayer = nil;
    [self.layer addSublayer:_backgroundLayer];
    [self.layer addSublayer:_progressLayer];
    
    
}
#pragma mark - draw circleLine
-(void) setBackgroundCircleLine
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    //0.5个弧度
    static float minAngle = 0.5 * (2 * M_PI)/360;
    
    CGFloat totalAngle = self.endAngle - self.startAngle;
    
    if (totalAngle < 0) {
        totalAngle += M_PI *2;
    }
    for (int i = 0; i < ceil(360 *(totalAngle / (M_PI *2)) / _GapWidth)+1; i++) {
        CGFloat angle = (i * (_GapWidth + minAngle) * M_PI / 180.0);
        
        if (i == 0  && ((totalAngle - M_PI_2) == 0
                        || (totalAngle - M_PI*2/2) == 0
                        || (totalAngle - M_PI*3/2) == 0
                        || (totalAngle - M_PI*4/2) == 0)
            && (fabs(self.startAngle) == 0
                || (fabs(self.startAngle) - M_PI_2) == 0
                || (fabs(self.startAngle) - M_PI*2/2) == 0
                || (fabs(self.startAngle) - M_PI*3/2) == 0
                || (fabs(self.startAngle) - M_PI*4/2) == 0)){
                angle = minAngle * M_PI/180.0;
            }
        
        if (angle >= totalAngle) {
            angle = totalAngle;
        }
        UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x,
                                                                                self.center.y - self.frame.origin.y)
                                                             radius:(self.bounds.size.width - _backgourndLineWidth)/ 2 - _offset
                                                         startAngle:self.startAngle +(i *_GapWidth * M_PI / 180.0)
                                                           endAngle:self.startAngle + angle
                                                          clockwise:YES];
        
        [path appendPath:path1];
        
    }
    _backgroundLayer.path = path.CGPath;
    
}

-(void)setProgressCircleLine
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    //0.5个弧度
    static float minAngle = 0.5 * (2 * M_PI)/360;
    
    CGFloat totalAngle = self.endAngle - self.startAngle;
    
    if (totalAngle < 0) {
        totalAngle += M_PI *2;
    }
    for (int i = 0; i < ceil(360 *(totalAngle / (M_PI *2)) / _GapWidth)+1; i++) {
        CGFloat angle = (i * (_GapWidth + minAngle) * M_PI / 180.0);
        
        if (i == 0  && ((totalAngle - M_PI_2) == 0
                        || (totalAngle - M_PI*2/2) == 0
                        || (totalAngle - M_PI*3/2) == 0
                        || (totalAngle - M_PI*4/2) == 0)
            && (fabs(self.startAngle) == 0
                || (fabs(self.startAngle) - M_PI_2) == 0
                || (fabs(self.startAngle) - M_PI*2/2) == 0
                || (fabs(self.startAngle) - M_PI*3/2) == 0
                || (fabs(self.startAngle) - M_PI*4/2) == 0)){
                angle = minAngle * M_PI/180.0;
            }
        
        if (angle >= totalAngle) {
            angle = totalAngle;
        }
        UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x,
                                                                                self.center.y - self.frame.origin.y)
                                                             radius:(self.bounds.size.width - _progressLineWidth)/ 2 - _offset
                                                         startAngle:self.startAngle +(i *_GapWidth * M_PI / 180.0)
                                                           endAngle:self.startAngle + angle
                                                          clockwise:YES];
        
        [path appendPath:path1];
        
    }
    _progressLayer.path = path.CGPath;
}


#pragma mark - setter and getter methond

-(void)setBackgourndLineWidth:(CGFloat)backgourndLineWidth
{
    _backgourndLineWidth = backgourndLineWidth;
    _backgroundLayer.lineWidth = backgourndLineWidth;
}

-(void)setProgressLineWidth:(CGFloat)progressLineWidth
{
    _progressLineWidth = progressLineWidth;
    _progressLayer.lineWidth = progressLineWidth;
    [self setBackgroundCircleLine];
    [self setProgressCircleLine];
}

-(void)setBackgroundStrokeColor:(UIColor *)backgroundStrokeColor
{
    _backgroundStrokeColor = backgroundStrokeColor;
    _backgroundLayer.strokeColor = backgroundStrokeColor.CGColor;
}

-(void)setProgressStrokeColor:(UIColor *)progressStrokeColor
{
    _progressStrokeColor = progressStrokeColor;
    _progressLayer.strokeColor = progressStrokeColor.CGColor;
    
}

-(void)setDigitTintColor:(UIColor *)digitTintColor
{
    _digitTintColor = digitTintColor;
}

-(void)setGapWidth:(CGFloat)GapWidth
{
    _GapWidth = GapWidth;
    [self setBackgroundCircleLine];
    [self setProgressCircleLine];
    
}

-(void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    
    _progressLineWidth = lineWidth;
    _progressLayer.lineWidth = lineWidth;
    
    _backgourndLineWidth = lineWidth;
    _backgroundLayer.lineWidth = lineWidth;
}


-(void)setImage:(UIImage *)image
{
    _image = image;
    [self layoutViews];
}

-(void)setTimeDuration:(CGFloat)timeDuration
{
    _timeDuration = timeDuration;
}

-(void)setStartAngle:(CGFloat)startAngle
{
    _startAngle = startAngle;
    [self layoutViews];
}
-(void)setEndAngle:(CGFloat)endAngle
{
    _endAngle = endAngle;
    [self layoutViews];
}

#pragma mark - progress animated YES or NO
- (void)beginRunLight {
    if (self.runningTimer) {
        return;
    }
    
    [_progressLayer removeAllAnimations];
    [_backgroundLayer removeAllAnimations];
    
    self.animStart = YES;
    
    self.runningTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeDuration block:^(NSTimer * _Nonnull timer) {
        if (self.animType == AnimType_Shrink || self.animType == AnimType_Unknow) {
            [self startProgressAnim];
        } else if (self.animType == AnimType_Stretch) {
            [self startBackgroundAnim];
            
        }
        
    } repeats:YES];
    [self.runningTimer fire];
}

- (void)endRunLight {
    self.animStart = NO;
    self.animType = AnimType_Unknow;
    [_progressLayer removeAllAnimations];
    [_backgroundLayer removeAllAnimations];
    
    [self.runningTimer invalidate];
    self.runningTimer = nil;
}

- (void)startProgressAnim {
    self.animType = AnimType_Stretch;
    
    if ([_backgroundLayer superlayer]) {
        [_backgroundLayer removeFromSuperlayer];
    }
    if ([_progressLayer superlayer]) {
        [_progressLayer removeFromSuperlayer];
    }
    
    [self.layer addSublayer:_backgroundLayer];
    [self.layer addSublayer:_progressLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:1.0];
    animation.duration = self.timeDuration;
    //animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [_progressLayer addAnimation:animation forKey:@"strokeEndAnimation"];
}

- (void)startBackgroundAnim {
    self.animType = AnimType_Shrink;
    
    if ([_backgroundLayer superlayer]) {
        [_backgroundLayer removeFromSuperlayer];
    }
    if ([_progressLayer superlayer]) {
        [_progressLayer removeFromSuperlayer];
    }
    
    [self.layer addSublayer:_progressLayer];
    [self.layer addSublayer:_backgroundLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:1.0];
    animation.duration = self.timeDuration;
    //animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [_backgroundLayer addAnimation:animation forKey:@"strokeEndAnimation"];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    GBLog(@"%d", flag);
    if (flag && self.animStart) {
        if (self.animType == AnimType_Stretch) {
            [self startBackgroundAnim];
            
        } else if (self.animType == AnimType_Shrink) {
            [self startProgressAnim];
        }
    }
}

@end
