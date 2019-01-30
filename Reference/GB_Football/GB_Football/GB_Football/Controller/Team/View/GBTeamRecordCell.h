//
//  GBTeamRecordCell.h
//  GB_Football
//
//  Created by gxd on 17/7/27.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBTeamRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamTracticsLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchIntervalLabel;

@end
