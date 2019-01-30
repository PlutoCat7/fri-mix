//
//  CatalogRequest.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/15.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "CatalogRequest.h"

@implementation CatalogRequest

+ (void)getCatalogDataWithUserId:(NSString *)userId handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"cats",
                                 @"do":@"goods",
                                 @"mid":userId};
    
    [self POSTWithParameters:parameters responseClass:[CatalogResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            CatalogResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];

}

@end
