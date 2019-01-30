//
//  SettingAvatorTableViewCell.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/9.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingAvatorTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrrowImageView;
@property (weak, nonatomic) IBOutlet UIView *avatorContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;

- (void)hideArrowImageView:(BOOL)hide;

@end
