//
//  GBDailyDetailCell.m
//  GB_Football
//
//  Created by gxd on 17/6/7.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBDailyDetailCell.h"


@interface GBDailyDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *stepStLbl;
@property (weak, nonatomic) IBOutlet UILabel *kcalStLbl;

@end

@implementation GBDailyDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.stepStLbl.text = LS(@"week.label.item.step");
    self.distanceStLbl.text = LS(@"week.label.item.km");
    self.kcalStLbl.text = LS(@"week.label.item.kcal");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
