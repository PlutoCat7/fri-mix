//
//  GBGameDetailHeaderView.h
//  GB_Football
//
//  Created by 王时温 on 2017/8/16.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchInfo.h"
#import "XXNibBridge.h"

@interface GBGameDetailHeaderView : UIView <XXNibBridge>

- (void)refreshWithMatchInfo:(MatchInfo *)matchInfo;

@end
