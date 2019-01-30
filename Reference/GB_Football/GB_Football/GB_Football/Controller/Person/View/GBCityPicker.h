//
//  GBCityPicker.h
//  GB_Football
//
//  Created by Pizza on 16/8/4.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GBCityPickerDelegate <NSObject>
@optional
- (void)didSelectAreaString:(NSString *)string provinceId:(NSInteger)provinceId cityId:(NSInteger)cityId areaId:(NSInteger)areaId;
@end

@interface GBCityPicker : UIView
@property(nonatomic, weak) id <GBCityPickerDelegate> delegate;
+ (instancetype)show:(NSInteger)provinceId cityId:(NSInteger)cityId areaId:(NSInteger)areaId;
+ (BOOL)hide;
@end
