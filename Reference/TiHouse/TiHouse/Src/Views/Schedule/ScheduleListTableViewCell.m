//
//  ScheduleListTableViewCell.m
//  TiHouse
//
//  Created by cuiPeng on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleListTableViewCell.h"
#import "NSDate+Extend.h"



@implementation ScheduleListTableViewCell

- (void)setSModel:(ScheduleModel *)sModel{
    _sModel = sModel;
    
    long dateS = sModel.schedulestarttime/1000;
    NSString *date = [NSDate timeStringFromTimestamp:dateS formatter:@"yyyy-MM-dd"];
    long dateE = sModel.scheduleendtime/1000;
    NSString *date1 = [NSDate timeStringFromTimestamp:dateE formatter:@"yyyy-MM-dd"];
    
    NSInteger count = [NSDate calSpaceDayDate:date endDate:date1];
    
    NSString * formatter = @"hh:mm";
    if (count > 0) {
        formatter = @"MM/dd hh:mm";
    }
    

    NSString *strDate1 = [NSDate timeStringFromTimestamp:sModel.schedulestarttime/1000 formatter:formatter];

    NSString *strDate2 = [NSDate timeStringFromTimestamp:sModel.scheduleendtime/1000 formatter:formatter];
    
    self.lblTime.text = JString(@"%@ - %@",strDate1,strDate2);
    
    self.lblTitle.text = IF_NULL_TO_STRINGSTR(sModel.schedulename, @"无");
    
    self.colorView.backgroundColor = [UIColor colorWithHexString:JString(@"0x%@",sModel.schedulecolor)];
    
    if (sModel.scheduletype) {//已完成
        self.lblTitle.textColor = kdayListPastTextColor;
        self.lblStatus.textColor = kdayTypeFinishTextColor;
        self.lblStatus.backgroundColor = kdayTypeFinishBGColor;
        self.lblStatus.text = @"已完成";
        
    }else{
        self.lblTitle.textColor = kdayListFutureTextColor;
        self.lblStatus.textColor = kdayTypeExeTextColor;
        self.lblStatus.backgroundColor = kdayTypeExeBGColor;
        self.lblStatus.text = @"未完成";
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
