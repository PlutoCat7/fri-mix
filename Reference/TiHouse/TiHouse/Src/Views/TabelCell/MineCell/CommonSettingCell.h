//
//  CommonSettingCell.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"

@protocol CommenSettingDelegate<NSObject>

@optional
- (void)quitLogin;

@end

@interface CommonSettingCell : CommonTableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) id<CommenSettingDelegate> delegate;
@property (nonatomic, strong) UISwitch *switchControl;
@property (nonatomic, strong) void(^modifyBlock)(BOOL b);
@property (nonatomic, strong) UILabel *subLabel;

@property (nonatomic, copy) void(^switchBlock)(BOOL isOn);

@end
