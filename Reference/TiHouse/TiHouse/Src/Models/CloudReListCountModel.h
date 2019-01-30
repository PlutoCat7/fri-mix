//
//  CloudReListCountModel.h
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

//图片、视频、收藏、最近上传、月份
@interface CloudReListCountModel : NSObject

@property (copy, nonatomic) NSString * urllastfile;//最新文件地址
@property (copy, nonatomic) NSString * month;//时间 格式yyyy-MM
@property (assign, nonatomic) int typefile;//文件类型，1图片2视频3收藏4最近上传
@property (assign, nonatomic) int count;//文件数量（当typefile=1、2、3、4 时 字段有值）
@property (assign, nonatomic) int countphoto;//图片数量
@property (assign, nonatomic) int countvideo;//视频数量
@property (assign, nonatomic) BOOL isMonthFile;//是否是月份过来的数据

@property (copy, nonatomic) NSString * year;
@property (copy, nonatomic) NSString * MM;//月份

@end
