//
//  modelTallys.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface modelTallys : NSObject

//最后更新时间
@property (nonatomic, assign) long latesttime;
//账本id
@property (nonatomic, assign) long tallyid;
//账本名称
@property (nonatomic, copy) NSString *tallyname;
//用户昵称
@property (nonatomic, copy) NSString *nickname;
//记账内容
@property (nonatomic, retain) NSArray *listModelLogtallyope;

@end
