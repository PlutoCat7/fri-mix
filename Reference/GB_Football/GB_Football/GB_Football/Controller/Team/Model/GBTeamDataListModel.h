//
//  GBTeamDataListModel.h
//  GB_Football
//
//  Created by 王时温 on 2017/8/17.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TeamDataModelType) {
    TeamDataModelType_Match = 1,
    TeamDataModelType_Team,
};

@interface GBTeamDataDetailModel : NSObject

@property (nonatomic, assign) NSInteger playerId;
@property (nonatomic, copy) NSString *name;  //名字
@property (nonatomic, copy) NSString *valueString;      //显示的数值
@property (nonatomic, copy) NSString *unit;  //单位

@end

@interface GBTeamDataListModel : NSObject

@property (nonatomic, assign) TeamDataModelType modelType;
@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSArray<GBTeamDataDetailModel *> *players;

@end
