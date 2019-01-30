//
//  TweetComment.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetComment : NSObject
//评论id（添加子评论时 必填 否则 -1）
@property (nonatomic, assign) long dairycommid;
//日记id
@property (nonatomic, assign) long dairyid;
//房屋id
@property (nonatomic, assign) long houseid;
//评论者uid
@property (nonatomic, assign) long dairycommuid;
//被评论者uid
@property (nonatomic, assign) long dairycommuidon;
//评论内容
@property (nonatomic, copy) NSString *dairycommcontent;
//评论时间
@property (nonatomic, assign) long dairycommctime;
//评论时间
@property (nonatomic, assign) long dairycommstime;
//评论者姓名
@property (nonatomic, copy) NSString *dairycommname;
//被评论者姓名
@property (nonatomic, copy) NSString *dairycommnameon;


- (NSString *)toPath;
- (NSDictionary *)toParams;


@end
