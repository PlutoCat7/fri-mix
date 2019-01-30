//
//  HouseChangeViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/15.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
@class Folder;
@interface SelectFileViewController : BaseViewController

@property (retain, nonatomic) House *house;
@property (retain, nonatomic) NSArray *files;
@property (nonatomic, copy) void(^selectdeFoder)(Folder *folder);

@end
