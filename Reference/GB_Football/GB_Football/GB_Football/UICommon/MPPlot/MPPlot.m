//
//  MPPlot.m
//  MPPlot
//
//  Created by Alex Manzella on 22/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPPlot.h"
#import "MPGraphView.h"
#import "MPBarsGraphView.h"

@implementation MPPlot

+ (MPGraphValuesRange)rangeForValues:(NSArray *)values{
    
    CGFloat min,max;
    
    min=max=[[values firstObject] floatValue];
    
    
    for (NSInteger i=0; i<values.count; i++) {
        
        CGFloat val=[[values objectAtIndex:i] floatValue];
        
        if (val>max) {
            max=val;
        }
        
        if (val<min) {
            min=val;
        }
        
    }
    
    
    
    return MPMakeGraphValuesRange(min, max);
}



- (id)init
{
    self = [super init];
    if (self) {
        self.valueRanges=MPMakeGraphValuesRange(CGFLOAT_MIN, CGFLOAT_MAX);
        NSAssert(![self isMemberOfClass:[MPPlot class]], @"You shouldn't init MPPlot directly, use the class method plotWithType:frame:");
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.valueRanges=MPMakeGraphValuesRange(CGFLOAT_MIN, CGFLOAT_MAX);
        NSAssert(![self isMemberOfClass:[MPPlot class]], @"You shouldn't init MPPlot directly, use the class method plotWithType:frame:");
    }
    return self;
}


+ (id)plotWithType:(MPPlotType)type frame:(CGRect)frame{
 
    
    switch (type) {
        case MPPlotTypeGraph:
            return [[MPGraphView alloc] initWithFrame:frame];
            break;

        case MPPlotTypeBars:
            return [[MPBarsGraphView alloc] initWithFrame:frame];
            break;
            
        default:
            break;
    }
    
    
    return nil;
}




- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
}







- (NSMutableArray *)pointsForArray:(NSArray *)values{
    
    CGFloat min,max;
    
    
    if (MPValuesRangeNULL(self.valueRanges)) {
        _valueRanges=[MPPlot rangeForValues:values];
        min=_valueRanges.min;
        max=_valueRanges.max;
    }else{
        max=_valueRanges.max;
        min=_valueRanges.min;
    }
    
    
    NSMutableArray *pointsArray=[[NSMutableArray alloc] init];
    
    if(max!=min){
        for (NSString *p in values) {
            
            CGFloat val=[p floatValue];
            
            val=((val-min)/(max-min));
            
            [pointsArray addObject:@(val)];
        }
        
    }else [pointsArray addObject:@(1)];
    
    return pointsArray;
}



#pragma mark setters



- (void)setValues:(NSArray *)values{
    
    if (values) {
        
        _values=[values copy];
        
        points=[self pointsForArray:_values];
        
        
        [self setNeedsDisplay];
    }
    
}

- (void)setValueRanges:(MPGraphValuesRange)valueRanges{
    
    _valueRanges=valueRanges;
    
    if (!MPValuesRangeNULL(valueRanges) && self.values) {
        points=[self pointsForArray:self.values];
    }
}


- (void)setAlgorithm:(GraphPointsAlgorithm)customAlgorithm numberOfPoints:(NSUInteger)numberOfPoints{
    
    _numberOfPoints=numberOfPoints;
    _customAlgorithm=customAlgorithm;
    
    NSMutableArray* values=[[NSMutableArray alloc] init];
    
    for (NSUInteger i=0; i<numberOfPoints; i++) {
        [values addObject:@(customAlgorithm(i))];
    }
    
    self.values=values;
    
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsDisplay];
}


#pragma mark Getters


- (UIColor *)graphColor{
    
    return _graphColor ? _graphColor : [UIColor blueColor];
    
}



- (CGFloat)animationDuration{
    return _animationDuration>0.0 ? _animationDuration : ANIMATIONDURATION;
}



- (void)animate{
    
    self.waitToUpdate=NO;
    
    [self setNeedsDisplay];
}



#pragma mark Actions



@end




@implementation MPButton

UIOffset tappableAreaOffset;

+ (id)buttonWithType:(UIButtonType)buttonType tappableAreaOffset:(UIOffset)tappableAreaOffset_{
    
    tappableAreaOffset=tappableAreaOffset_;
    
    return [super buttonWithType:buttonType];
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    return CGRectContainsPoint(CGRectInset(self.bounds,  -tappableAreaOffset.horizontal, -tappableAreaOffset.vertical), point);
    
}

@end
