//
//  CloudReCollectItemModel.h
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudReCollectItemModel : NSObject

@property (assign, nonatomic) long fileid;//自增长id
@property (assign, nonatomic) long uid;//所属用户uid
@property (assign, nonatomic) long houseid;//所属房屋houseid
@property (copy, nonatomic) NSString * housename;//所属房屋名称
@property (copy, nonatomic) NSString * urlfile;//文件路径
@property (assign, nonatomic) long folderid;//所属文件夹id
@property (assign, nonatomic) long filecreatetime;//文件创建日期
@property (assign, nonatomic) int typefile;//文件类型，1图片2视频
@property (copy, nonatomic) NSString * dairydesc;//文件名称，同dairy表的dairydesc
@property (assign, nonatomic) long dairyid;//同dairy表的dairyid一致
@property (assign, nonatomic) BOOL typecollect;//文件是否收藏，0否1是
@property (assign, nonatomic) int typeowner;//拥有者类型，1自己上传2别人上传
@property (copy, nonatomic) NSString * urlfilesmall;
@property (copy, nonatomic) NSString * urlshare;
@property (copy, nonatomic) NSString * linkshare;

@property (copy, nonatomic) NSString * time;//年月日（自定义）
@property (nonatomic, assign) int dairytype;
@property (nonatomic, assign) long dairytime; // 实现最新的排序方式
@property (nonatomic, assign) long fileseconds; // 视频秒数

@end
