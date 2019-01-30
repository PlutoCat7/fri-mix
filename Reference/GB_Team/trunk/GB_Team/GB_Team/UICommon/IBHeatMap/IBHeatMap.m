//
//  IBHeatMap.m
//  Ivan Bruel
//
//  Created by Ivan Bruel on 02/07/14.
//  Copyright (c) 2014 Ivan Bruel. All rights reserved.
//

#import "IBHeatMap.h"
#import "IBMatrix.h"

@interface PointInfo : NSObject

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, assign) NSInteger count;

@end

@implementation PointInfo

@end

@interface IBHeatMap ()

@property (nonatomic, strong) IBMatrix *colorMatrix;
@property (nonatomic, strong) IBMatrix *densityMatrix;
@property (nonatomic, assign) BOOL needStop;

@property (nonatomic, strong) NSMutableArray<PointInfo *> *coordinatePoints;
@property (nonatomic, assign) CGPoint topPoint;
@property (nonatomic, assign) CGPoint leftPoint;
@property (nonatomic, assign) CGPoint bottomPoint;
@property (nonatomic, assign) CGPoint rightPoint;

@end


@implementation IBHeatMap

- (void)dealloc
{
    
}

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame points:(NSArray *)points colors:(NSArray *)colors pointRadius:(CGFloat)pointRadius
{
    self = [super initWithFrame:frame];
    if(self) {
        [self commonInit];
        _colors = colors;
        _points = points;
        _pointRadius = pointRadius;
        self.backgroundColor = [UIColor clearColor];
        
        [self redrawView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _colors = @[];
    _points = @[];
    _pointRadius = 0;
    _topPoint = CGPointMake(10000, 10000);
    _leftPoint = CGPointMake(10000, 10000);
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Public

- (void)setColors:(NSArray *)colors
{
    _colors = colors;
    [self redrawView];
}

- (void)setPoints:(NSArray *)points
{
    _points = points;
    [self redrawView];
}

- (void)setPointRadius:(CGFloat)pointRadius
{
    _pointRadius = pointRadius;
    [self redrawView];
}

- (void)stopRedrawView {
    
    _needStop = YES;
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (NSInteger x = 0; x < CGRectGetWidth(self.bounds); x ++) {
        for (NSInteger y = 0; y < CGRectGetHeight(self.bounds); y ++) {
            UIColor *color = [self.colorMatrix objectForColumn:x line:y];
            if ([color isKindOfClass:[UIColor class]]) {
                CGContextSetFillColorWithColor(context, color.CGColor);
                CGContextFillRect(context, CGRectMake(x, y, 1, 1));
            }
        }
    }
}

#pragma mark - Logic
- (void)redrawView
{
    double begin = CFAbsoluteTimeGetCurrent();
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self calculatAbsolutePoint];
        [self calculatePixelColors];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(heatMapFinishedLoading)]) {
                [self.delegate heatMapFinishedLoading];
            }
            [self setNeedsDisplay];
            GBLog(@"热力图持续时间:%f", CFAbsoluteTimeGetCurrent()-begin);
        });
    });
}

#pragma mark - Pixel Calculator

- (void)calculatePixelColors
{
    CGFloat maxDensity = [self maxDensityCalc];
    IBMatrix *matrix = [[IBMatrix alloc]initWithColumns:CGRectGetWidth(self.bounds) lines:CGRectGetHeight(self.bounds)];
    for (NSInteger x = self.leftPoint.x; x < self.rightPoint.x; x ++) {
        for (NSInteger y = self.topPoint.y; y < self.bottomPoint.y; y ++) {
            CGFloat density = [[self.densityMatrix objectForColumn:x line:y]doubleValue];
            UIColor *color = [self colorForDensity:density andMaxDensity:maxDensity];
            [matrix setObject:color column:x line:y];
        }
    }
    self.colorMatrix = matrix;
}

#pragma mark - Helpers

- (CGFloat)maxDensityCalc
{
    IBMatrix *densityMatrix = [[IBMatrix alloc]initWithColumns:CGRectGetWidth(self.bounds) lines:CGRectGetHeight(self.bounds)];
    CGFloat maxDensity = 0;
    __block CGFloat firstMaxDensity = 0;
    __block CGFloat secondMaxDensity = 0;
    double begin = CFAbsoluteTimeGetCurrent();
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSInteger maxY = floor((self.bottomPoint.y-self.topPoint.y) / 2.0f);
        for(NSInteger y = self.topPoint.y; y < maxY; y++) {
            if (self.needStop) {
                break;
            }
            for(NSInteger x = self.leftPoint.x; x < self.rightPoint.x; x++) {
                CGPoint point = CGPointMake(x, y);
                CGFloat density = [self densityForPoint:point];
                [densityMatrix setObject:@(density) column:x line:y];
                if (density > firstMaxDensity)
                    firstMaxDensity = density;
            }
        }
        dispatch_semaphore_signal(sem);
    });
    dispatch_async(queue, ^{
        NSInteger minY = floor((self.bottomPoint.y-self.topPoint.y) / 2.0f);
        for(NSInteger y = minY; y < self.bottomPoint.y; y++) {
            if (self.needStop) {
                break;
            }
            for(NSInteger x = self.leftPoint.x; x < self.rightPoint.x; x++) {
                CGPoint point = CGPointMake(x, y);
                CGFloat density = [self densityForPoint:point];
                [densityMatrix setObject:@(density) column:x line:y];
                if (density > secondMaxDensity)
                    secondMaxDensity = density;
            }
        }
        dispatch_semaphore_signal(sem);
    });
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    GBLog(@"权重计算时间:%f", CFAbsoluteTimeGetCurrent()-begin);
    
    maxDensity = firstMaxDensity>secondMaxDensity?firstMaxDensity:secondMaxDensity;
    self.densityMatrix = densityMatrix;
    return maxDensity;
}

