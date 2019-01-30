//
//  HouseChangeViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/15.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
#import "Dairy.h"
@class HXPhotoManager;


@interface HouseTweetEditViewController : BaseViewController

@property (strong, nonatomic) HXPhotoManager *manager;
@property (nonatomic, retain) HouseTweet *tweet;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) Dairy *dairy;

@property (nonatomic, copy) void(^sendTweet)(HouseTweet *tweet, BOOL isDelete);
@property (nonatomic, copy) void(^deleteCallback)(void);

@end
