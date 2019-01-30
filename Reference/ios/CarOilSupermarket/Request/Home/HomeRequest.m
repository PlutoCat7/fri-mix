//
//  HomeRequest.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/8.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "HomeRequest.h"

@implementation HomeRequest

+ (void)getHomeDataWithUserId:(NSString *)userId handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"home",
                                 @"do":@"pub",
                                 @"mid":userId};
    
    [self POSTWithParameters:parameters responseClass:[HomeResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            HomeResponseInfo *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)getArticleDataWithHandler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"list",
                                 @"do":@"article"};
    
    [self POSTWithParameters:parameters responseClass:[ArticleResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            ArticleResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

@end
