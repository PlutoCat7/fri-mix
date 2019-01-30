//
//  GBGameDatePicker.h
//  GB_Team
//
//  Created by gxd on 16/11/29.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GBGameDateDelegate <NSObject>
@optional
- (void)didSelectDateWithDate:(NSDate *)date year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
@end


@interface GBGameDatePicker : UIView

// 打开右侧弹出框
+(GBGameDatePicker *)showWithDate:(NSDate *)date;
// 收起右侧弹出框
+(BOOL)hide;
// 日期代理
@property(nonatomic, weak) id <GBGameDateDelegate> delegate;

@end
