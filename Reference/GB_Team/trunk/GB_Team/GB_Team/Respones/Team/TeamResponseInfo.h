//
//  TeamResponseInfo.h
//  GB_Team
//
//  Created by weilai on 16/9/21.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface TeamInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger teamId;
@property (nonatomic, copy) NSString *teamName;
@property (nonatomic, assign) NSInteger coachId;

@end

@interface TeamResponseInfo : GBResponseInfo

@property (nonatomic, strong) NSArray<TeamInfo *> *data;

@end
