//
//  HomeAssemCollectionViewCell.h
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindAssemActivityInfo.h"
@interface HomeAssemCollectionViewCell : UICollectionViewCell

- (void)refreshWithInfo:(FindAssemActivityInfo *)info;

@end
