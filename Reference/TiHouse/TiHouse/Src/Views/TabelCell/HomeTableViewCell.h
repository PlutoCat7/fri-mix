//
//  HomeTableViewCell.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/15.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"
#import <MGSwipeTableCell.h>
@class House;

@interface HomeTableViewCell : MGSwipeTableCell

@property (nonatomic, retain) House *house;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, assign) float leftFreeSpace;
@property (nonatomic, assign) float rightFreeSpace;

@property (nonatomic, assign) CellLineStyle bottomLineStyle;
@property (nonatomic, assign) CellLineStyle topLineStyle;

@end
