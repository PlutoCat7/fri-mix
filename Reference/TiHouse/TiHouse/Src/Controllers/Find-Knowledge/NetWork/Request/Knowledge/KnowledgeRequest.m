//
//  KnowledgeRequest.m
//  TiHouse
//
//  Created by weilai on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "KnowledgeRequest.h"

@implementation KnowledgeRequest

+ (void)getKnowledgeDetail:(NSInteger)knowledgeId handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"/api/inter/know/get";
    
    NSDictionary *parameters = @{@"knowid":@(knowledgeId)};
    [self POST:urlString parameters:parameters responseClass:[KnowModeResponseInfo class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            KnowModeResponseInfo *info = (KnowModeResponseInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)getKnowledgeLabel:(NSInteger)type handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"/api/inter/lableknow/list";
    
    NSDictionary *parameters = @{@"type":@(type)};
    [self POST:urlString parameters:parameters responseClass:[KnowLabelResponse class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            KnowLabelResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)getNewPosterCount:(long)lastTime handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"/api/inter/know/countNewtype1Bylasttime";
    
    NSDictionary *parameters = @{@"lasttime":@(lastTime)};
    [self POST:urlString parameters:parameters responseClass:[PosterCountResponse class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            PosterCountResponse *info = result;
            BLOCK_EXEC(handler, @(info.data), nil);
        }
    }];
}

+ (void)addKnowledgeFavor:(NSInteger)knowledgeId handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"/api/inter/knowcoll/add";
    
    NSDictionary *parameters = @{@"knowid":@(knowledgeId)};
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            GBResponseInfo *info = result;
            BLOCK_EXEC(handler, info, nil);
        }
    }];
}

+ (void)removeKnowledgeFavor:(NSInteger)knowledgeId handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"/api/inter/knowcoll/remove";
    
    NSDictionary *parameters = @{@"knowid":@(knowledgeId)};
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
