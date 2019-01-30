//
//  HouseChangeViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/15.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
@class HXPhotoManager;
@interface HouseMoveTweetViewController : BaseViewController

@property (nonatomic, retain) NSMutableArray *tweets;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (nonatomic, copy) void(^sendTweet)(NSArray *tweets);

@end
