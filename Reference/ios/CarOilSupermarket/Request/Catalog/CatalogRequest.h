//
//  CatalogRequest.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/15.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "CatalogResponse.h"

@interface CatalogRequest : BaseNetworkRequest

+ (void)getCatalogDataWithUserId:(NSString *)userId handler:(RequestCompleteHandler)handler;

@end
