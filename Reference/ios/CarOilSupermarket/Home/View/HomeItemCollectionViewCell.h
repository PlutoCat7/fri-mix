//
//  HomeItemCollectionViewCell.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/9.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeResponseInfo.h"

@interface HomeItemCollectionViewCell : UICollectionViewCell

- (void)refreshWithInfo:(HomeCategoryInfo *)info;

@end
