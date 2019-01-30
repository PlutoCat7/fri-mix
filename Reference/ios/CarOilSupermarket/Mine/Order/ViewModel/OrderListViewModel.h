//
//  OrderListModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/16.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderRecordRequest.h"

@interface OrderListViewModel : NSObject

@property (nonatomic, strong) NSArray<OrderRecordInfo *> *recordlist;
@property (nonatomic, assign) OrderType type;

- (instancetype)initWithType:(OrderType)type;

- (void)getFirstPageDataWithHandler:(void(^)(NSError *error))handler;
- (void)getNextPageDataWithHandler:(void(^)(NSError *error))handler;

- (BOOL)isLoadEnd;

@end
