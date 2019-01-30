//
//  GBRecordPlayerCell.h
//  GB_Team
//
//  Created by Pizza on 16/9/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBPositionLabel.h"

#import "MatchDetailResponseInfo.h"

@interface GBRecordPlayerCell : UITableViewCell
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
// 名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 年龄
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
// 位置标签
@property (weak, nonatomic) IBOutlet GBPositionLabel *positionLabel1;
@property (weak, nonatomic) IBOutlet GBPositionLabel *positionLabel2;
// 移动距离
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
// 速度
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
// 体能
@property (weak, nonatomic) IBOutlet UILabel *physicalLabel;

- (void)refreshWithMatchPlayerInfo:(MatchPlayerInfo *)matchPlayerInfo;

@end
