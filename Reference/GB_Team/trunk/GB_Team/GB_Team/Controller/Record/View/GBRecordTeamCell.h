//
//  GBRecordTeamCell.h
//  GB_Team
//
//  Created by Pizza on 16/9/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchRecordResponseInfo.h"

@interface GBRecordTeamCell : UITableViewCell

- (void)refreshWithMatchRecordInfo:(MatchRecordInfo *)recordInfo;

@end
