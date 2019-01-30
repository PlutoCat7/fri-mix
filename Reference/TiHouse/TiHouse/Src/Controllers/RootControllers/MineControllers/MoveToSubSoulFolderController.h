//
//  MoveToSubSoulFolderController.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
extern NSString * const editSoulFolderContentNotification;

@class AssemarcFile;
@interface MoveToSubSoulFolderController : BaseViewController

@property (nonatomic, strong) NSMutableArray *soulFoldersArray;
@property (nonatomic, strong) NSSet<AssemarcFile *> *selectedItems;
@end
