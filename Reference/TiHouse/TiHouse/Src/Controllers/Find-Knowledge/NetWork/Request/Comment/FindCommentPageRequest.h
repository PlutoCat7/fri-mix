//
//  FindCommentPageRequest.h
//  TiHouse
//
//  Created by weilai on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BasePageNetworkRequest.h"
#import "CommentPageRequest.h"
#import "FindComListResponse.h"

@interface FindCommentPageRequest : BasePageNetworkRequest

@property (assign, nonatomic) NSInteger assemId;
@property (assign, nonatomic) CommentRankType rankType;

@end
