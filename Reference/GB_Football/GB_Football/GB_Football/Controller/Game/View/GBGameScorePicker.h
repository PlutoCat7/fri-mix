//
//  GBGameScorePicker.h
//  GB_Football
//
//  Created by Pizza on 16/8/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBGameScorePicker;
@protocol GBGameScorePickerDelegate <NSObject>
-(void)GBGameScorePicker:(GBGameScorePicker*)picker our:(NSInteger)our opp:(NSInteger)opp;
@end

@interface GBGameScorePicker : UIView
@property(nonatomic, weak) id <GBGameScorePickerDelegate> delegate;
+ (instancetype)showWithOurSelectIndex:(NSInteger)ourSelectIndex oppSelectIndex:(NSInteger)oppSelectIndex;
+ (BOOL)hide;
@end
