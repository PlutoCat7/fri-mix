//
//  AssemCellModel.h
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FindAssemActivityInfo.h"

@interface AssemCellModel : NSObject

@property (nonatomic, assign) long assemid;
@property (nonatomic, copy) NSString *assemurlindex;  //征集活动封面
@property (nonatomic, copy) NSString *assemtitle;
@property (nonatomic, assign) NSInteger assemstatus;

@property (nonatomic, strong) NSArray<FindAssemUserInfo *> *userList; //最多4个用户征集图文
@property (nonatomic, assign) NSInteger totalUserCount;  //总用户参与征集个数

@end
