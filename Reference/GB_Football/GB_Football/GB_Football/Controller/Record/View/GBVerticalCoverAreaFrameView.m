//
//  GBVerticalCoverAreaFrameView.m
//  GB_Football
//
//  Created by yahua on 2017/8/29.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBVerticalCoverAreaFrameView.h"

@interface GBVerticalCoverAreaFrameView ()

@property (nonatomic, assign) VerticalCoverAreaFrameViewType type;
@property (nonatomic, strong) NSArray<NSString *> *datas;
@property (nonatomic, strong) NSArray<NSString *> *times;

@property (nonatomic, assign) BOOL showTime;

@end

@implementation GBVerticalCoverAreaFrameView

- (void)drawRect:(CGRect)rect {
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHex:0xbee44b].CGColor);  //线的颜色
    CGContextBeginPath(context);
    
    //画边框
    CGContextSetLineWidth(context, 2);  //线宽* 边框会被截取一半
    CGContextMoveToPoint(context, 0, 0);  //起点坐标
    CGContextAddLineToPoint(context, width, 0);
    CGContextAddLineToPoint(context, width, height);
    CGContextAddLineToPoint(context, 0, height);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, 1);  //线宽
    CGContextMoveToPoint(context, 0, height/3);  //起点坐标
    CGContextAddLineToPoint(context, width, height/3);
    CGContextMoveToPoint(context, 0, height*2/3);
    CGContextAddLineToPoint(context, width, height*2/3);
    
    
    NSMutableArray<NSValue *> *points = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray<NSValue *> *times = [NSMutableArray arrayWithCapacity:1];
    CGFloat fontSize = 22.0f;
    CGFloat timeFontSize = 11.f;
    CGFloat timeBgHeight = 18.f;
    switch (_type) {
        case VerticalCoverAreaFrameViewType_Three:
        {
            CGFloat x = 0;
            CGFloat y = 0;
            CGFloat itemWidth = width;
            CGFloat itemHeight = height/3;
            for (NSInteger i=0; i<3; i++) {
                [points addObject:[NSValue valueWithCGRect:CGRectMake(x, y, itemWidth, itemHeight)]];
                [times addObject:[NSValue valueWithCGRect:CGRectMake(x, y + itemHeight - timeBgHeight, itemWidth, timeBgHeight)]];
                y += itemHeight;
            }
        }
            break;
        case VerticalCoverAreaFrameViewType_Six:
        {
            fontSize = 18.0f;
            CGContextMoveToPoint(context, width/2, 0);  //起点坐标
            CGContextAddLineToPoint(context, width/2, height);
            
            CGFloat x = 0;
            CGFloat y = 0;
            CGFloat itemWidth = width/2;
            CGFloat itemHeight = height/3;
            for (NSInteger i=0; i<3; i++) {
                for (NSInteger j=0; j<2; j++) {
                    [points addObject:[NSValue valueWithCGRect:CGRectMake(x, y, itemWidth, itemHeight)]];
                    [times addObject:[NSValue valueWithCGRect:CGRectMake(x, y + itemHeight - timeBgHeight, itemWidth, timeBgHeight)]];
                    x += itemWidth;
                }
                x = 0;
                y += itemHeight;
            }

        }
            break;
        case VerticalCoverAreaFrameViewType_Nine:
        {
            fontSize = 15.0f;
            timeFontSize = 10.f;
            timeBgHeight = 16.f;
            CGContextMoveToPoint(context, width/3, 0);  //起点坐标
            CGContextAddLineToPoint(context, width/3, height);
            CGContextMoveToPoint(context, width*2/3, 0);  //起点坐标
            CGContextAddLineToPoint(context, width*2/3, height);
            
            CGFloat x = 0;
            CGFloat y = 0;
            CGFloat itemWidth = width/3;
            CGFloat itemHeight = height/3;
            for (NSInteger i=0; i<3; i++) {
                for (NSInteger j=0; j<3; j++) {
                    [points addObject:[NSValue valueWithCGRect:CGRectMake(x, y, itemWidth, itemHeight)]];
                    [times addObject:[NSValue valueWithCGRect:CGRectMake(x, y + itemHeight - timeBgHeight, itemWidth, timeBgHeight)]];
                    x += itemWidth;
                }
                x = 0;
                y += itemHeight;
            }
        }
            break;
            
        default:
            break;
    }
    CGContextStrokePath(context);
    
    if (self.datas.count == points.count) {
        for (NSInteger index=0; index<points.count; index++) {
            NSString *text = _datas[index];
            CGRect rect = points[index].CGRectValue;
            
            CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"BEBAS" size:fontSize*kAppScale]}];
            CGFloat x_pos = (rect.size.width - size.width) / 2;
            CGFloat y_pos = (rect.size.height - size.height) /2;
            [text drawAtPoint:CGPointMake(rect.origin.x + x_pos, rect.origin.y + y_pos) withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                                         NSFontAttributeName:[UIFont fontWithName:@"BEBAS" size:fontSize*kAppScale]}];
            
        }
    }
    
    if (times.count > 0 && self.showTime) {
        // 画时间背景
        CGContextClosePath(context);
        CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);  //线的颜色
        CGContextSetFillColorWithColor(context, [UIColor colorWithHex:0x709304 andAlpha:0.5f].CGColor);  //线的颜色
        for (NSInteger index=0; index<times.count; index++) {
            CGContextAddRect(context, times[index].CGRectValue);
        }
        CGContextFillPath(context);
        
        for (NSInteger index=0; index<times.count; index++) {
            NSString *text = index < _times.count ? _times[index] : @"0'00\"";
            
            CGRect timeRect = times[index].CGRectValue;
            CGSize timeSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"BEBAS" size:timeFontSize*kAppScale]}];
            CGFloat t_x_pos = (timeRect.size.width - timeSize.width) / 2;
            CGFloat t_y_pos = (timeRect.size.height - timeSize.height) /2;
            [text drawAtPoint:CGPointMake(timeRect.origin.x + t_x_pos, timeRect.origin.y + t_y_pos) withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                                                     NSFontAttributeName:[UIFont systemFontOfSize:timeFontSize*kAppScale]}];
        }
    }
    
    CGContextClosePath(context);
    
}

- (void)refreshWithData:(NSArray<NSString *> *)datas times:(NSArray<NSString *> *)times type:(VerticalCoverAreaFrameViewType)type {
    
    _datas = datas;
    _times = times;
    _type = type;
    [self setNeedsDisplay];
}

- (void)setShowTimeRateInView:(BOOL)showTime {
    self.showTime = showTime;
    
    [self setNeedsDisplay];
}

@end
