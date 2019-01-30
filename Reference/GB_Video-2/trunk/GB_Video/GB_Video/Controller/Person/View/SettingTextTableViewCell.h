//
//  SettingTextTableViewCell.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/8.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTextTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

- (void)hideArrowImageView:(BOOL)hide;

@end
