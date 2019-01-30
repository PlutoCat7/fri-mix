//
//  CommentRequest.m
//  TiHouse
//
//  Created by weilai on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommentRequest.h"

@implementation CommentRequest

+ (void)addKnowledgeComment:(NSInteger)knowledgeId commId:(NSInteger)commId commuid:(NSInteger)commuid content:(NSString *)content handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"/api/inter/knowcomm/addByKnowid";
    
    NSDictionary *parameters = nil;
    if (commId == 0) {
        parameters =  @{@"knowid":@(knowledgeId),
                        @"knowcommcontent":content
                        };
    } else {
        parameters =  @{@"knowid":@(knowledgeId),
                        @"knowcommcontent":content,
                        @"knowcommid":@(commId),
                        @"knowcommuidon":@(commuid)
                        };
    }
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
    
}

+ (void)addZanComment:(NSInteger)commId handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"/api/inter/knowcommzan/addByKnowcommid";
    
    NSDictionary *parameters = @{@"knowcommid":@(commId)
                                 };

    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            GBResponseInfo *info = result;
            BLOCK_EXEC(handler, info, nil);
        }
    }];
}

+ (void)removeZanComment:(NSInteger)commId handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"/api/inter/knowcommzan/removeByKnowcommid";
    
    NSDictionary *parameters = @{@"knowcommid":@(commId)
                                 };
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            GBResponseInfo *info = result;
            BLOCK_EXEC(handler, info, nil);
        }
    }];
}

+ (void)addAssemarcComment:(NSInteger)assemarcId commId:(NSInteger)commId commuid:(NSInteger)commuid content:(NSString *)content handler:(RequestCompleteHandler)handler  {
    NSString *urlString = @"/api/inter/assemarccomm/add";
    
    NSDictionary *parameters = nil;
    if (commId == 0) {
        parameters =  @{@"assemarcid":@(assemarcId),
                        @"assemarccommcontent":content
                        };
    } else {
        parameters =  @{@"assemarcid":@(assemarcId),
                        @"assemarccommcontent":content,
                        @"assemarccommidon":@(commId),
                        @"assemarccommuid":@(commuid)
                        };
    }
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)addAssemarcZanComment:(NSInteger)commId handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"/api/inter/assemarccommzan/add";
    
    NSDictionary *parameters = @{@"assemarccommid":@(commId)
                                 };
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            GBResponseInfo *info = result;
            BLOCK_EXEC(handler, info, nil);
        }
    }];
}

+ (void)removeAssemarcZanComment:(NSInteger)commId handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"/api/inter/assemarccommzan/remove";
    
    NSDictionary *parameters = @{@"assemarccommid":@(commId)
                                 };
    
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
