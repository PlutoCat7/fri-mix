//
//  GBGameTimePicker.h
//  GB_Football
//
//  Created by Pizza on 16/8/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBGameTimePicker;
@protocol GBGameTimePickerDelegate <NSObject>
-(void)GBGameTimePicker:(GBGameTimePicker*)picker startHour:(NSInteger)startHour startMin:(NSInteger)startMin endHour:(NSInteger)endHour endMin:(NSInteger)endMin;
@end

@interface GBGameTimePicker : UIView

@property(nonatomic, weak) id <GBGameTimePickerDelegate> delegate;
+ (instancetype)showWithSelectIndex:(NSInteger)startHour startMin:(NSInteger)startMin endHour:(NSInteger)endHour endMin:(NSInteger)endMin;

@end
