//
//  MPPlot.h
//  MPPlot
//
//  Created by Alex Manzella on 22/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Frame.h"


#define PADDING 18

#define ANIMATIONDURATION 1.5

typedef NS_ENUM(NSUInteger, MPPlotType) {
    MPPlotTypeUnknown=0,
    MPPlotTypeGraph=1,
    MPPlotTypeBars=2,
    MPPlotTypeCake=3,
};

typedef CGFloat(^GraphPointsAlgorithm)(CGFloat x);


struct _MPValuesRange {
    CGFloat max;
    CGFloat min;
};

typedef struct _MPValuesRange MPGraphValuesRange;

NS_INLINE MPGraphValuesRange MPMakeGraphValuesRange(CGFloat min, CGFloat max) {
    MPGraphValuesRange r;
    r.min = min;
    r.max = max;
    return r;
}

NS_INLINE BOOL MPValuesRangeNULL(MPGraphValuesRange r) {
    return r.min==CGFLOAT_MIN && r.max==CGFLOAT_MAX;
}

NS_INLINE MPGraphValuesRange MPGetBiggestRange(MPGraphValuesRange r1,MPGraphValuesRange r2) {
    
    MPGraphValuesRange r;
    
    r.min=(r1.min<r2.min ? r1.min : r2.min);
    r.max=(r1.max>r2.max ? r1.max : r2.max);
    
    return r;
}

@protocol MPDetailView <NSObject>

- (void)setText:(NSString *)text;

@end

@interface MPPlot : UIView{
    
    MPPlotType plotType;
    
    UIColor *_graphColor;
    
    CGFloat _animationDuration;
    
    NSArray *points;
    
    NSMutableArray *buttons;
    
    NSInteger currentTag;
    
    GraphPointsAlgorithm _customAlgorithm;
    
    NSUInteger _numberOfPoints;
}



// Abstract Class

+ (id)plotWithType:(MPPlotType)type frame:(CGRect)frame;
+ (MPGraphValuesRange)rangeForValues:(NSArray *)values;


@property (nonatomic,copy) NSArray *values;
@property (nonatomic,copy) NSArray *graphColors;
@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,assign) BOOL waitToUpdate;
@property (nonatomic,assign) CGFloat animationDuration;
@property (nonatomic,assign) MPGraphValuesRange valueRanges;

- (void)animate;

- (void)setAlgorithm:(GraphPointsAlgorithm)customAlgorithm numberOfPoints:(NSUInteger)numberOfPoints;


@end



@interface MPButton : UIButton

+ (id)buttonWithType:(UIButtonType)buttonType tappableAreaOffset:(UIOffset)tappableAreaOffset;

@end


