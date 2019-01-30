//
//  CommentPageRequest.h
//  TiHouse
//
//  Created by weilai on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BasePageNetworkRequest.h"
#import "CommentListResponse.h"

typedef enum {
    CommentRankType_A = 1,
    CommentRankType_D = 2,
} CommentRankType;

@interface CommentPageRequest : BasePageNetworkRequest

@property (assign, nonatomic) NSInteger knowledgeId;
@property (assign, nonatomic) CommentRankType rankType;

@end
