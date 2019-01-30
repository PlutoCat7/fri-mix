//
//  ChartDataModel.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartDataModel : NSObject

@property (nonatomic, strong) UIColor *valueColor;  //图表颜色
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) UIColor *valueTextColor; //数值颜色
@property (nonatomic, strong) UIFont *valueFont;

//X轴
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) UIFont *nameFont;
@property (nonatomic, strong) UIColor *nameColor;

//是不是我的记录
@property (nonatomic, assign) BOOL isMine;

@end
