//
//  TeamLogic.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/27.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TeamLogic : NSObject

+ (void)joinTeamWithTeamId:(NSInteger)teamId handler:(void(^)(NSError *error))handler;

+ (void)disposeTeamApplyWithUserId:(NSInteger)userId agree:(BOOL)agree handler:(void(^)(NSError *error))handler;

//已经被加入了球队的界面跳转
+ (void)hasAddTeamWithTeamId:(NSInteger)teamId;

@end
