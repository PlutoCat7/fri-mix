//
//  TimerShaftTableViewCell.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "modelDairy.h"
#import "UICustomCollectionView.h"
#import "House.h"
@class Dairyzan;
@interface TweetDetailTableViewCell : CommonTableViewCell

@property (nonatomic ,retain) modelDairy *modelDairy;
@property (nonatomic, copy) void(^MoreClick)(NSInteger tag, Dairyzan *zan ,BOOL iszan);
@property (nonatomic, copy) void(^CommentReply)(modelDairy *modelDairy ,NSInteger row);
@property (nonatomic, copy) void(^PlayVido)(modelDairy *modelDairy);
@property (strong, nonatomic) UICustomCollectionView *mediaView;
@property (nonatomic, strong) House *house;
- (void)setmodelDairy:(modelDairy *)modelDairy needTopView:(BOOL)needTopView needBottomView:(BOOL)needBottomView;
+ (CGFloat)cellHeightWithObj:(modelDairy *)modelDairy needTopView:(BOOL)needTopView needBottomView:(BOOL)needBottomView;

@end

