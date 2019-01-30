//
//  GBGameCollectionViewCell.h
//  GB_Football
//
//  Created by yahua on 2017/12/15.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GBGamePhotosCellModel;

@interface GBGamePhotoCollectionViewCell : UICollectionViewCell

- (void)refreshWithModel:(GBGamePhotosCellModel *)mode;

@end
