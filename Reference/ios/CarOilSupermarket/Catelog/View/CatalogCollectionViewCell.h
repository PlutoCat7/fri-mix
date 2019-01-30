//
//  CatalogCollectionViewCell.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/13.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatalogModel.h"

#define kSubCatalogCellHeight (50*kAppScale)

@class CatalogCollectionViewCell;
@protocol CatalogCollectionViewCellDelegate <NSObject>

- (void)didSelectedWithIndex:(NSInteger)index cell:(CatalogCollectionViewCell *)cell;

@end

@interface CatalogCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<CatalogCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) NSArray<CatalogModel *> *items;

@end
