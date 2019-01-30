//
//  AreaPickerView.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/6.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaPickerView : UIView

+ (instancetype)showWithHandler:(void(^)(NSString *province, NSString *city, NSString *area))handler;

+ (void)hide;

@end
