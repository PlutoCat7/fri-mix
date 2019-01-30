//
//  ZXCategorySliderBar.m
//  ZXCollectionSliderBar
//
//  Created by anphen on 2017/4/18.
//  Copyright © 2017年 anphen All rights reserved.
//

#import "ZXCategorySliderBar.h"
#import "ZXCategoryItemView.h"

CGFloat itemInteval = 29;

NSString *const RESETCOLORNOTIFICATION = @"RESETCOLORNOTIFICATION";

@implementation UIView(ZXExtension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

@end


@interface ZXCategorySliderBar()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *itemWidthArray;
@property (nonatomic, strong) NSMutableArray *itemOriginXArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGFloat lastContentOffsetX;
@property (nonatomic, assign) BOOL isOutScreen;

@end

@implementation ZXCategorySliderBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self setUpUI];
    }
    return self;
}

- (void)commonInit{
    _originIndex = 0;
    _currentIndex = 0;
    _itemOriginXArray = [[NSMutableArray alloc]init];
    _itemWidthArray = [[NSMutableArray alloc]init];
    _isMoniteScroll = NO;
    _lastContentOffsetX = 0;
    _isOutScreen = NO;
}

- (void)setUpUI{
    [self addSubview:self.mainCollectionView];
}

- (void)setSelectIndex:(NSInteger)index{
    self.currentIndex = index;
    [self adjustContentOffsetToIndex:index completeHanle:^{
        ZXCategoryItemView *itemView = (ZXCategoryItemView *)[self.mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        itemView.contentLabel.textColor = kTitleAddHouseTitleCOLOR;
        NSNotification *notification = [[NSNotification alloc]initWithName:RESETCOLORNOTIFICATION object:@"color" userInfo:@{@"color":kTitleAddHouseTitleCOLOR,@"index":@(self.currentIndex)}];
        [[NSNotificationCenter defaultCenter]postNotification:notification];

    } animation:YES];
}

- (void)setOriginIndex:(NSInteger)originIndex
{
    _originIndex = originIndex;
    _currentIndex = originIndex;
}

- (void)setMoniterScrollView:(UIScrollView *)moniterScrollView
{
    _moniterScrollView = moniterScrollView;
    _lastContentOffsetX = self.originIndex * moniterScrollView.width;
}

- (void)adjustIndicateViewX:(UIScrollView *)scrollView direction:(NSString *)direction{
    if (!self.isMoniteScroll) {
        return;
    }
    CGFloat nextWitdth = 0.0;
    CGFloat nextOriginX = 0.0 ;
    if ([direction isEqualToString:@"向右"]) {
        NSInteger index = scrollView.contentOffset.x / scrollView.width + 1;
        if (index >= self.itemArray.count || index < 0) {
            return;
        }
        CGFloat currentWidth = [self.itemWidthArray[index] floatValue];
        CGFloat currentOriginX = [self.itemOriginXArray[index] floatValue];
        if (index -1 < 0) {
            return;
        }
        nextWitdth = [self.itemWidthArray[index - 1] floatValue];
        nextOriginX = [self.itemOriginXArray[index - 1] floatValue];
        //改变X
        CGFloat originDistance = nextOriginX - currentOriginX;
        CGFloat distance = scrollView.contentOffset.x - _lastContentOffsetX;
        [self.indicateView setX:self.indicateView.x - originDistance/scrollView.width *distance];
        //改变宽度
        CGFloat widthDistance = nextWitdth - currentWidth;
        [self.indicateView setWidth:self.indicateView.width - distance/scrollView.width * widthDistance];
         _lastContentOffsetX = scrollView.contentOffset.x;
        if (_lastContentOffsetX == self.scrollViewLastContentOffset) {
            return;
        }
        //改变颜色
        ZXCategoryItemView *view = [self getItemViewAtIndex:index];
        view.contentLabel.textColor = [self changeRGB:view.contentLabel.textColor changeValue:distance/scrollView.width];
        
        ZXCategoryItemView * nextView = [self getItemViewAtIndex:index-1];
        nextView.contentLabel.textColor = [self changeRGB:nextView.contentLabel.textColor changeValue:-distance/scrollView.width];

    }
    if ([direction isEqualToString:@"向左"]) {
        NSInteger index = scrollView.contentOffset.x / scrollView.width;
        if (index >= self.itemArray.count || index < 0) {
            return;
        }
        CGFloat currentWidth = [self.itemWidthArray[index] floatValue];
        CGFloat currentOriginX = [self.itemOriginXArray[index] floatValue];

        if (index + 1 == self.itemArray.count) {
            return;
        }
        nextWitdth = [self.itemWidthArray[index + 1] floatValue];
        nextOriginX = [self.itemOriginXArray[index + 1] floatValue];
        //改变x
        CGFloat originDistance = nextOriginX - currentOriginX;
        CGFloat distance = scrollView.contentOffset.x - _lastContentOffsetX;
        [self.indicateView setX:self.indicateView.x + originDistance/scrollView.width *distance];
        //改变宽度
        CGFloat widthDistance = nextWitdth - currentWidth;
        [self.indicateView setWidth:self.indicateView.width + distance/scrollView.width * widthDistance];
        _lastContentOffsetX = scrollView.contentOffset.x;
        if (_lastContentOffsetX == self.scrollViewLastContentOffset) {
            return;
        }
        //改变颜色
        ZXCategoryItemView *view = [self getItemViewAtIndex:index];
        view.contentLabel.textColor = [self changeRGB:view.contentLabel.textColor changeValue:-distance/scrollView.width];

        ZXCategoryItemView * nextView = [self getItemViewAtIndex:index + 1];;
        nextView.contentLabel.textColor = [self changeRGB:nextView.contentLabel.textColor changeValue:distance/scrollView.width];
    }
}

- (ZXCategoryItemView *)getItemViewAtIndex:(NSInteger )index{
    ZXCategoryItemView *view = (ZXCategoryItemView *)[self.mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return view;
}

- (UIColor *)changeRGB:(UIColor *)color changeValue:(CGFloat)value{
    NSArray *nextViewRgbArray = [self getRGBWithColor:color];
    color = [UIColor colorWithRed:[nextViewRgbArray[0] doubleValue] + value green:[nextViewRgbArray[1] doubleValue] blue:[nextViewRgbArray[2] doubleValue] alpha:[nextViewRgbArray[3] doubleValue]];
    return color;
}

#pragma mark - getters and setters

- (UIView *)indicateView
{
    if (!_indicateView) {
        _indicateView = [[UIView alloc]initWithFrame:CGRectMake([self.itemOriginXArray[_originIndex] floatValue], self.height - 4, [self.itemWidthArray [_originIndex] floatValue], 4)];
        _indicateView.backgroundColor = kTiMainBgColor;
        _indicateView.layer.cornerRadius = 2.f;
    }
    return _indicateView;
}


- (void)setItemArray:(NSArray *)itemArray{
    _itemArray = itemArray;
    [self.itemOriginXArray removeAllObjects];
    [self.itemWidthArray removeAllObjects];
    [self initItemWidthArray];
    [self.mainCollectionView addSubview:self.indicateView];
    [self.mainCollectionView reloadData];
    [self adjustContentOffsetToIndex:self.originIndex completeHanle:nil animation:NO];
    if ([self.delegate respondsToSelector:@selector(didSelectedIndex:)]) {
        [self.delegate didSelectedIndex:self.originIndex];
    }
}

- (void)initItemWidthArray{
    CGFloat originX = itemInteval;
    for (int i = 0; i< self.itemArray.count; i++) {
        NSString *item;
        if (i == 0) {
            item = [NSString stringWithFormat:@" %@",self.itemArray[i]];
        }else{
            item = self.itemArray[i];
        }
        
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15 weight:15]};
        CGSize textSize = [item sizeWithAttributes:attributes];
        CGFloat currentOriginX = originX;
        [self.itemOriginXArray addObject:@(currentOriginX)];
        [self.itemWidthArray addObject:@(textSize.width)];
        originX = originX + textSize.width + itemInteval;
    }
    if (originX > self.frame.size.width) {
        _isOutScreen = YES;
        self.mainCollectionView.scrollEnabled = YES;
    }
    else{
        _isOutScreen = NO;
        self.mainCollectionView.scrollEnabled = NO;
    }
}

