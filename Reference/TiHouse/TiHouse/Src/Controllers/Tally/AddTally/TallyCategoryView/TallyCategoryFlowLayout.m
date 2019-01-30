//
//  TallyCategoryFlowLayout.m
//  TiHouse
//
//  Created by AlienJunX on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TallyCategoryFlowLayout.h"

@interface TallyCategoryFlowLayout()
@property (nonatomic) CGSize contentSize;
@property (nonatomic, strong) NSArray<NSArray<UICollectionViewLayoutAttributes *> *> *itemFrames;
@end

@implementation TallyCategoryFlowLayout

- (void)prepareLayout {
    _itemFrames = nil;
    _contentSize = CGSizeZero;
    [super prepareLayout];
    
    id<TallyCategoryFlowLayoutDelegate> delegate = nil;
    if ([self.collectionView.delegate conformsToProtocol:@protocol(TallyCategoryFlowLayoutDelegate)]) {
        delegate = (id<TallyCategoryFlowLayoutDelegate>)self.collectionView.delegate;
    }
    if (!delegate) {
        return;
    }
    id<UICollectionViewDataSource> dataSource = self.collectionView.dataSource;
    if (!dataSource) {
        return;
    }
    
    NSMutableArray *itemFrames = [NSMutableArray array];
    CGFloat x = 0,y = 0;
    
    UICollectionViewLayoutAttributes *prevLayoutAttributes = nil;
    NSInteger sections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < sections; section++) {
        UIEdgeInsets sectionEdgeInsets = self.sectionInset;
        
        y += sectionEdgeInsets.top;
        x = sectionEdgeInsets.left;
        
        // items
        NSInteger items = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *itemsArray = [NSMutableArray array];
        for (NSInteger item = 0; item < items; item++) {
            CGSize itemSize = [delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
            
            CGRect frame = CGRectMake(x, y, itemSize.width, itemSize.height);
            
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
            if (prevLayoutAttributes != nil) {
                // 间距
                NSInteger maximumSpacing = self.minimumInteritemSpacing;

                // 前一个cell的最右边
                NSInteger prevOrigin = CGRectGetMaxX(prevLayoutAttributes.frame);
                // 需要做偏移
                if(prevOrigin + maximumSpacing + itemSize.width <= self.collectionView.frame.size.width - sectionEdgeInsets.right) {
                    if (attributes.indexPath.section == prevLayoutAttributes.indexPath.section) {
                        x = prevOrigin + maximumSpacing;
                        frame.origin.x = x;
                    }
                } else {
                    CGFloat lineSpacing = self.minimumLineSpacing;
                    y += itemSize.height + lineSpacing;
                    x = sectionEdgeInsets.left;
                    
                    frame = CGRectMake(x, y, itemSize.width, itemSize.height);
                }
            }
            
            attributes.frame = frame;
            
            [itemsArray addObject:attributes];
            
            prevLayoutAttributes = attributes;
            
            if (item == items - 1) {
                y += itemSize.height + sectionEdgeInsets.bottom;
            }
        }
        
        [itemFrames addObject:itemsArray];
    }
    
    _itemFrames = [itemFrames copy];
    _contentSize = CGSizeMake(self.collectionView.bounds.size.width, y);
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSArray *tempArr in self.itemFrames) {
        for (UICollectionViewLayoutAttributes *attributes in tempArr) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [arr addObject:attributes];
            }
        }
    }
    return arr;
}

@end
