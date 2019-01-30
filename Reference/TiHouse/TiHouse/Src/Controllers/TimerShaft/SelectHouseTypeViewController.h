//
//  SelectHouseTypeViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/16.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"

@interface SelectHouseTypeViewController : BaseViewController

@property (nonatomic, retain) NSMutableDictionary *ValuesDic;
@property (nonatomic, copy) void(^SelectedHouseType)(NSMutableDictionary *);

@end
