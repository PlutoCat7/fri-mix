//
//  TeamActivityListResponeInfo.h
//  GB_Football
//
//  Created by gxd on 2017/10/13.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponsePageInfo.h"

// 球队活动类型
typedef NS_ENUM(NSUInteger, TeamActType) {
    TeamActType_End = 1,
    TeamActType_Doing = 2,
};

// 操作类型
typedef NS_ENUM(NSUInteger, TeamOptType) {
    TeamOptType_None = -1,        //不操作
    TeamOptType_InsideWeb = 1,    //内部浏览器
} ;

@interface TeamActivityInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger activityId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *imageUrl ;
@property (nonatomic, assign) TeamActType endStatus;
@property (nonatomic, assign) TeamOptType operateType;
@property (nonatomic, copy) NSString *paramUrl;

@end

@interface TeamActivityListResponeInfo : GBResponsePageInfo

@property (nonatomic, strong) NSArray<TeamActivityInfo *> *data;

@end
