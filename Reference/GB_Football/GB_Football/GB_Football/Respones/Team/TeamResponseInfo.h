//
//  TeamResponseInfo.h
//  GB_Football
//
//  Created by gxd on 17/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"


@interface TeamInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger     teamId;
@property (nonatomic, copy  ) NSString      *teamName;
@property (nonatomic, copy  ) NSString      *teamIcon;
@property (nonatomic, assign) NSInteger     foundTime;
@property (nonatomic, assign) NSInteger     provinceId;
@property (nonatomic, assign) NSInteger     cityId;
@property (nonatomic, copy  ) NSString      *teamInstr;
@property (nonatomic, assign) NSInteger     leaderId;

//本地属性
- (BOOL)isMineTeam;

@end

@interface TeamResponseInfo : GBResponseInfo

@property (nonatomic, strong) TeamInfo *data;

@end
