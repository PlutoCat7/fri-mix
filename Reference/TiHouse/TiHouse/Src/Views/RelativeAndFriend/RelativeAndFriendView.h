//
//  RelativeAndFriendView.h
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseView.h"

@interface RelativeAndFriendView : BaseView

@property (nonatomic, copy) void(^inviteCallback)(NSInteger tag);

@end
