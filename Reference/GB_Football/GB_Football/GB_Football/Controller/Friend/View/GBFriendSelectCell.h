//
//  GBFriendSelectCell.h
//  GB_Football
//
//  Created by 王时温 on 2017/5/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GBFriendSelectCellType) {
    GBFriendSelectCell_Selected,  //已选择
    GBFriendSelectCell_UnSelected, //未选择
    GBFriendSelectCell_NotSelected, //不能被选择
};

@interface GBFriendSelectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (nonatomic, assign) GBFriendSelectCellType type;

@end
