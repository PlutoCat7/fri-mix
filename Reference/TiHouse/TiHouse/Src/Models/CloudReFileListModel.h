//
//  CloudReFileListModel.h
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudReFileListModel : NSObject

@property (copy, nonatomic) NSString * foldername;//文件夹名称
@property (assign, nonatomic) long folderid;//自增长id
@property (assign, nonatomic) int uid;//用户uid
@property (assign, nonatomic) int foldertype;//文件夹类型，1系统默认，2自己添加
@property (assign, nonatomic) long houseid;//所属房屋id
@property (copy, nonatomic) NSString * folderImgName;

@end
