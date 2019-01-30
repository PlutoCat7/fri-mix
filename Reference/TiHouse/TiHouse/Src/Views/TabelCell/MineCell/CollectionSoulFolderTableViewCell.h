//
//  CollectionSoulFolderTableViewCell.h
//  TiHouse
//
//  Created by admin on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//


#import "CommonTableViewCell.h"
#import "SoulFolder.h"

@interface CollectionSoulFolderTableViewCell : CommonTableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) SoulFolder *soulfolder;
@end

