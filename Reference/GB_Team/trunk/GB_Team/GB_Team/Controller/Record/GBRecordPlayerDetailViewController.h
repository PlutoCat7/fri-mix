//
//  GBRecordPlayerDetailViewController.h
//  GB_Team
//
//  Created by Pizza on 16/9/20.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"
#import "MatchDetailResponseInfo.h"

@interface GBRecordPlayerDetailViewController : GBBaseViewController

- (instancetype)initWithMatchPlayer:(MatchPlayerInfo *)playerInfo matchInfo:(MatchMessInfo *)matchInfo;

@end
