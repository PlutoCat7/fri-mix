//
//  TallyTimePickerView.h
//  Demo2018
//
//  Created by AlienJunX on 2018/2/26.
//  Copyright © 2018年 AlienJunX. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TallyTimePickerViewBlock)(NSString *timeString, NSDate *date);
@interface TallyTimePickerView : UIView

- (void)show:(TallyTimePickerViewBlock)block;

@end
