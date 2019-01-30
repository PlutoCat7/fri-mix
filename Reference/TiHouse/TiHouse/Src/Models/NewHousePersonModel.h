//
//  NewHousePersonModel.h
//  TiHouse
//
//  Created by 陈晨昕 on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewHousePersonModel : NSObject
///自增长房屋关系id
@property (assign, nonatomic) long housepersonid;
///房屋houseid，关联表house的houseid字段
@property (assign, nonatomic) long houseid;
///与房屋的关系，0尚未选择1女主人2男主人3亲人4设计方5施工方6朋友
@property (assign, nonatomic) int typerelation;
///关注者用户uid
@property (assign, nonatomic) long uidconcert;
///是否有编辑权限，0没有1有
@property (assign, nonatomic) int isedit;
///是否有查看日记权限，0没有1有
@property (assign, nonatomic) int isreaddairy;
///是否有查看预算的权限，0没有1有
@property (assign, nonatomic) int isreadbudget;
///是否有查看账本的权限，0没有1有
@property (assign, nonatomic) int isreadtally;
///是否有查看日程的权限，0没有1有
@property (assign, nonatomic) int isreadschedule;
///用户在房屋中的昵称(默认为用户的名字)
@property (copy, nonatomic) NSString * nickname;
///房屋名称
@property (copy, nonatomic) NSString * housename;
///关注者名称
@property (copy, nonatomic) NSString * username;
///用户在房屋中的头像(默认为用户的头像)
@property (copy, nonatomic) NSString * urlhead;

@property (nonatomic, assign) BOOL selected;

@end
