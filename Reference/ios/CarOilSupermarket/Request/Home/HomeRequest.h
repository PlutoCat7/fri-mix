//
//  HomeRequest.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/8.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "HomeResponseInfo.h"
#import "ArticleResponse.h"

@interface HomeRequest : BaseNetworkRequest

+ (void)getHomeDataWithUserId:(NSString *)userId handler:(RequestCompleteHandler)handler;

+ (void)getArticleDataWithHandler:(RequestCompleteHandler)handler;

@end
