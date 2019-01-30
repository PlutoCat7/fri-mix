//
//  VideoCommentListRequest.h
//  GB_Video
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "BasePageNetworkRequest.h"
#import "VideoCommentListResponse.h"

@interface VideoCommentListRequest : BasePageNetworkRequest

@property (nonatomic, assign) NSInteger videoId;

@end
