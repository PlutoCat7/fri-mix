//
//  PhotoFavorTableViewCell.h
//  TiHouse
//
//  Created by weilai on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoulFolderResponse.h"

@interface PhotoFavorTableViewCell : UITableViewCell

- (void)refreshWithSoulFolder:(SoulFolderInfo *)soulFolderInfo;

@end
