//
//  EditSoulFolderController.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
@class SoulFolder;

extern NSString * const editSoulFolderNameNotification;
extern NSString * const deleteSoulFolderNotification;

@interface EditSoulFolderController : BaseViewController

@property (nonatomic, strong) SoulFolder *soulFolder;

@end
