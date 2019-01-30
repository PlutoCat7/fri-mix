//
//  PayManager.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/15.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OrderPayCallBackInfo;

@interface PayManager : NSObject

+ (PayManager *)sharedPayManager;

- (void)payWithOrderPayCallBackInfo:(OrderPayCallBackInfo *)info hanlder:(void(^)(NSString *errorMsg))hanlder;

@end
