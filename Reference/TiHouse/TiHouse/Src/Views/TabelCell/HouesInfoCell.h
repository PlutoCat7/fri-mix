//
//  HouesInfoCell.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/20.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#define kCellIdentifier_HouesInfo @"HouesInfoCell"
#import "CommonTableViewCell.h"
@class Journal;
@interface HouesInfoCell : CommonTableViewCell

@property (nonatomic ,assign) int iamgeconst;
@property (nonatomic ,retain) Journal *journal;
@property (nonatomic ,retain) NSMutableArray *images;
@property (nonatomic ,copy) void(^click)(void);

- (void)setTweet:(Journal *)journal needTopView:(BOOL)needTopView;

+ (CGFloat)cellHeightWithObj:(Journal *)journal needTopView:(BOOL)needTopView;

@end
