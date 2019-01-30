//
//  FindAssemActivityInfo.h
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "YAHActiveObject.h"

@interface FindAssemUserInfo : YAHActiveObject

@property (nonatomic, copy) NSString *urlhead;

@end

@interface FindAssemActivityInfo : YAHActiveObject

@property (nonatomic, assign) long assemid;
@property (nonatomic, copy) NSString *assemurlindex;  //征集活动封面
@property (nonatomic, copy) NSString *assemtitle;
@property (nonatomic, copy) NSString *assemcontent;
@property (nonatomic, copy) NSString *assemlinkprize;   //活动奖品页面链接地址
@property (nonatomic, assign) NSInteger status;   //征集活动状态，1进行中2已结束
@property (nonatomic, assign) NSInteger createtime;
@property (nonatomic, assign) NSInteger numjoin; //加入人数
@property (nonatomic, copy) NSString *urlshare;
@property (nonatomic, copy) NSString *linkshare;
@property (nonatomic, strong) NSArray<FindAssemUserInfo *> *userJA;
//前后加入#
- (NSString *)titleWithPreSub;

@end
