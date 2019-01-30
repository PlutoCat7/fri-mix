//
//  AttendanceCollectionViewCell.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/20.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AttendanceCellModel;

#define kAttendanceCollectionViewCellWidth (50*kAppScale)
#define kAttendanceCollectionViewCellHeight (50*kAppScale)

@interface AttendanceCollectionViewCell : UICollectionViewCell

- (void)refreshWithModel:(AttendanceCellModel *)model;

@end
