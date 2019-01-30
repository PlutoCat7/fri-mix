//
//  LookTransformViewCell.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"

@interface LookTransformViewCell : CommonTableViewCell

@property (nonatomic, retain) NSMutableArray *models;

+(CGFloat)getCellHeight:(NSArray *)arr;

@end
