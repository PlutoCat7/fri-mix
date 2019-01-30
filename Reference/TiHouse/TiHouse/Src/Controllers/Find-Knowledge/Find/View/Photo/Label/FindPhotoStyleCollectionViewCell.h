//
//  FindPhotoStyleCollectionViewCell.h
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFindPhotoStyleCollectionViewCellHeight kRKBWIDTH(30)

@interface FindPhotoStyleCollectionViewCell : UICollectionViewCell

- (void)refreshWithName:(NSString *)name isSelect:(BOOL)isSelect;

@end
