//
//  Tally.h
//  TiHouse
//
//  Created by gaodong on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tally : NSObject

@property (assign, nonatomic) long tallyid,houseid,uidcreater,amountzys,tallyctime;//自增长id, 所属房屋id, 所属用户id,总预算，单位(分), 记账创建时间
@property (assign, nonatomic) double doubleamountzys;//总预算，单位(元)
@property (strong, nonatomic) NSString *tallyname;//账本名称
@property (nonatomic, assign) int tallyislatestedit;
@property (nonatomic, assign) long tallyamountallhf;
@property (nonatomic, assign) long tallyamountallzc;
@property (nonatomic, assign) NSInteger numdetail;
@property (nonatomic, copy) NSString *linkshare;
@end
