//
//  GoodsRequest.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/4.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "GoodsRequest.h"

@implementation GoodsRequest

+ (void)getGoodInfoWithGoodID:(NSInteger)goodId handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"detail",
                                 @"do":@"goods",
                                 @"goodsId":@(goodId),
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[GoodsResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            GoodsResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

@end
