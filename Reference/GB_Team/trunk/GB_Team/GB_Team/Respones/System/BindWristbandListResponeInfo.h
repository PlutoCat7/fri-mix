//
//  BindWristbandListRespone.h
//  GB_Team
//
//  Created by 王时温 on 2016/11/21.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface WristbandInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger wristId;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *mac;
@property (nonatomic, assign) NSInteger coachId;
@property (nonatomic, copy) NSString *name;

//本地属性
@property (nonatomic, assign) NSInteger battery;

@end

@interface BindWristbandListResponeInfo : GBResponseInfo

@property (nonatomic, strong) NSArray<WristbandInfo *> *data;

@end
