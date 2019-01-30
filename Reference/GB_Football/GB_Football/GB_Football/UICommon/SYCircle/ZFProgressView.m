

#import "ZFProgressView.h"

#define DefaultLineWidth 2.f
static NSString *timerName = @"AnimationTimer";


@interface ZFProgressView ()

@property (nonatomic,strong) CAShapeLayer *backgroundLayer;
@property (nonatomic,strong) CAShapeLayer *progressLayer;
@property (nonatomic,strong) CALayer *imageLayer;
@property (nonatomic,strong) UILabel *progressLabel;
@property (nonatomic,assign) CGFloat sumSteps;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSMutableDictionary *timerContainer;

@end

@implementation ZFProgressView

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        self.innerBackgroundColor = [UIColor clearColor];
        self.startAngle = -90 *(M_PI / 180.0);
        self.endAngle = (-90 + 360) *(M_PI / 180.0);
        [self layoutViews];
        self.GapWidth = 10.0;
        self.backgourndLineWidth = DefaultLineWidth;
        self.progressLineWidth = DefaultLineWidth;
        _Percentage = 0;
        _offset = 0;
        _sumSteps = 0;
        _step = 0.1;
        _timeDuration = 5.0;
    }
    return self;
}


-(void) layoutViews
{
    [self.progressLabel setTextColor:[UIColor whiteColor]];
    self.progressLabel.backgroundColor = _innerBackgroundColor;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressLabel.layer.cornerRadius = self.bounds.size.width /2;
        self.progressLabel.layer.masksToBounds = YES;
    });
    self.progressLabel.text = @"0%";
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.font = [UIFont systemFontOfSize:25 weight:0.4];
    self.progressLabel.hidden = YES;
    [self addSubview:self.progressLabel];
    
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
        //最小0.5个弧度
        static float minAngle = 0.5 *(2 * M_PI)/360;
   
        CGFloat totalAngle = self.endAngle - self.startAngle;
        if (totalAngle < 0)
        {
            totalAngle += M_PI *2;
        }
        for (int i = 0; i < ceil(360 *(totalAngle / (M_PI *2))/ _GapWidth)+1; i++)
        {
            CGFloat angle = (i * (_GapWidth + minAngle) * M_PI / 180.0);
            if (i == 0  && ((totalAngle - M_PI_2) == 0
                            || (totalAngle - M_PI*2/2) == 0
                            || (totalAngle - M_PI*3/2) == 0
                            || (totalAngle - M_PI*4/2) == 0)
                        && (fabs(self.startAngle) == 0
                            || (fabs(self.startAngle) - M_PI_2) == 0
                            || (fabs(self.startAngle) - M_PI*2/2) == 0
                            || (fabs(self.startAngle) - M_PI*3/2) == 0
                            || (fabs(self.startAngle) - M_PI*4/2) == 0))
            {
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
        for (int i = 0; i < ceil(360 *(totalAngle / (M_PI *2)) / _GapWidth *_Percentage)+1; i++) {
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

-(UILabel *)progressLabel
{
    if(!_progressLabel)
    {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width - 100)/2, (self.bounds.size.height - 100)/2, 100, 100)];
    }
    return _progressLabel;
}

- (NSMutableDictionary *)timerContainer
{
    if (!_timerContainer) {
        _timerContainer = [[NSMutableDictionary alloc] init];
    }
    return _timerContainer;
}

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

-(void)setPercentage:(CGFloat)Percentage
{
    _Percentage = Percentage;
    [self setProgressCircleLine];
    [self setBackgroundCircleLine];
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
    _progressLabel.textColor = digitTintColor;
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
    [self setProgress:1.0 Animated:YES];
}

-(void)setInnerBackgroundColor:(UIColor *)innerBackgroundColor
{
    _innerBackgroundColor = innerBackgroundColor;
    [self layoutViews];
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
-(void)setProgress:(CGFloat)Percentage Animated:(BOOL)animated
{
    self.Percentage = Percentage;
    if (animated) {
  
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = [NSNumber numberWithFloat:0.0];
        animation.toValue = [NSNumber numberWithFloat:1.0];
        animation.duration = self.timeDuration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [_progressLayer addAnimation:animation forKey:@"strokeEndAnimation"];
        [self cancelTimerWithName:timerName];
        __weak typeof(self) weakSelf = self;

        [self scheduledDispatchTimerWithName:timerName timeInterval:_step queue:nil repeats:YES action:^{
            [weakSelf numberAnimation];
        }];

    } else {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _progressLayer.strokeEnd = _Percentage;
        _progressLabel.text = [NSString stringWithFormat:@"%.0f%%",_Percentage*100];
        [CATransaction commit];
    }
}


-(void)numberAnimation
{
    _sumSteps += _step;
    float sumSteps =  _Percentage /_timeDuration *_sumSteps;
    if (_sumSteps >= _timeDuration) {
        [self cancelTimerWithName:timerName];
        return;
    }
    _progressLabel.text = [NSString stringWithFormat:@"%.0f%%",sumSteps *100];
}

- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(double)interval
                                 queue:(dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                                action:(dispatch_block_t)action
{
    if (nil == timerName)
        return;
    
    if (nil == queue)
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    if (!timer) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_resume(timer);
        [self.timerContainer setObject:timer forKey:timerName];
    }
    
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新主界面
            action();
        });
        
        if (!repeats) {
            [weakSelf cancelTimerWithName:timerName];
        }
    });
    
}

- (void)cancelTimerWithName:(NSString *)timerName
{
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    
    if (!timer) {
        return;
    }
    
    [self.timerContainer removeObjectForKey:timerName];
    dispatch_source_cancel(timer);
    
}

@end
