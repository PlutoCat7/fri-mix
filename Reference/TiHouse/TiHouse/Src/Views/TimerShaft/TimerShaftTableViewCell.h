//
//  TimerShaftTableViewCell.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "UICustomCollectionView.h"
#import "modelDairy.h"
#import "House.h"
@class Dairyzan;
@interface TimerShaftTableViewCell : CommonTableViewCell

@property (nonatomic ,retain) modelDairy *modelDairy;
@property (strong, nonatomic) UICustomCollectionView *mediaView;
@property (nonatomic, strong) House *house;
@property (nonatomic, copy) void(^MoreClick)(NSInteger tag, Dairyzan *zan ,BOOL iszan ,modelDairy *modelDairy);
@property (nonatomic, copy) void(^CommentReply)(modelDairy *modelDairy ,NSInteger row);
@property (nonatomic, copy) void(^PlayVido)(modelDairy *modelDairy);
@property (nonatomic, copy) void(^Share)(UMSocialMessageObject *messageObject);
@property (nonatomic, copy) void(^FullText)(TimerShaftTableViewCell *cell);

@property (nonatomic ,retain) UIImageView *icon;//时光轴间隔图标
- (void)setmodelDairy:(modelDairy *)modelDairy needTopView:(BOOL)needTopView needBottomView:(BOOL)needBottomView;
+ (CGFloat)cellHeightWithObj:(modelDairy *)modelDairy needTopView:(BOOL)needTopView needBottomView:(BOOL)needBottomView;

@end

