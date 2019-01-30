//
//  GBDatePicker.h
//  GB_Football
//
//  Created by Pizza on 16/8/4.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ZHDatePickerDisplayModelBeforeCurrent = 0,
    ZHDatePickerDisplayModeFreeStyle = 1,
}ZHDatePickerDisplayMode;

@protocol GBDatePickerDelegate <NSObject>
@optional
- (void)didSelectDateWithDate:(NSDate *)date year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
@end

@interface GBDatePicker : UIView
@property(nonatomic, weak) id <GBDatePickerDelegate> delegate;
@property(nonatomic, assign) ZHDatePickerDisplayMode pickerDisplayMode;
+ (instancetype)showWithDate:(NSDate *)date;
+ (instancetype)showWithDate:(NSDate *)date title:(NSString *)title;
+ (BOOL)hide;
@end
