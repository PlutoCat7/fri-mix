//
//  MatchRecordResponseInfo.h
//  GB_Team
//
//  Created by weilai on 16/9/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponsePageInfo.h"

@interface MatchRecordInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, assign) NSInteger matchTime;
@property (nonatomic, copy) NSString *matchName;
@property (nonatomic, copy) NSString *courtAddress;
@property (nonatomic, copy) NSString *courtName;

@end

@interface MatchRecordResponseInfo : GBResponsePageInfo

@property (nonatomic, strong) NSArray<MatchRecordInfo *> *data;

@end
