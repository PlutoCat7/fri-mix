//
//  SettingAuthorityViewController.h
//  TiHouse
//
//  Created by apple on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
#import "Houseperson.h"

@interface SettingAuthorityViewController : BaseViewController

@property (nonatomic, strong) Houseperson *person;
///是不是主人
@property (nonatomic, assign) BOOL isMaster;

@end
