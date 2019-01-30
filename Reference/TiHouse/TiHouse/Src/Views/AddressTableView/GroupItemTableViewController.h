//
//  GroupItemTableViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/17.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddresManager.h"
@interface GroupItemTableViewController : UITableViewController

@property (nonatomic, retain) AddresManager *Addres;
@property (nonatomic, assign) NSInteger item;//
@property (nonatomic, copy) void(^SelectedItem)(NSInteger item);



@end
