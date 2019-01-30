//
//  BalanceDetailsViewModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/21.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BalanceDetailsCellModel.h"

@interface BalanceDetailsViewModel : NSObject

@property (nonatomic, strong, readonly) NSArray<BalanceDetailsCellModel *> *cellModels;

- (void)getFirstPageDataWithHandler:(void(^)(NSError *error))handler;
- (void)getNextPageDataWithHandler:(void(^)(NSError *error))handler;

- (BOOL)isLoadEnd;

@end
