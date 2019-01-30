//
//  ScheduleListTableViewCell.h
//  TiHouse
//
//  Created by cuiPeng on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleModel.h"

@interface ScheduleListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (weak, nonatomic) IBOutlet UIView *colorView;

@property (nonatomic, strong) ScheduleModel *sModel;

@end
