//
//  GBPlayerRankCell.h
//  GB_Football
//
//  Created by gxd on 2017/11/30.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerRankResponeInfo.h"

@interface GBPlayerRankCell : UITableViewCell

- (void)initWithPlayerRankInfo:(PlayerRankInfo *)playerRankInfo type:(PlayerRank)type index:(NSInteger)index;

@end
