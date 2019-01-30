//
//  ColorCardRequest.m
//  TiHouse
//
//  Created by weilai on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ColorCardRequest.h"
#import "GBResponseInfo.h"

@implementation ColorCardRequest

+ (void)addColorCardFavor:(NSInteger)colorCardId handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"/api/inter/colorcardcoll/add";
    
    NSDictionary *parameters = @{@"colorcardid":@(colorCardId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            GBResponseInfo *info = result;
            BLOCK_EXEC(handler, info, nil);
        }
    }];
}

+ (void)removeColorCardFavor:(NSInteger)colorCardId handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"/api/inter/colorcardcoll/remove";
    
    NSDictionary *parameters = @{@"colorcardid":@(colorCardId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            GBResponseInfo *info = result;
            BLOCK_EXEC(handler, info, nil);
        }
    }];
}


@end
