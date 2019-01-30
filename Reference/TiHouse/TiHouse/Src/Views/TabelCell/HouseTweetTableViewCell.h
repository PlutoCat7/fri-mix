//
//  HouseTweetTableViewCell.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/18.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"
@class HouseTweet;
@interface HouseTweetTableViewCell : CommonTableViewCell

@property (nonatomic, retain) HouseTweet *tweet;

+(CGFloat)getCellHeightWith:(HouseTweet *)tweet;

@end
