//
//  CommentRequest.h
//  TiHouse
//
//  Created by weilai on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "GBResponseInfo.h"

@interface CommentRequest : BaseNetworkRequest

+ (void)addKnowledgeComment:(NSInteger)knowledgeId commId:(NSInteger)commId commuid:(NSInteger)commuid content:(NSString *)content handler:(RequestCompleteHandler)handler;

+ (void)addZanComment:(NSInteger)commId handler:(RequestCompleteHandler)handler;
+ (void)removeZanComment:(NSInteger)commId handler:(RequestCompleteHandler)handler;

+ (void)addAssemarcComment:(NSInteger)assemarcId commId:(NSInteger)commId commuid:(NSInteger)commuid content:(NSString *)content handler:(RequestCompleteHandler)handler;

+ (void)addAssemarcZanComment:(NSInteger)commId handler:(RequestCompleteHandler)handler;
+ (void)removeAssemarcZanComment:(NSInteger)commId handler:(RequestCompleteHandler)handler;

@end
