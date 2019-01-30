//
//  SearchAssociationsRequest.m
//  GB_TransferMarket
//
//  Created by Pizza on 2017/2/14.
//  Copyright © 2017年 gxd. All rights reserved.
//

#import "SearchAssociationsRequest.h"

@implementation SearchAssociationsRequest

+ (void)searchAssociation:(NSString*)keyword handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"common/getKeywordList";
    NSDictionary *parameters = @{@"keyword":keyword};
    [self POST:urlString parameters:parameters responseClass:[SearchAssociationsResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            SearchAssociationsResponseInfo *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)searchHotKeyword:(RequestCompleteHandler)handler {
    NSString *urlString = @"common/getHotWordList";
    [self POST:urlString parameters:nil responseClass:[SearchAssociationsResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            SearchAssociationsResponseInfo *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

@end
