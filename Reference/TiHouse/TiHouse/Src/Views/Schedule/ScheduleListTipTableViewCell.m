//
//  ScheduleListTipTableViewCell.m
//  TiHouse
//
//  Created by 吴俊明 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleListTipTableViewCell.h"
#import "NSDate+Extend.h"

@implementation ScheduleListTipTableViewCell

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
    
    self.lblTitle.text = [NSString emojizedStringWithString:IF_NULL_TO_STRINGSTR(sModel.schedulename, @"--")];
    
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
    
    self.lblMark.text = [NSString emojizedStringWithString:IF_NULL_TO_STRINGSTR(sModel.scheduleremark, @"")];
    if (self.lblMark.text.length <= 0) {
        [self.s_edit_img setHidden:YES];
    } else {
        [self.s_edit_img setHidden:NO];
    }
    
    /* 提醒谁看先隐藏
    self.imgV1.hidden = YES;
    self.imgV2.hidden = YES;
    self.imgV3.hidden = YES;
    
    if (sModel.urlschedulearruidtip.length>0) {
        NSArray *arr = [sModel.urlschedulearruidtip componentsSeparatedByString:@","];
        for (int i = 0; i< arr.count; i++) {
            
            switch (i) {
                case 0:{
                    self.imgV1.hidden = NO;
                    [self.imgV1 sd_setImageWithURL:[NSURL URLWithString:arr[i]] placeholderImage:IMAGE_ANME(@"r_me")];
                }
                    break;
                case 1:{
                    self.imgV2.hidden = NO;
                    [self.imgV2 sd_setImageWithURL:[NSURL URLWithString:arr[i]] placeholderImage:IMAGE_ANME(@"r_me")];
                }
                    break;
                case 2:{
                    self.imgV3.hidden = NO;
                    [self.imgV3 sd_setImageWithURL:[NSURL URLWithString:arr[i]] placeholderImage:IMAGE_ANME(@"r_me")];
                }
                    break;
                default:
                    return;
                    break;
            }
        }
    }
     */
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
