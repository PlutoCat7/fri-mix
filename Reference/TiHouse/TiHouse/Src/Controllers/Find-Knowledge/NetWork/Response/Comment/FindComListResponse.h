//
//  FindComListResponse.h
//  TiHouse
//
//  Created by weilai on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "GBResponsePageInfo.h"
#import "FindAssemarcCommentInfo.h"

@interface FindComListResponse : GBResponsePageInfo

@property (nonatomic, strong) NSArray<FindAssemarcCommentInfo *> *data;

@end
