//
//  OnePictureCell.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol OnePictureCellDelegate;

@class OnePictureViewModel;

@interface OnePictureCell : BaseTableViewCell

@property (nonatomic, strong  ) WebImageView *largeImage;

@end

@protocol OnePictureCellDelegate <NSObject>

- (void)onePictureCell:(OnePictureCell *)cell clickPhotoWithViewModel:(OnePictureViewModel *)viewModel;

@end
