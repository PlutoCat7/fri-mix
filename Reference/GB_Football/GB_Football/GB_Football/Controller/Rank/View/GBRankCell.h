//
//  GBRankCell.h
//  GB_Football
//
//  Created by Pizza on 16/9/1.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RANK_STYLE) {
   RANK_NORMAL  = 0,
   RANK_1,
   RANK_2,
   RANK_3,
   RANK_SELF,
};

@interface GBRankCell : UITableViewCell

// 排名标签
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
// 用户头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
// 用户姓名
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
// 单位
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
// 参数值 公里数 速度等
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

// 是否是自己，如果是自己，排名标签栏会有黑色块显示
@property (nonatomic,assign) BOOL isSelf;
// 排名栏颜色风格 白 绿黄青 红
@property (nonatomic,assign) RANK_STYLE rankStyle;

@end
