//
//  HomeRequest.m
//  GB_Video
//
//  Created by gxd on 2018/2/5.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "HomeRequest.h"

@implementation HomeRequest

+ (void)getHomeHeaderInfo:(RequestCompleteHandler)handler {
    NSString *urlString = @"page/getMainInfo";
    
    [self POST:urlString parameters:nil responseClass:[GBHomeResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            GBHomeResponseInfo *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

@end
