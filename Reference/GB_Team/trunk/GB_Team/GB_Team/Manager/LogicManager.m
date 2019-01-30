//
//  LogicManager.m
//  GB_Football
//
//  Created by wsw on 16/8/5.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "LogicManager.h"

#define GB_PI   3.1415926535897932384626433832795

@implementation LogicManager


+ (NSString *)chinesePositonWithIndex:(NSInteger)index {

    NSArray *list = @[LS(@"门将"), LS(@"左后卫"), LS(@"中后卫"), LS(@"右后卫"), LS(@"后腰"), LS(@"左前卫"), LS(@"中前卫"), LS(@"右前卫"), LS(@"前腰"), LS(@"左边锋"), LS(@"影锋"), LS(@"右边锋"), LS(@"中锋")];
    @try {
        return list[index];
    } @catch (NSException *exception) {
        return @"";
    } @finally {
        
    }
}

+ (NSString *)englishPositonWithIndex:(NSInteger)index {
    
    NSArray *list = @[@"GK", @"LB", @"CB", @"RB", @"DMF", @"LMF", @"CMF", @"RMF", @"AMF", @"LWF", @"SS", @"RWF", @"CF"];
    @try {
        return list[index];
    } @catch (NSException *exception) {
        return @"";
    } @finally {
        
    }
}

+ (UIColor *)positonColorWithIndex:(NSInteger)index {
    
    UIColor *color = [UIColor whiteColor];
    if (index == 0) {
        color = [UIColor colorWithHex:0xffd800];
    }else if (index>0 && index<=3) {
        color = [UIColor colorWithHex:0x01c5ff];
    }else if (index>3 && index<=8) {
        color = [UIColor colorWithHex:0x00ffac];
    }else if (index>8 && index<=12) {
        color = [UIColor colorWithHex:0xd10001];
    }
    return color;
}

+ (NSArray *)transformPointArray:(NSArray *)fourPoints origPoints:(NSArray *)origPoints size:(CGSize)size tansX:(BOOL)tansX tansY:(BOOL)transY {
    
    if (fourPoints == nil || origPoints == nil) {
        return nil;
    }
    
    NSMutableArray *tFourPoints = [NSMutableArray new];
    [tFourPoints addObjectsFromArray:fourPoints];
    if (tFourPoints == nil || [tFourPoints count] != 6) {
        return nil;
    }
    
    NSMutableArray *transPoints = [NSMutableArray new];
    // 最小外切矩形的size,原始坐标系是左上角为原点
    NSValue *sizeValue = tFourPoints[4];
    CGSize tempSize = [sizeValue CGSizeValue];
    CGSize tSize = CGSizeMake(tempSize.height, tempSize.width);
    // 旋转角度,原始坐标系是左上角为原点,所以使用的角度要使用补角
    double angleValue = fabs(90 - fabs([tFourPoints[5] doubleValue]));
    double angle = fabs(angleValue)*GB_PI/180.f;
    // 如果角度为90度，需要再做一次转换，转为0度的情况,主要时角度变为0度，x，y轴对调
    if (angleValue == 90) {
        angle = fabs(90 - angleValue)*GB_PI/180.f;
        tSize = CGSizeMake(tSize.height, tSize.width);
    }
    
    // 坐标系转换的参照点
    CGPoint referPoint = CGPointMake(0, 0);
    int index = -1;
    for (int i = 0; i < 4; i++) {
        NSValue *pointValue = tFourPoints[i];
        CGPoint point = [pointValue CGPointValue];
        
        if (index == -1) {
            referPoint.x = point.x;
            referPoint.y = point.y;
            index = i;
            continue;
        }
        
        if (referPoint.y > point.y) {
            referPoint.x = point.x;
            referPoint.y = point.y;
        } else if (referPoint.y == point.y && referPoint.x > point.x) {
            referPoint.x = point.x;
            referPoint.y = point.y;
        }
    }
    
    // 转化坐标系
    for (NSValue *origPoint in origPoints) {
        CGPoint oPoint = [origPoint CGPointValue];
        
        NSValue *tPointValue = [self transformPoint:oPoint referPoint:referPoint origSize:size tranSize:tSize angle:angle tansX:tansX tansY:transY];
        if (tPointValue != nil) {
            [transPoints addObject:tPointValue];
        }
    }
    
    return transPoints;
}

+ (iBeaconVersion)beaconVersionWithVersionString:(NSString *)version {
    
    if ([version floatValue]+0.01>=2) {
        return iBeaconVersion_T_Goal_S;
    }else {
        return iBeaconVersion_T_Goal;
    }
}

#pragma mark - Private

// 转换单点坐标系
+ (NSValue *)transformPoint:(CGPoint)point referPoint:(CGPoint)referPoint origSize:(CGSize)origSize tranSize:(CGSize)tranSize angle:(double)angle tansX:(BOOL)tansX tansY:(BOOL)transY
{
    CGFloat xDist = (point.x - referPoint.x);
    CGFloat yDist = (point.y - referPoint.y);
    double distance = sqrt((xDist * xDist) + (yDist * yDist));
    double pAngle = xDist == 0 ? GB_PI/2.f : atan(yDist/xDist);
    pAngle = (pAngle < 0) ? (GB_PI - fabs(pAngle)) : pAngle;
    double tAngle = fabs(pAngle) - fabs(angle);
    // 不在范围内
    if (tAngle > GB_PI/2.f || tAngle < 0.f || yDist < 0) {
        return nil;
    }
    
    double txDist = cos(tAngle) * distance;
    double tyDist = sin(tAngle) * distance;
    if (txDist > tranSize.width || tyDist > tranSize.height) {
        return nil;
    }
    
    // 判断坐标是否反转
    CGSize tempTSize;
    double tempTXDist = 0.f;
    double tempTYDist = 0.f;
    if (tranSize.width >= tranSize.height) {
        if (origSize.width >= origSize.height) {
            // 从左到右为进攻方向的映射
            tempTSize.width = tranSize.width;
            tempTSize.height = tranSize.height;
            tempTXDist = txDist;
            tempTYDist = tyDist;
            
        } else {
            // 从下到上为进攻方向的映射
            tempTSize.width = tranSize.height;
            tempTSize.height = tranSize.width;
            tempTXDist = tranSize.height - tyDist;
            tempTYDist = txDist;
        }
        
    } else {
        if (origSize.width >= origSize.height) {
            // 从左到右为进攻方向的映射
            tempTSize.width = tranSize.height;
            tempTSize.height = tranSize.width;
            tempTXDist = tyDist;
            tempTYDist = tranSize.width - txDist;
            
        } else {
            // 从下到上为进攻方向的映射
            tempTSize.width = tranSize.width;
            tempTSize.height = tranSize.height;
            tempTXDist = txDist;
            tempTYDist = tyDist;
        }
    }
    
    double rxDist = origSize.width / tempTSize.width * tempTXDist;
    double ryDist = origSize.height / tempTSize.height * tempTYDist;
    // 绘制坐标的原点在左上角
    ryDist = origSize.height - ryDist;
    
    if (tansX) {
        rxDist = origSize.width - rxDist;
    }
    
    if (transY) {
        ryDist = origSize.height - ryDist;
    }
    
    CGPoint rPoint = CGPointMake((int)floor(rxDist), (int)floor(ryDist));
    return [NSValue valueWithCGPoint:rPoint];
}

@end
