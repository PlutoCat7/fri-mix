//
//  SettingWristFooterView.h
//  GB_Football
//
//  Created by gxd on 2018/1/11.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingWristFooterViewDelegate <NSObject>

- (void)didClickRestart;
- (void)didClickClose;

@end

@interface SettingWristFooterView : UIView

@property (nonatomic, weak) id<SettingWristFooterViewDelegate> delegate;

@end
