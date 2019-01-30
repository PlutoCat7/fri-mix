//
//  TimeDivisionRecordTableViewCell.h
//  GB_Football
//
//  Created by 王时温 on 2017/5/11.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimeDivisionRecordTableViewCell;
@protocol TimeDivisionRecordTableViewCellDelegate <NSObject>

- (void)didClickBeginTime:(TimeDivisionRecordTableViewCell *)cell;

- (void)didClickEndTime:(TimeDivisionRecordTableViewCell *)cell;

@end

@interface TimeDivisionRecordTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sectionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *beginView;
@property (weak, nonatomic) IBOutlet UIView *endView;

@property (nonatomic, weak) id<TimeDivisionRecordTableViewCellDelegate> delegate;

- (void)showBeginLayer:(BOOL)show;
- (void)showEndLayer:(BOOL)show;

@end
