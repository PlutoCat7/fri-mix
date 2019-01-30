//
//  ScheduleListTipTableViewCell.h
//  TiHouse
//
//  Created by 吴俊明 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleModel.h"

@interface ScheduleListTipTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (weak, nonatomic) IBOutlet UIView *colorView;

@property (weak, nonatomic) IBOutlet UILabel *lblMark;

@property (weak, nonatomic) IBOutlet UIImageView *imgV1;

@property (weak, nonatomic) IBOutlet UIImageView *imgV2;

@property (weak, nonatomic) IBOutlet UIImageView *imgV3;

@property (weak, nonatomic) IBOutlet UIImageView *s_edit_img;

@property (nonatomic, strong) ScheduleModel *sModel;

@end
