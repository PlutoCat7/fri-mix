//
//  Folder.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/16.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Folder : NSObject

@property (nonatomic, assign) long folderid, uid;
//文件夹类型，1系统默认，2自己添加
@property (nonatomic, assign) int foldertype;
//    文件夹名称
@property (nonatomic, copy) NSString *foldername;


@end
