//
//  GBRunRecordCell.m
//  GB_Football
//
//  Created by gxd on 17/7/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBRunRecordCell.h"

@interface GBRunRecordCell()
@property (weak, nonatomic) IBOutlet UILabel *durationStLbl;
@property (weak, nonatomic) IBOutlet UILabel *calorieStLbl;
@property (weak, nonatomic) IBOutlet UILabel *speedStLbl;

@end

@implementation GBRunRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.durationStLbl.text = LS(@"run.record.label.duraton");
    self.calorieStLbl.text = LS(@"run.record.label.calorie");
    self.speedStLbl.text = LS(@"run.record.label.speed");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
