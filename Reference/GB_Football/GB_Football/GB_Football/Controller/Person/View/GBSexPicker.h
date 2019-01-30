//
//  GBSexPicker.h
//  GB_Football
//
//  Created by Pizza on 16/8/4.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GBSexPickerDelegate <NSObject>

@optional
// 男0女1
- (void)didSelectSexIndex:(NSInteger)index;

@end

@interface GBSexPicker : UIView

@property(nonatomic, weak) id <GBSexPickerDelegate> delegate;
+ (instancetype)showWithIndex:(NSInteger)index;
+ (BOOL)hide;

@end
