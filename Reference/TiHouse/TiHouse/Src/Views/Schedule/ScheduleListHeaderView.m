//
//  ScheduleListHeaderView.m
//  TiHouse
//
//  Created by Mstic on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleListHeaderView.h"

#import "NSDate+Extend.h"

@implementation ScheduleListHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self xl_setupSubView];
    }
    return self;
}
#pragma mark - 数据设置

- (void)setStrDate:(NSString *)strDate{
    
    NSDate *date = [NSDate dateWithString:strDate format:@"yyyy-MM-dd"];
    
    NSString *week = [date dayFromWeekday];
    
    NSString *strDate1 = [date isToday] ? @"今天" : [NSDate stringWithDate:date format:@"yyy年MM月dd日"];
    
    self.lblTime.text = [NSString stringWithFormat:@"%@ · %@",strDate1,week];
    
    if ([date isToday]) {
        self.imgVIcon.image = IMAGE_ANME(@"s_schedule_time");
    }else{
        self.imgVIcon.image = IMAGE_ANME(@"s_schedule_icon");
    }
    
}


#pragma mark - 视图基础设计


- (void)xl_setupSubView{
    
    [self addSubview:self.imgVIcon];
    [self addSubview:self.lblTime];
    
    [self updateConstraints];
    [self updateConstraintsIfNeeded];
    
}

- (void)updateConstraints{
    WS(weakSelf);
    [self.imgVIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(10);
        make.width.height.mas_equalTo(11);
    }];
    
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imgVIcon.mas_right).offset(5);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-12);
        make.centerY.equalTo(weakSelf.imgVIcon.mas_centerY);
    }];
    
    [super updateConstraints];
}

- (UILabel *)lblTime{
    if (!_lblTime) {
        _lblTime = [[UILabel alloc] init];
        _lblTime.font = ZISIZE(12);
        _lblTime.textColor = RGB(191, 191, 191);
        _lblTime.text = @"01月28日·星期四";
    }
    return _lblTime;
}

- (UIImageView *)imgVIcon{
    if (!_imgVIcon) {
        _imgVIcon = [[UIImageView alloc] init];
        _imgVIcon.image = IMAGE_ANME(@"s_schedule_icon");
    }
    return _imgVIcon;
}


@end







