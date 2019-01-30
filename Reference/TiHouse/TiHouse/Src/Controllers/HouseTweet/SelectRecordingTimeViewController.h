//
//  FriendsRangeViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/16.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
#import "HouseTweet.h"

@interface SelectRecordingTimeViewController : BaseViewController

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void(^selectdeTimeBlcok)(NSString *TimeStr ,NSInteger index);
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) HouseTweet *tweet;

@property (nonatomic, strong) NSMutableArray *images;// 用来展示拍摄时间

@end
