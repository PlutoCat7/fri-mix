//
//  BaseNetworkRequest.h
//  GB_Football
//
//  Created by wsw on 16/7/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

//网络请求回调
typedef void (^RequestCompleteHandler)(id result, NSError *error);

@interface BaseNetworkRequest : NSObject

+ (void)POST:(NSString *)urlString parameters:(id)parameters responseClass:(Class)responseClass handler:(RequestCompleteHandler)handler;

@end
