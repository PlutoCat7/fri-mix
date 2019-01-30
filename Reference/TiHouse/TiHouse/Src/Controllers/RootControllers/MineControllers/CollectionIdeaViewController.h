//
//  CollectionIdeaViewController.h
//  TiHouse
//
//  Created by admin on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
extern NSString * const editSoulFolderNameNotification;
extern NSString * const deleteSoulFolderNotification;
extern NSString * const editSoulFolderContentNotification;
@interface CollectionIdeaViewController : BaseViewController
@property (nonatomic, strong) NSMutableArray *soulfolderList;
@end
