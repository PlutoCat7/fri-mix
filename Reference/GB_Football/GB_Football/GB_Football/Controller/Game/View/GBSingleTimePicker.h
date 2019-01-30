//
//  GBSingleTimePicker.h
//  GB_Football
//
//  Created by 王时温 on 2017/5/15.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBSingleTimePicker;
@protocol GBSingleTimePickerDelegate <NSObject>
-(void)GBSingleTimePicker:(GBSingleTimePicker*)picker startHour:(NSInteger)startHour startMin:(NSInteger)startMin;
@end

@interface GBSingleTimePicker : UIView

@property(nonatomic, weak) id <GBSingleTimePickerDelegate> delegate;
+ (instancetype)showWithSelectIndex:(NSInteger)startHour startMin:(NSInteger)startMin;

@end