- (CGFloat)densityForPoint:(CGPoint)point
{
    if ((point.x<self.leftPoint.x) ||
        (point.x>self.rightPoint.x) ||
        (point.y<self.topPoint.y) ||
        (point.y>self.bottomPoint.y)) {
        return 0;
    }
    
    CGFloat density = 0;
    for (PointInfo *info in self.coordinatePoints) {
        if (fabs(info.x-point.x)>self.pointRadius ||
            fabs(info.y-point.y)>self.pointRadius) {
            continue;
        }
        
        CGFloat distanceBetweenPointAndCircle = fabsf(hypotf(point.x - info.x, point.y - info.y));
        if(distanceBetweenPointAndCircle <= self.pointRadius) {
            density += ((self.pointRadius - distanceBetweenPointAndCircle) / self.pointRadius)*info.count;
        }
    }
    
    return density;
}

- (UIColor *)colorForDensity:(CGFloat)density andMaxDensity:(CGFloat)maxDensity
{
    
    if(density < 1)
    {
        if (density<=0) {
            return [UIColor clearColor];
        }
        return [self colorLerpFrom:[UIColor clearColor] to:self.colors[0] withDuration:density];
    }
    
    CGFloat densityPercentage = density / maxDensity;
    CGFloat colorArrayPercentage = (self.colors.count - 1) * densityPercentage;
    
    NSInteger firstColorIndex = floor(colorArrayPercentage);
    NSInteger secondColorIndex = ceil(colorArrayPercentage);
    
    CGFloat colorRatio = colorArrayPercentage - firstColorIndex;
    
    return [self colorLerpFrom:self.colors[firstColorIndex] to:self.colors[secondColorIndex] withDuration:colorRatio];
}

- (UIColor *)colorLerpFrom:(UIColor *)start
                        to:(UIColor *)end
              withDuration:(float)t
{
    if(t < 0.0f) t = 0.0f;
    if(t > 1.0f) t = 1.0f;
    
    const CGFloat *startComponent = CGColorGetComponents(start.CGColor);
    const CGFloat *endComponent = CGColorGetComponents(end.CGColor);
    
    float startAlpha = CGColorGetAlpha(start.CGColor);
    float endAlpha = CGColorGetAlpha(end.CGColor);
    
    float r = startComponent[0] + (endComponent[0] - startComponent[0]) * t;
    float g = startComponent[1] + (endComponent[1] - startComponent[1]) * t;
    float b = startComponent[2] + (endComponent[2] - startComponent[2]) * t;
    float a = startAlpha + (endAlpha - startAlpha) * t;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

#pragma mark - Private
//计算点的屏幕坐标
- (void)calculatAbsolutePoint {
    
    NSMutableDictionary<NSString *, NSNumber *> *distributedDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    for (NSValue *value in self.points) {
        CGPoint userPoint = value.CGPointValue;
        CGPoint absoluteUserPoint = [self absolutePointForRelativePoint:userPoint];
        if (absoluteUserPoint.y<self.topPoint.y) {
            self.topPoint = absoluteUserPoint;
        }
        if (absoluteUserPoint.x<self.leftPoint.x) {
            self.leftPoint = absoluteUserPoint;
        }
        if (absoluteUserPoint.y>self.bottomPoint.y) {
            self.bottomPoint = absoluteUserPoint;
        }
        if (absoluteUserPoint.x>self.rightPoint.x) {
            self.rightPoint = absoluteUserPoint;
        }
        
        //分布状况
        NSString *key = [NSString stringWithFormat:@"%td-%td", (NSInteger)absoluteUserPoint.x, (NSInteger)absoluteUserPoint.y];
        NSNumber *count = [distributedDic objectForKey:key];
        if (!count) {
            count = @(0);
        }
        [distributedDic setObject:@(count.integerValue+1) forKey:key];
    }
    [self resetFourPointWithRadius];
    
    self.coordinatePoints = [NSMutableArray arrayWithCapacity:1];
    for (NSString *key in distributedDic.allKeys) {
        NSInteger count = [distributedDic objectForKey:key].integerValue;
        if (count>0) {
            NSArray *keys = [key componentsSeparatedByString:@"-"];
            PointInfo *info = [[PointInfo alloc] init];
            info.x = [keys[0] integerValue];
            info.y = [keys[1] integerValue];
            info.count = count;
            [self.coordinatePoints addObject:info];
        }
    }
}

- (CGPoint)absolutePointForRelativePoint:(CGPoint)point
{
    return CGPointMake((NSInteger)(point.x * CGRectGetWidth(self.bounds)), (NSInteger)(point.y * CGRectGetHeight(self.bounds)));
}

- (void)resetFourPointWithRadius {
    
    CGFloat minX = 0;
    CGFloat maxX = CGRectGetWidth(self.bounds);
    CGFloat minY= 0;
    CGFloat maxY = CGRectGetHeight(self.bounds);
    self.topPoint = CGPointMake(MAX(self.topPoint.x-self.pointRadius, minX), MAX(self.topPoint.y-self.pointRadius, minY));
    self.leftPoint = CGPointMake(MAX(self.leftPoint.x-self.pointRadius, minX), MAX(self.leftPoint.y-self.pointRadius, minY));
    self.bottomPoint = CGPointMake(MIN(self.bottomPoint.x+self.pointRadius, maxX), MIN(self.bottomPoint.y+self.pointRadius, maxY));
    self.rightPoint = CGPointMake(MIN(self.rightPoint.x+self.pointRadius, maxX), MIN(self.rightPoint.y+self.pointRadius, maxY));
}

@end
