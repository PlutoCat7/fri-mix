//
//  FriendsRangeViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/16.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"

@interface FollowingViewController : BaseViewController
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) NSMutableArray *followings;
@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, assign) NSInteger uid;
@end
