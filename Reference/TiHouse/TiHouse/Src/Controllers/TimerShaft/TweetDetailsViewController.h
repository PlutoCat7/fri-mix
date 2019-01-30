//
//  TweetDetailsViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
#import "modelDairy.h"
#import "House.h"
@interface TweetDetailsViewController : BaseViewController

@property (nonatomic, retain) modelDairy *modelDairy;
@property (nonatomic, retain) House *house;
@property (nonatomic, copy) void(^relodaDataCallback)(void);
@property (nonatomic, assign) long dairyid;
@property (nonatomic, assign) BOOL isAllComment;
@end
