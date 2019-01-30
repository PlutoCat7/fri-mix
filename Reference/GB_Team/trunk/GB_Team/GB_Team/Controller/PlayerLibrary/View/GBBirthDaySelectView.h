//
//  GBBirthDaySelectView.h
//  GB_Team
//
//  Created by Pizza on 2016/11/28.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GBBirthDaySelectViewDelegate <NSObject>
@optional
- (void)didSelectDateWithDate:(NSDate *)date year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
@end

@interface GBBirthDaySelectView : UIView
// 打开右侧弹出框
+(GBBirthDaySelectView *)showWithDate:(NSDate *)date;
// 收起右侧弹出框
+(void)hide;
// 日期代理
@property(nonatomic, weak) id <GBBirthDaySelectViewDelegate> delegate;
@end
