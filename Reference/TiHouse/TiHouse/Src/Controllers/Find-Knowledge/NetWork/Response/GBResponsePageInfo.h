//
//  GBResponsePageInfo.h
//  GB_Football
//
//  Created by weilai on 16/7/7.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

///---------------------------------
///@name 分页解析基类
///---------------------------------
@interface GBResponsePageInfo : GBResponseInfo

@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger limit;
//分页数据集合
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, assign) NSInteger allCount; //总个数

@property (nonatomic, assign) BOOL isLoadEnd;

- (NSArray *)onePageData;

@end
