//
//  ScheduleOptionsTableViewCell.m
//  TiHouse
//
//  Created by apple on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleOptionsTableViewCell.h"

@implementation ScheduleOptionsTableViewCell

- (void)setDict:(NSDictionary *)dict{
    self.lblTitle.text = dict[@"title"];
}
/**
 设置
 
 @param selStatus 数据
 @param index 索引 ：1，2，3，4：未来，过去，已完成，未完成
 */
- (void)setViewWithSelStatus:(BOOL)selStatus index:(NSInteger)index{
    switch (index) {
        case 2:
        {
            self.imgVIcon.image = IMAGE_ANME(@"s_past_icon");
        }
            break;
        case 3:{
            self.imgVIcon.image = IMAGE_ANME(@"s_past_icon");
        }
            break;
        case 4:{
            self.imgVIcon.image = IMAGE_ANME(@"s_future_icon");
        }
            break;
        default:
            break;
    }
    
    if (index>2) {
        if (selStatus) {
            self.imgVIcon.image = IMAGE_ANME(@"s_radio_choose");
        }else {
            self.imgVIcon.image = IMAGE_ANME(@"s_radio_no_choose");
        }
        self.imgVSelIcon.hidden = YES;
    }else{
        self.imgVSelIcon.hidden = !selStatus;
    }    
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
