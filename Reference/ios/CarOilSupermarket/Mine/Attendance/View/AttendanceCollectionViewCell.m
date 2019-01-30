//
//  AttendanceCollectionViewCell.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/20.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "AttendanceCollectionViewCell.h"
#import "AttendanceCellModel.h"
#import "GBView.h"

@interface AttendanceCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *currentDateView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet GBView *attendanceBadgeView;

@end

@implementation AttendanceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentDateView.layer.cornerRadius = self.currentDateView.width/2;
    });
}

- (void)refreshWithModel:(AttendanceCellModel *)model {
    
    self.dayLabel.text = model.dayString;
    self.dayLabel.textColor = model.isToday?[UIColor whiteColor]:[UIColor blackColor];
    self.currentDateView.hidden = !model.isToday;
    self.attendanceBadgeView.hidden = !model.isAttendance;
}

@end
