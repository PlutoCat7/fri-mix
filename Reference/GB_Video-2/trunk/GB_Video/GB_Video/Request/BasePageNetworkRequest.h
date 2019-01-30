//
//  BasePageNetworkRequest.h
//  GB_Football
//
//  Created by wsw on 16/7/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "GBResponsePageInfo.h"

@protocol BasePageNetworkRequestDataSource <NSObject>

@required
- (Class)responseClass;

- (NSString *)requestAction;

@optional
- (NSDictionary *)parameters;

@end

///每个page请求都需要new一个Request
@interface BasePageNetworkRequest : BaseNetworkRequest <BasePageNetworkRequestDataSource>

@property (nonatomic, strong, readonly) __kindof GBResponsePageInfo *responseInfo;

/**
 * @brief 获取第一页列表
 *
 */
- (void)reloadPageWithHandle:(RequestCompleteHandler)handler;

/**
 * @brief 获取下一页列表
 *
 */
- (void)loadNextPageWithHandle:(RequestCompleteHandler)handler;

/**
 * @brief 是否已经全部加载完成
 *
 * @return BOOL
 */- (BOOL)isLoadEnd;

@end
