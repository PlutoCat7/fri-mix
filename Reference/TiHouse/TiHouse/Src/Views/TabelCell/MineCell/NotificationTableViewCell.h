//
//  NotificationTableViewCell.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"

@protocol NotificationDelegate<NSObject>

- (void)modifyNotificationStatus:(BOOL)b title:(NSString *)title;

@end

@interface NotificationTableViewCell : CommonTableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UISwitch *switchControl;

@property (nonatomic, assign) id<NotificationDelegate> delegate;

@end
