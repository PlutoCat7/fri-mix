//
//  Dairycomm.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dairycomm : NSObject

@property (nonatomic, assign) long dairycommid;//    自增长id
@property (nonatomic, assign) long dairyid;  //    所属日记dairyid
@property (nonatomic, assign) long dairycommuid;//日记主评论者用户uid
@property (nonatomic, assign) long dairycommuidon;//    被评论者用户uid，默认-1
@property (nonatomic, copy) NSString *dairycommcontent;//    日记评论内容
@property (nonatomic, assign) long dairycommctime;//    日记评论时间
@property (nonatomic, assign) long dairycommstime;// 子评论时间，默认与主评论时间一致
@property (nonatomic, copy) NSString *dairycommname;//    评论者姓名
@property (nonatomic, copy) NSString *dairycommnameon;//    被评论者姓名
@end
