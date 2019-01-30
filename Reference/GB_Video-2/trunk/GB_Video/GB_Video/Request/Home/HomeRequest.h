//
//  HomeRequest.h
//  GB_Video
//
//  Created by gxd on 2018/2/5.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "GBHomeResponseInfo.h"

@interface HomeRequest : BaseNetworkRequest

+ (void)getHomeHeaderInfo:(RequestCompleteHandler)handler;

@end
