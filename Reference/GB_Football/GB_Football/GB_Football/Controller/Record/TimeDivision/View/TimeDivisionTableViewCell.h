//
//  TimeDivisionTableViewCell.h
//  GB_Football
//
//  Created by 王时温 on 2017/5/9.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeDivisionCellModel.h"

@class TimeDivisionTableViewCell;

@protocol TimeDivisionTableViewCellDelegate <NSObject>

- (void)didSelectWithIndex:(NSInteger)index cell:(TimeDivisionTableViewCell *)cell;

@end

@interface TimeDivisionTableViewCell : UITableViewCell

@property (nonatomic, weak) id<TimeDivisionTableViewCellDelegate> delegate;
@property (nonatomic, assign) BOOL showTimeRate;

- (void)refreshWithModel:(TimeDivisionCellModel *)model;

@end
