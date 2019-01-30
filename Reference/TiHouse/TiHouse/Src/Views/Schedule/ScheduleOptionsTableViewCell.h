//
//  ScheduleOptionsTableViewCell.h
//  TiHouse
//
//  Created by apple on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleOptionsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgVIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgVSelIcon;

@property (nonatomic, strong) NSDictionary *dict;

/**
 设置

 @param selStatus 数据
 @param index 索引 ：1，2，3，4：未来，过去，已完成，未完成
 */
- (void)setViewWithSelStatus:(BOOL)selStatus index:(NSInteger)index;

@end
