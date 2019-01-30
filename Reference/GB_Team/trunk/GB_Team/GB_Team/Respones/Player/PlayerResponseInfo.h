//
//  PlayerResponseInfo.h
//  GB_Team
//
//  Created by weilai on 16/9/20.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponsePageInfo.h"

@interface PlayerInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger playerId;
@property (nonatomic, assign) NSInteger coachId;   //所属教练id
@property (nonatomic, copy) NSString *playerName;
@property (nonatomic, assign) SexType sexType;
@property (nonatomic, assign) NSInteger playerBirthday;
@property (nonatomic, assign) NSInteger playerNum;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString  *position;
@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, copy  ) NSString *imageUrl;

//本地头像
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) NSInteger playerAge;

@end


@interface PlayerResponseInfo : GBResponsePageInfo

@property (nonatomic, strong) NSArray<PlayerInfo *> *data;

@end
