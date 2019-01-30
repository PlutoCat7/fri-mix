//
//  BaseNetworkRequest.m
//  GB_Football
//
//  Created by wsw on 16/7/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "TiHouseNetAPIClient.h"

#import "GBResponseInfo.h"
#import "GBRespDefine.h"

@implementation BaseNetworkRequest

+ (void)POST:(NSString *)urlString parameters:(id)parameters responseClass:(Class)responseClass handler:(RequestCompleteHandler)handler {
    
    
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:urlString withParams:parameters withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if (!error) {
            [[self class] analyseWithData:data responseClass:responseClass handler:handler];
        }else {
            BLOCK_EXEC(handler, nil, error);
        }
    }];
}

#pragma mark - Private

+ (void)analyseWithData:(id)data responseClass:(Class)responseClass handler:(RequestCompleteHandler)handler {
    
    NSParameterAssert([responseClass isSubclassOfClass:[GBResponseInfo class]]);
    
    //json数据解析，检验请求是否正确
    [responseClass analyseWithData:data complete:^(__kindof YAHDataResponseInfo *result, NSError *error) {
        
        BLOCK_EXEC(handler, result, error);
    }];
}


@end
