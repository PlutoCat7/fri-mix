//
//  Houseperson.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Houseperson : NSObject

///自增长房屋关系id   ,房屋houseid，关联表house的houseid字段
@property (nonatomic, assign) long housepersonid ,houseid;

@property (nonatomic,assign) NSInteger updatetime;

///与房屋的关系，0尚未选择1女主人2男主人3亲人4设计方5施工方6朋友      ,角色类型：1读写2只读      ,关注者用户uid
@property (nonatomic, assign) NSInteger typerelation ,typerole ,uidconcert;


///用户在房屋中的昵称(默认为用户的名字)
@property (nonatomic ,copy) NSString *nickname, *housename,*urlhead;
///是否有编辑权限，0没有1有
@property (nonatomic, assign)BOOL isedit;
///是否有查看日记权限，0没有1有
@property (nonatomic, assign)BOOL isreaddairy;
///是否有查看预算的权限，0没有1有
@property (nonatomic, assign)BOOL isreadbudget;
///是否有查看账本的权限，0没有1有
@property (nonatomic, assign)BOOL isreadtally;
///是否有查看日程的权限，0没有1有
@property (nonatomic, assign)BOOL isreadschedule;

/// 关系名称
-(NSString *) typerelationName;

@end
