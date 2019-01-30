//
//  ItemTableViewCell.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/17.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTableViewCell.h"
#import "ItemModel.h"

@interface ItemTableViewCell : CommonTableViewCell

@property (nonatomic, retain) id model;
@property (nonatomic ,retain) UILabel *Title;

@end
