//
//  ThreePictureCell.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseTableViewCell.h"

@class ThreePictureViewModel;

@protocol ThreePictureCellDelegate;

@interface ThreePictureCell : BaseTableViewCell

@property (nonatomic, strong  ) WebImageView *leftImageView;
@property (nonatomic, strong  ) WebImageView *centerImageView;
@property (nonatomic, strong  ) WebImageView *rightImageView;

@end

@protocol ThreePictureCellDelegate <NSObject>

- (void)threePictureCell:(ThreePictureCell *)cell clickLeftImageWithViewModel:(ThreePictureViewModel *)viewModel;

- (void)threePictureCell:(ThreePictureCell *)cell clickCenterImageWithViewModel:(ThreePictureViewModel *)viewModel;

- (void)threePictureCell:(ThreePictureCell *)cell clickRightImageWithViewModel:(ThreePictureViewModel *)viewModel;

@end
