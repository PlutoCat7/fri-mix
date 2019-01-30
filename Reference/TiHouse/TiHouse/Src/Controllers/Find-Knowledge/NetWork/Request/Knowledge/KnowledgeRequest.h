//
//  KnowledgeRequest.h
//  TiHouse
//
//  Created by weilai on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "KnowLabelResponse.h"
#import "PosterCountResponse.h"
#import "KnowModeResponseInfo.h"

@interface KnowledgeRequest : BaseNetworkRequest

+ (void)getKnowledgeDetail:(NSInteger)knowledgeId handler:(RequestCompleteHandler)handler;

+ (void)getKnowledgeLabel:(NSInteger)type handler:(RequestCompleteHandler)handler;
+ (void)getNewPosterCount:(long)lastTime handler:(RequestCompleteHandler)handler;

+ (void)addKnowledgeFavor:(NSInteger)knowledgeId handler:(RequestCompleteHandler)handler;
+ (void)removeKnowledgeFavor:(NSInteger)knowledgeId handler:(RequestCompleteHandler)handler;

@end
