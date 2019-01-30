//
//  GBResponsePageInfo.h
//  GB_Football
//
//  Created by weilai on 16/7/7.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface PageInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger pi;
@property (nonatomic, assign) NSInteger ps;
@property (nonatomic, assign) NSInteger pn;
@property (nonatomic, assign) NSInteger rn;

@end

///---------------------------------
///@name 分页解析基类
///---------------------------------
@interface GBResponsePageInfo : GBResponseInfo

@property (nonatomic, strong) PageInfo *page;
//分页数据集合
@property (nonatomic, strong) NSArray *items;

- (NSArray *)onePageData;

@end
