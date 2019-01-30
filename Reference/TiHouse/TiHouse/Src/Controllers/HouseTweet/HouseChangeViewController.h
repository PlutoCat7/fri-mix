//
//  HouseChangeViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/15.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
@class HXPhotoManager;


@interface HouseChangeViewController : BaseViewController

@property (strong, nonatomic) HXPhotoManager *manager;
@property (nonatomic, retain) HouseTweet *tweet;
@property (nonatomic, assign) BOOL isEdit; // 判断是否是自己发布的
@property (nonatomic, assign) BOOL isDiary;// 用于判断日记，修改默认记录时间
@property (nonatomic, copy) void(^sendTweet)(HouseTweet *tweet, BOOL isDelete);

@property (nonatomic, assign) BOOL isVideo; // 用于4G环境上传视频限制

@end
