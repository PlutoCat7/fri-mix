//
//  ShopRequest.h
//  GB_Football
//
//  Created by 王时温 on 2016/12/5.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "ShopResponseInfo.h"

@interface ShopRequest : BaseNetworkRequest

+ (void)getShopInfoWithHandler:(RequestCompleteHandler)handler;

@end
