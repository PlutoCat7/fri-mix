//
//  COSPageResponseInfo.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/15.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSResponseInfo.h"

@interface COSPageResponseInfo : COSResponseInfo

@property (nonatomic, assign) NSInteger pageIndex; //第一页为1
//分页数据集合
@property (nonatomic, strong) NSArray *items;

- (NSArray *)onePageData;

- (NSInteger)totalPageCount;

@end
