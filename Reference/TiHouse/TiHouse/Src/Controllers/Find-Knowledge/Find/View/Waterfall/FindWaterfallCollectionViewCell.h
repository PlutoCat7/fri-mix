//
//  FindWaterfallCollectionViewCell.h
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFindWaterfallCollectionViewCellTextHeight kRKBWIDTH(40)

@class FindWaterfallModel;
@interface FindWaterfallCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void (^clickZanBlock)(FindWaterfallModel * model);

- (void)refreshWithModel:(FindWaterfallModel *)model;

- (void)refreshWithLikeCount:(NSInteger)likeCount isLike:(BOOL)isLike;

@end
