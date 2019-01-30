//
//  MyVouchersViewModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/15.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyVouchersCellModel.h"
#import "MyVouchersPageRequest.h"

@interface MyVouchersViewModel : NSObject

//订单界面进入相关属性
@property (nonatomic, strong) NSArray<MyVouchersInfo *> *selectedVouchersInfos;
@property (nonatomic, assign) CGFloat orderPrice;

@property (nonatomic, strong) NSArray<MyVouchersCellModel *> *cellModels;

- (void)getFirstPageDataWithHandler:(void(^)(NSError *error))handler;
- (void)getNextPageDataWithHandler:(void(^)(NSError *error))handler;

- (BOOL)isLoadEnd;

- (void)selectVouchersWithIndexPath:(NSIndexPath *)indexPath;

@end
