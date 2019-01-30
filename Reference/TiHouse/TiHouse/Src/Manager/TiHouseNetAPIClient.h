//
//  TiHouseNetAPIClient.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/29.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef enum {
    Get = 0,
    Post,
    Put,
    Delete
} NetworkMethod;

@interface TiHouseNetAPIClient : AFHTTPSessionManager

+(TiHouseNetAPIClient *)sharedJsonClient;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetworkMethod)method
                  autoShowError:(BOOL)autoShowError
                       andBlock:(void (^)(id data, NSError *error))block;
+ (id)changeJsonClient;

- (void)uploadImage:(UIImage *)image path:(NSString *)path name:(NSString *)name
       successBlock:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
       failureBlock:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure
      progerssBlock:(void (^)(CGFloat progressValue))progress;

- (void)uploadVideoData:(NSData *)data successBlock:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
           failureBlock:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure
          progerssBlock:(void (^)(CGFloat progressValue))progress;

@end
