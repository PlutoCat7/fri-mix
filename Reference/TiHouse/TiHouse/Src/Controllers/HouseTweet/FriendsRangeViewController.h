//
//  FriendsRangeViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/16.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
#import "HouseTweet.h"
@class Dairy;
@interface FriendsRangeViewController : BaseViewController

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) House *house;
@property (nonatomic, retain) NSArray *friends;
@property (nonatomic, retain) NSArray *selectedFriends;
@property (nonatomic, strong) Dairy *dairy;
@property (nonatomic, strong) HouseTweet *tweet;
@property (nonatomic, copy) void(^selectdeFriendsBlcok)(NSArray *friends ,NSArray *selectedFriends ,NSInteger index);

@end
