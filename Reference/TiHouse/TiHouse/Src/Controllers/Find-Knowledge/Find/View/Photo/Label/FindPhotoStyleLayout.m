//
//  FindPhotoStyleLayout.m
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoStyleLayout.h"

@interface  FindPhotoStyleLayout ()

@property (nonatomic, strong) NSMutableArray* attrArray;

@end

@implementation FindPhotoStyleLayout

- (NSMutableArray *)attrArray
{
    if (!_attrArray) {
        _attrArray = [NSMutableArray array];
        
    }
    return _attrArray;
}

- (void)prepareLayout{
    [super prepareLayout];

    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0 ; i < count; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes* attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrArray addObject:attr];
    }
    
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *layoutAttribute = [super layoutAttributesForItemAtIndexPath:indexPath];
    if (layoutAttribute.frame.origin.x <= self.sectionInset.left) {
        return layoutAttribute;
    }
    
    NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
    UICollectionViewLayoutAttributes *previousLayoutAttribute = [self layoutAttributesForItemAtIndexPath:previousIndexPath];
    CGRect frame = layoutAttribute.frame;
    frame.origin.x = CGRectGetMaxX(previousLayoutAttribute.frame)+self.minimumInteritemSpacing;
    layoutAttribute.frame = frame;
    return layoutAttribute;
    
}

- (CGFloat)getHeightWithLabelList:(NSArray *)labelList font:(UIFont *)labelFont {
    
    CGFloat height = _caculateRowHeight;
    CGFloat right = self.sectionInset.left;
    for(NSString *label in labelList) {
        CGFloat width = [label getWidthWithFont:labelFont constrainedToSize:CGSizeMake(200, 200)];
        right += _caculateLeftRightPadding + width + _caculateLeftRightPadding;
        if (right>_caculateLimitWidth-self.sectionInset.right) {
            right = self.sectionInset.left + _caculateLeftRightPadding + width + _caculateLeftRightPadding;
            height += _caculateRowHeight;
        }
        right += self.minimumInteritemSpacing;
    }
    
    return height;
}

@end
