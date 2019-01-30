//
//  FollowTableViewCell.h
//  TiHouse
//
//  Created by admin on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "FSCustomButton.h"
#import "User.h"

@interface FollowTableViewCell : CommonTableViewCell
@property (nonatomic, strong) FSCustomButton *followBtn;
@property (nonatomic, strong) FSCustomButton *followedBtn;
@property (nonatomic, retain) User *user;
@property (nonatomic) BOOL isBtnShow;
@end