- (UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:self.flowLayout];
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.bounces = NO;
        [_mainCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXCategoryItemView class]) bundle:nil] forCellWithReuseIdentifier:@"ZXCategoryItemViewIdentifier"];
        _mainCollectionView.backgroundColor = XWColorFromHex(0xfcfcfc);
    }
    return _mainCollectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 29;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 29, 0, 29);
    }
    return _flowLayout;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXCategoryItemView *cell = (ZXCategoryItemView *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ZXCategoryItemViewIdentifier" forIndexPath:indexPath];
    cell.contentLabel.text = self.itemArray[indexPath.row];
    cell.index = indexPath.row;
    if (indexPath.row == self.currentIndex) {
        cell.contentLabel.font = [UIFont systemFontOfSize:14 weight:20];
    }
    else{
        cell.contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize itemSize = CGSizeMake([self.itemWidthArray[indexPath.row]floatValue], self.frame.size.height);
    return itemSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _isMoniteScroll = NO;
    _lastContentOffsetX = self.moniterScrollView.width * indexPath.row;
    NSNotification *notification = [[NSNotification alloc]initWithName:RESETCOLORNOTIFICATION object:@"color" userInfo:@{@"color":kTitleAddHouseTitleCOLOR,@"index":@(indexPath.row)}];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    ZXCategoryItemView *cell = (ZXCategoryItemView *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentLabel.font = [UIFont systemFontOfSize:14 weight:20];
    _currentIndex = indexPath.row;
    [self adjustContentOffsetToIndex:indexPath.row completeHanle:^{
    } animation:YES];
    if ([self.delegate respondsToSelector:@selector(didSelectedIndex:)]) {
        [self.delegate didSelectedIndex:indexPath.row];
    }
}

- (void)adjustContentOffsetToIndex:(NSInteger)index completeHanle:(void(^)())completeHandle animation:(BOOL)animation{
    CGFloat maxContentOffsetX = [[self.itemOriginXArray lastObject]floatValue] + [[self.itemWidthArray lastObject] floatValue] + itemInteval - self.frame.size.width;
    if (index >= self.itemArray.count||index < 0) {
        return;
    }
    CGFloat indexCenterOffsetX = [self.itemOriginXArray[index] floatValue] + [self.itemWidthArray[index] floatValue]*0.5 - self.frame.size.width * 0.5;
    if (indexCenterOffsetX > maxContentOffsetX) {
        [self scrollToPoint:CGPointMake(maxContentOffsetX, 0) CompleteHandle:completeHandle animation:animation];
    }
    else if (indexCenterOffsetX <= 0)
    {
        [self scrollToPoint:CGPointMake(0, 0) CompleteHandle:completeHandle animation:animation];
    }
    else{
        [self scrollToPoint:CGPointMake(indexCenterOffsetX, 0) CompleteHandle:completeHandle animation:animation];
    }
    
}

- (void)scrollToPoint:(CGPoint)point CompleteHandle:(void(^)())completeHandle animation:(BOOL)animation{
    if (animation) {
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.isOutScreen?[weakSelf.mainCollectionView setContentOffset:point]:nil;
            [weakSelf.indicateView setWidth:[self.itemWidthArray[self.currentIndex] floatValue]];
            [weakSelf.indicateView setX:[self.itemOriginXArray[self.currentIndex]floatValue]];
            
        }completion:^(BOOL finished) {
            if (completeHandle) {
                completeHandle();
            }
        }];

    }else{
        self.isOutScreen ? [self.mainCollectionView setContentOffset:point]:nil;
        [self.indicateView setWidth:[self.itemWidthArray[self.currentIndex] floatValue]];
        [self.indicateView setX:[self.itemOriginXArray[self.currentIndex]floatValue]];
        if (completeHandle) {
            completeHandle();
        }
    }
}

- (NSArray *)getRGBWithColor:(UIColor *)color
{
    double red = 0.0;
    double green = 0.0;
    double blue = 0.0;
    double alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return @[@(red), @(green), @(blue), @(alpha)];
}

@end
