//
//  GameRecordTableViewCell.h
//  GB_Football
//
//  Created by 王时温 on 2017/5/9.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecordListCellModel;

@interface GameRecordTableViewCell : UITableViewCell

// 日期
@property (weak, nonatomic) IBOutlet UILabel *dateDayLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateMonthLabel;
// 比赛名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 球场地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
// 等待中
@property (weak, nonatomic) IBOutlet UIView *waitingView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
// 处理中，等待记录下推
@property (assign, nonatomic) BOOL isWating;

- (void)refreshWithModel:(RecordListCellModel *)model;

@end
