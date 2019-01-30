//
//  TeamTacticsListResponse.h
//  GB_Football
//
//  Created by yahua on 2018/1/12.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "GBResponsePageInfo.h"

@interface TeamTacticsInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger tacticsId;   //战术id
@property (nonatomic, assign) NSInteger user_id;     //创建者id
@property (nonatomic, copy) NSString *tactics_mess;  //战术数据
@property (nonatomic, copy) NSString *tactics_name;   //战术名称
@property (nonatomic, assign) NSInteger people_num;   //球员个数
@property (nonatomic, assign) NSInteger create_time;  //创建日期
@property (nonatomic, assign) NSInteger update_time;  //修改日期

@end

@interface TeamTacticsListResponse : GBResponsePageInfo

@property (nonatomic, strong) NSArray<TeamTacticsInfo *> *data;

@end
