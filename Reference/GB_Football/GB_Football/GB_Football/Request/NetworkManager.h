//
//  NetworkManager.h
//  GB_Football
//
//  Created by weilai on 16/7/6.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetworkManager : AFHTTPSessionManager

//Singleton to access NetworkManager
+ (NetworkManager *)sharedNetworkManager;  //网络请求
+ (NetworkManager *)uploadImageManager;
+ (NetworkManager *)downloadManager;

//获取原始host
- (NSString *)originHostWithHost:(NSString *)newHost;

@end
