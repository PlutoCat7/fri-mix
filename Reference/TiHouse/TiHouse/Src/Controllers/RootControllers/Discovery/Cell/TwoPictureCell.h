//
//  TwoPictureCell.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseTableViewCell.h"

@class TwoPictureViewModel;

@protocol TwoPictureCellDelegate;

@interface TwoPictureCell : BaseTableViewCell

@property (nonatomic, strong  ) WebImageView *leftImageView;
@property (nonatomic, strong  ) WebImageView *rightImageView;

@end

@protocol TwoPictureCellDelegate <NSObject>

- (void)twoPictureCell:(TwoPictureCell *)cell clickLeftImageWithViewModel:(TwoPictureViewModel *)viewModel;

- (void)twoPictureCell:(TwoPictureCell *)cell clickRightImageWithViewModel:(TwoPictureViewModel *)viewModel;

@end
