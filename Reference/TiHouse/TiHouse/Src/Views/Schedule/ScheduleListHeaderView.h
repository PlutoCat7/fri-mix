//
//  ScheduleListHeaderView.h
//  TiHouse
//
//  Created by Mstic on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleListHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIImageView *imgVIcon;

@property (nonatomic, strong) UILabel *lblTime;

@property (nonatomic, copy) NSString *strDate;


//- (void)setViewTime:(long)createTime;


@end
