//
//  GBBindPlayerCell.h
//  GB_Team
//
//  Created by weilai on 16/9/27.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MatchBindInfo.h"

@interface GBBindPlayerCell : UITableViewCell

@property (nonatomic, copy) void(^unbindHandler)(PlayerBindInfo *);
@property (nonatomic, copy) void(^checkWristbandHandler)(PlayerBindInfo *);

// 加速搜星状态
@property (nonatomic, assign) STAR_SEARCH_STATE searchState;
// 点击了加速搜星按钮回调，若是重新加速isReset = YES,正常状态为NO
@property (nonatomic, copy) void(^starSearchHandler)(BOOL isReset);

- (void)refreshWithPlayerBindInfo:(PlayerBindInfo *)playerBindInfo selected:(BOOL)selected;
- (void)startSearchWrist;
- (void)stopSearchWrist;

@end
