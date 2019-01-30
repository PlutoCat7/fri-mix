//
//  FindPhotoStyleLayout.h
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindPhotoStyleLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat caculateLimitWidth;
@property (nonatomic, assign) CGFloat caculateLeftRightPadding;
@property (nonatomic, assign) CGFloat caculateRowHeight;

- (CGFloat)getHeightWithLabelList:(NSArray *)labelList font:(UIFont *)labelFont;

@end
