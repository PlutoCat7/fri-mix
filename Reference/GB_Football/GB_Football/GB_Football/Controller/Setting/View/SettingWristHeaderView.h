//
//  SettingWristHeaderView.h
//  GB_Football
//
//  Created by gxd on 2018/1/11.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingWristHeaderViewDelegate <NSObject>

- (void)didClickWristHeader;

@end

@interface SettingWristHeaderView : UIView

@property (nonatomic, weak) id<SettingWristHeaderViewDelegate> delegate;

- (void)refreshUI;

@end
