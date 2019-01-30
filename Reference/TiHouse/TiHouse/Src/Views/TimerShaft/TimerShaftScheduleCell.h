//
//  TimerShaftTableViewCell.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "TweetScheduleMap.h"
@interface TimerShaftScheduleCell : CommonTableViewCell

@property (nonatomic ,retain) TweetScheduleMap *tweetScheduleMap;
@property (nonatomic, copy) void(^CellBlockClick)(NSInteger tag);
@property (nonatomic ,retain) UIImageView *icon;//时光轴间隔图标
- (void)setmodelTweetScheduleMap:(TweetScheduleMap *)tweetScheduleMap needTopView:(BOOL)needTopView needBottomView:(BOOL)needBottomView;
+ (CGFloat)cellHeightWithTweetScheduleMap:(TweetScheduleMap *)tweetScheduleMap needTopView:(BOOL)needTopView needBottomView:(BOOL)needBottomView;

@end
