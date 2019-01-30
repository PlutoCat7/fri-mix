//
//  ShopRequest.m
//  GB_Football
//
//  Created by 王时温 on 2016/12/5.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "ShopRequest.h"

@implementation ShopRequest

+ (void)getShopInfoWithHandler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"mall_info_controller/dogetinfo";
    
    [self POST:urlString parameters:nil responseClass:[ShopResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            ShopResponseInfo *info = (ShopResponseInfo *)result;
            [info saveCache];
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

@end
