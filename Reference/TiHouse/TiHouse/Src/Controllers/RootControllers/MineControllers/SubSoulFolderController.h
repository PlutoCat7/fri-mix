//
//  SubSoulFolderController.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
@class SoulFolder;

extern NSString * const editSoulFolderNameNotification;

@interface SubSoulFolderController : BaseViewController

// 当前model
@property (nonatomic, strong) SoulFolder *soulFolder;
@property (nonatomic, strong) NSMutableArray *soulFolderList;

@end
