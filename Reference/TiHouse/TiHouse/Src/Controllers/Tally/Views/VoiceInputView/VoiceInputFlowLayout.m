//
//  MyFlowLayout.m
//  Demo2018
//
//  Created by AlienJunX on 2018/1/31.
//  Copyright © 2018年 AlienJunX. All rights reserved.
//

#import "VoiceInputFlowLayout.h"

@interface VoiceInputFlowLayout()
@end

@implementation VoiceInputFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGFloat centerY = self.collectionView.contentOffset.y + 100 * 0.5;

    for (UICollectionViewLayoutAttributes *attrs in array) {
        // cell的中心点x 和 collectionView最中心点的x值 的间距
//        CGFloat delta = ABS(attrs.center.y - centerY);

        // 根据间距值 计算 cell的缩放比例
        CGFloat scale = 1;// - delta / 100;
        // 设置缩放比例
        attrs.transform = CGAffineTransformMakeScale(scale, scale);

    }
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
