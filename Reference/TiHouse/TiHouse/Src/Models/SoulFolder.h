//
//  SoulFolder.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoulFolder : NSObject

@property (nonatomic, assign) int countAssemblefile; // 文件数量
@property (nonatomic, assign) long soulfolderctime; // 灵感册创建时间
@property (nonatomic, assign) long soulfolderid; // 自增长灵感册id
@property (nonatomic, copy) NSString *soulfoldername; // 灵感册名
@property (nonatomic, assign) long uid;

@end

