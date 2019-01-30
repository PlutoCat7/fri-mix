//
//  HouesInfoCell.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/20.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#define kCellIdentifier_HouesInfo @"MoreTweetCell"
#import "CommonTableViewCell.h"
#import "HouseTweet.h"
@interface HouseMoreTweetTableViewCell : CommonTableViewCell

@property (nonatomic ,retain) HouseTweet *tweet;


@property (nonatomic, retain) UIViewController *controller;
@property (nonatomic, retain) NSIndexPath *indexPath;

@property (nonatomic, copy)void(^deletePhotoCallback)();
+ (CGFloat)cellHeightWithObj:(HouseTweet *)tweet needTopView:(BOOL)needTopView;


@end
