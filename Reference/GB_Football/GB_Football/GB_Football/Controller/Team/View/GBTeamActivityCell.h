//
//  GBTeamActivityCell.h
//  GB_Football
//
//  Created by gxd on 2017/10/13.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamActivityListResponeInfo.h"

@interface GBTeamActivityCell : UITableViewCell

- (void)refreshWithTeamActivityInfo:(TeamActivityInfo *)teamActivityInfo;

@end
