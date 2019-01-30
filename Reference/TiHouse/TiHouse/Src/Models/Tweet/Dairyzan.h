//
//  Dairyzan.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dairyzan : NSObject

@property (nonatomic, assign) long dairyzanid;    //自增长id
@property (nonatomic, assign) long dairyid;      //    所属日记dairyid
@property (nonatomic, assign) long dairyzanuid;  //日记点赞者用户uid
@property (nonatomic, assign) long houseid;  //房屋id
@property (nonatomic, copy) NSString *username; //点赞用户名称

-(NSString *)toPathisZan:(BOOL)isZan;
-(NSDictionary *)toParams;

@end
