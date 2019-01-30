//
//  SelectFriendsViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/16.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
#import "HouseTweet.h"
@class Dairy;

@interface SelectFriendsViewController : BaseViewController

@property (retain, nonatomic) House *house;
@property (nonatomic, retain) NSMutableArray *friends;
@property (nonatomic, retain) NSMutableArray *selectedFriends;
@property (nonatomic, copy) void(^selectdeFriendsBlcok)(NSArray *friends ,NSArray *selectedFriends);
@property (nonatomic, strong) Dairy *dairy;
@property (nonatomic, strong) HouseTweet *tweet;
@end
