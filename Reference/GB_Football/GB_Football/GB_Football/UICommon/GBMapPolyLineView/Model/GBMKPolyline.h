//
//  GBMKPolyline.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>

@interface GBMKPolyline : MAMultiPolyline

/**
 *  轨迹颜色
 */
@property(nonatomic,strong) NSArray<UIColor *> *colors;

@end
