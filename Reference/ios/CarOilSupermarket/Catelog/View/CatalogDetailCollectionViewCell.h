//
//  CatalogDetailCollectionViewCell.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/10.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeResponseInfo.h"

#define kCatalogDetailCollectionViewCellWidth (184.5f*kAppScale)
#define kCatalogDetailCollectionViewCellHeight (229.f*kAppScale)

@interface CatalogDetailCollectionViewCell : UICollectionViewCell

- (void)refreshWithData:(HomeGoodsInfo *)goodInfo;

@end
