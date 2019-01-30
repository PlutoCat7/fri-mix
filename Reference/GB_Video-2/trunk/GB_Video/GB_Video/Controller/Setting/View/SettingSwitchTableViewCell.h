//
//  SettingSwitchTableViewCell.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/12.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBSwtich.h"

@interface SettingSwitchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet GBSwtich *siwtchView;

@end
