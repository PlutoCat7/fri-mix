//
//  CircleChartView.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/20.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "CircleChartView.h"
#import "GBChartsLogic.h"
#define kStandardDistance 8000
#define kStandardLargeDistance 10000

@interface CircleChartView ()

@property (nonatomic, strong) NSArray<ChartDataModel *> *modelList;

@end

@implementation CircleChartView

- (void)drawRect:(CGRect)rect {
    
    //设置路径
    /*
     CGContextRef c:上下文
     CGFloat x ：x，y圆弧所在圆的中心点坐标
     CGFloat y ：x，y圆弧所在圆的中心点坐标
     CGFloat radius ：所在圆的半径
     CGFloat startAngle ： 圆弧的开始的角度  单位是弧度  0对应的是最右侧的点；
     CGFloat endAngle  ： 圆弧的结束角度
     int clockwise ： 顺时针（0） 或者 逆时针(1)
     */
    //1.获取上下文- 当前绘图的设备
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint center = CGPointMake(self.width/2, self.height/2);
    CGContextSetRGBStrokeColor(context,25.f/255,25.f/255,28.f/255,1.0);//画笔线的颜色
    CGContextSetLineWidth(context, 7.0*kAppScale);//线的宽度
    
    for (NSInteger index=0; index<6; index++) {
        CGContextAddArc(context, center.x, center.y, 26.5*kAppScale+14*kAppScale*index, 0, 2*M_PI, 1);
        //绘制圆弧
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    CGFloat maxDistace = [_modelList.firstObject.value floatValue]>=kStandardDistance?kStandardLargeDistance:kStandardDistance;
    for (NSInteger index=0; index<_modelList.count; index++) {
        ChartDataModel *model = _modelList[index];
        UIColor *color = model.valueColor;
        CGContextSetStrokeColorWithColor(context, [color CGColor]);//画笔线的颜色
        
        CGFloat angle = [model.value floatValue]/maxDistace*2*M_PI-M_PI_2;
        CGContextAddArc(context, center.x, center.y, 26.5*kAppScale+14*kAppScale*(5-index), -M_PI_2, angle, 0);
        //绘制圆弧
        CGContextDrawPath(context, kCGPathStroke);
    }
    
}

- (void)refreshUI:(NSArray<ChartDataModel *> *)list {
    
    _modelList = list;
    [self setNeedsLayout];
}

@end
