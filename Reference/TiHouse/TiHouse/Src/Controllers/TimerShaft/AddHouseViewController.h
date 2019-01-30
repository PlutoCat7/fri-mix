//
//  AddHouseViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/16.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"

@interface AddHouseViewController : BaseViewController

@property (nonatomic, assign ,getter=isedit) BOOL edit;
@property (nonatomic, assign ,getter=isaddHouse) BOOL addHouse;
@property (nonatomic, retain) House *myHouse;
@property (nonatomic, copy) void(^finishAddHouseBlock)(House *house);
@property (nonatomic, copy) void(^editBlock)(House *house);
// 用于判断无房屋的情况
@property (nonatomic, assign) BOOL isNoHouse;
@end
