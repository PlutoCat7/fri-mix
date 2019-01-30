//
//  AssemarcFile.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssemarcFile : NSObject

@property (nonatomic, assign) long assemfileid; // 自增长id
@property (nonatomic, assign) long uid;
@property (nonatomic, copy) NSString *urlsoulfile; // 图片url (弃用)
@property (nonatomic, copy) NSString *assemarcfileurl; // 图片url
@property (nonatomic, assign) long assemarcid; // 征集id
@property (nonatomic, assign) long assemarcfileid; //
@property (nonatomic, assign) long assemarcfilecollid;

@property (nonatomic, assign) long soulfolderid; // 所属灵感册id
@property (nonatomic, assign) int issource; // 是否是创建图文时的源文件，0不是(从收藏而来)，1是(从发布而来)

@end
