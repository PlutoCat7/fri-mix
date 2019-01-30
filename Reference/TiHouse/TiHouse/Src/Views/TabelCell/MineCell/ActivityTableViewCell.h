//
//  ActivityTableViewCell.h
//  TiHouse
//
//  Created by admin on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "AssemarcModel.h"

@interface ActivityTableViewCell : CommonTableViewCell
@property (nonatomic, retain) NSMutableDictionary *activity;
@property (nonatomic, retain) AssemarcModel *assemarc;
@end
