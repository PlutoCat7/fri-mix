//
//  SettingSelectTableViewCell.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/9.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SettingSelectTableViewCellType) {
    SettingSelectTableViewCellType_Text,
    SettingSelectTableViewCellType_Arrow,
    SettingSelectTableViewCellType_Select,
};

@interface SettingSelectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;

@property (nonatomic, assign) SettingSelectTableViewCellType type;

@end
