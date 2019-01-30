//
//  TopicVideoListResponse.h
//  GB_Video
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBResponsePageInfo.h"
#import "VideoDetailInfo.h"

@interface TopicVideoListResponse : GBResponsePageInfo

@property (nonatomic, strong) NSArray<VideoDetailInfo *> *data;

@end
