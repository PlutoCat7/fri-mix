//
//  FindCloudPhotoCollectionViewCell.h
//  TiHouse
//
//  Created by yahua on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindCloudCellModel.h"

@interface FindCloudPhotoCollectionViewCell : UICollectionViewCell

- (void)refreshWithModel:(FindCloudCellModel *)model;

@end
