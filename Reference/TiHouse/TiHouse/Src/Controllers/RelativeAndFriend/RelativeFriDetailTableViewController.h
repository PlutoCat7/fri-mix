//
//  RElativeFriDetailTableViewController.h
//  TiHouse
//
//  Created by guansong on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Houseperson.h"
#import "House.h"

@interface RelativeFriDetailTableViewController : UITableViewController

@property (nonatomic,strong) Houseperson *person;

@property (nonatomic,strong) House *house;

@end
