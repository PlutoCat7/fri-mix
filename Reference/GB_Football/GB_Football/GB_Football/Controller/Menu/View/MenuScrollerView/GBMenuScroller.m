//
//  GBMenuScroller.m
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/7/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBMenuScroller.h"
#import "UIImage+RTTint.h"

#define kBaseTag 100
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kItemSpacing 40.0f
#define kItemWidth  55.0f
#define kItemHeight 84.0f
#define kItemSelectedWidth  65.0f
#define kItemSelectedHeight 100.0f
#define kScrollViewContentOffset (kScreenWidth / 2.0 - (kItemWidth / 2.0 + kItemSpacing))

@interface GBMenuScroller()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView   *scrollView;

@property (nonatomic, strong) NSMutableArray<NSString*> *imageNames;
@property (nonatomic, assign) NSInteger      currentIndex;
@property (nonatomic, strong) NSMutableArray<UIImageView*> *itemsImageViews;

@end

@implementation GBMenuScroller

- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames currentIndex:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageNames = [imageNames mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addSubImageViewsToScrollView];
            [self setCurrentMovieIndex:index animated:NO];
        });
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.height);
}

#pragma mark - Public

// 修改内部图片接口
- (void)setupIcons:(NSArray<NSString*>*)imageNames
{
    if (self.currentIndex >= [imageNames count]) {
        self.currentIndex = [imageNames count] -1;
    }
    self.imageNames = [imageNames mutableCopy];
    [self addSubImageViewsToScrollView];
    [self setCurrentIndex:self.currentIndex];
    [self adjustSubviews];
}

- (void)setImageName:(NSString*)imageName currentIndex:(NSInteger)index
{
    for (int i = 0 ; i < [self.imageNames count]; i++)
    {
        if (index == i)
        {
            self.imageNames[i] = imageName;
            UIImageView *item = self.itemsImageViews[index];
            item.image = [UIImage imageNamed:imageName];
            [self setCurrentIndex:self.currentIndex];
            [self adjustSubviews];
            break;
        }
    }
}

- (void)setCurrentMovieIndex:(NSInteger)index animated:(BOOL)animated {
    
    if (index >= 0 && index < self.imageNames.count) {
        CGPoint point = CGPointMake((kItemSpacing + kItemWidth) * index - kScrollViewContentOffset, 0);
        [self.scrollView setContentOffset:point animated:animated];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = (scrollView.contentOffset.x + kScrollViewContentOffset + (kItemWidth / 2 + kItemSpacing / 2)) / (kItemWidth + kItemSpacing);
    index = MIN(self.imageNames.count - 1, MAX(0, index));
    if (self.currentIndex != index) {
        self.currentIndex = index;
    }
    [self adjustSubviews];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSInteger index = (targetContentOffset->x + kScrollViewContentOffset + (kItemWidth / 2 + kItemSpacing / 2)) / (kItemWidth + kItemSpacing);
    targetContentOffset->x =  (NSInteger)((kItemSpacing + kItemWidth) * index - kScrollViewContentOffset);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self resetImagView:scrollView];
    if ([self.delegate respondsToSelector:@selector(menuScroller:didEndScrollingAtIndex:)]) {
        [self.delegate menuScroller:self didEndScrollingAtIndex: self.currentIndex];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self resetImagView:scrollView];
    if ([self.delegate respondsToSelector:@selector(menuScroller:didEndScrollingAtIndex:)]) {
        [self.delegate menuScroller:self didEndScrollingAtIndex:self.currentIndex];
    }
}

#pragma mark - Action

- (void)tapDetected:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.view.tag == self.currentIndex + kBaseTag) {
        if ([self.delegate respondsToSelector:@selector(menuScroller:didSelectItemAtIndex:)]) {
            [self.delegate menuScroller:self didSelectItemAtIndex:self.currentIndex];
        }
    }
    // 点击跳转
    CGPoint point = [tapGesture.view.superview convertPoint:tapGesture.view.center toView:self.scrollView];
    NSInteger index = (point.x) / (kItemWidth + kItemSpacing);
    [self setCurrentMovieIndex:index animated:YES];
}

#pragma mark - Private

-(void)resetImagView:(UIScrollView *)scrollView
{
    NSInteger index = self.currentIndex;
    index = MIN(self.imageNames.count - 1, MAX(0, index));
    for (int i = 0; i< [self.imageNames count] ;i++)
    {
        UIImageView *item = self.itemsImageViews[i];
        if (item.tag != index + kBaseTag)
        {
            item.image = [UIImage imageNamed:self.imageNames[i]];
        }
    }
}

-(void)addSubImageViewsToScrollView
{
    if (self.imageNames.count == 0) {
        return;
    }
    NSArray *subViews = [self.scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    self.scrollView.contentSize = CGSizeMake((kItemWidth + kItemSpacing) * self.imageNames.count + kItemSpacing, self.scrollView.height);
    NSLog(@"%f",self.scrollView.height);
    NSInteger i = 0;
    self.itemsImageViews = [NSMutableArray array];
    for (NSString *imageName in self.imageNames)
    {
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake((kItemSpacing + kItemWidth) * i + kItemSpacing, (kMenuScrollerHeight - kItemHeight)+[self postionYForResize], kItemWidth, kItemHeight)];
        [self.scrollView addSubview:itemView];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:itemView.bounds];
        [imageView setImage:[UIImage imageNamed:imageName]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i + kBaseTag;
        [itemView addSubview:imageView];
        [self.itemsImageViews addObject:imageView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
        [imageView addGestureRecognizer:tapGesture];
        i++;
    }
}

- (void)adjustSubviews
{
    NSInteger index = (self.scrollView.contentOffset.x + kScrollViewContentOffset) / (kItemWidth + kItemSpacing);
    index = MIN(self.imageNames.count - 1, MAX(0, index));
    
    for (UIImageView *imgView in self.itemsImageViews)
    {
        if (imgView.tag != index + kBaseTag && imgView.tag != (index + kBaseTag + 1))
        {
            imgView.frame = CGRectMake(0, 0, kItemWidth, kItemHeight);
            imgView.image = [UIImage imageNamed:self.imageNames[imgView.tag-kBaseTag]];
        }
    }
    
    CGFloat scale = (self.scrollView.contentOffset.x + kScrollViewContentOffset - (kItemWidth + kItemSpacing) * index) / (kItemWidth + kItemSpacing);
    if (self.imageNames.count > 0)
    {
        CGFloat height;
        CGFloat width;
        
        if (scale < 0.0)
        {
            scale = 1 - MIN(1.0, ABS(scale));
            UIImageView *imgView = self.itemsImageViews[index];
            imgView.image = [[UIImage imageNamed:self.imageNames[index]] rt_tintedImageWithColor:[UIColor greenColor] level:scale];
            height = kItemHeight + (kItemSelectedHeight - kItemHeight) * scale;
            width = kItemWidth + (kItemSelectedWidth - kItemWidth) * scale;
            imgView.frame = CGRectMake(-(width - kItemWidth) / 2, -(height - kItemHeight), width, height);
            
            UIImageView *rightView = self.itemsImageViews[index + 1];
            rightView.frame = CGRectMake(0, 0, kItemWidth, kItemHeight);
            rightView.image = [[UIImage imageNamed:self.imageNames[index+1]] rt_tintedImageWithColor:[UIColor greenColor] level:0];
        }
        else if (scale>=0.0 && scale <= 1.0)
        {
            if (index + 1 >= self.imageNames.count)
            {
                scale = 1 - MIN(1.0, ABS(scale));
                UIImageView *imgView = self.itemsImageViews[self.imageNames.count - 1];
                imgView.image = [[UIImage imageNamed:self.imageNames[index]] rt_tintedImageWithColor:[UIColor greenColor] level:scale];
                height = kItemHeight + (kItemSelectedHeight - kItemHeight) * scale;
                width = kItemWidth + (kItemSelectedWidth - kItemWidth) * scale;
                imgView.frame = CGRectMake(-(width - kItemWidth) / 2, -(height - kItemHeight), width, height);
            }
            else
            {
                CGFloat scaleLeft = 1 - MIN(1.0, ABS(scale));
                UIImageView *leftView = self.itemsImageViews[index];
                leftView.image = [[UIImage imageNamed:self.imageNames[index]] rt_tintedImageWithColor:[UIColor greenColor] level:scaleLeft];
                height = kItemHeight + (kItemSelectedHeight - kItemHeight) * scaleLeft;
                width = kItemWidth + (kItemSelectedWidth - kItemWidth) * scaleLeft;
                leftView.frame = CGRectMake(-(width - kItemWidth) / 2, -(height - kItemHeight), width, height);
                
                CGFloat scaleRight = MIN(1.0, ABS(scale));
                UIImageView *rightView = self.itemsImageViews[index + 1];
                rightView.image = [[UIImage imageNamed:self.imageNames[index+1]] rt_tintedImageWithColor:[UIColor greenColor] level:scaleRight];
                height = kItemHeight + (kItemSelectedHeight - kItemHeight) * scaleRight;
                width = kItemWidth + (kItemSelectedWidth - kItemWidth) * scaleRight;
                rightView.frame = CGRectMake(-(width - kItemWidth) / 2, -(height - kItemHeight), width, height);
            }
        }
    }
}

// 用于微调位置，机型适配
-(CGFloat)postionYForResize
{
    if (IS_IPHONE4) {
        return (440.f/1334)*[UIScreen mainScreen].bounds.size.height - self.top;
    }
    else if(IS_IPHONE5){
        return (475.f/1334)*[UIScreen mainScreen].bounds.size.height - self.top;
    }
    else if(IS_IPHONE6){
        return (500.f/1334)*[UIScreen mainScreen].bounds.size.height - self.top;
    }
    else if(IS_IPHONE6P){
        return (515.f/1334)*[UIScreen mainScreen].bounds.size.height - self.top;
    }else if (IS_IPHONE_X) {
        return (520.f/1334)*[UIScreen mainScreen].bounds.size.height - self.top;
    }
    return 0;
}

#pragma mark - getter and setters

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_scrollView];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.delegate = self;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.contentInset = UIEdgeInsetsMake(0, kScrollViewContentOffset, 0, kScrollViewContentOffset);
    }
    
    return _scrollView;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    if ([self.delegate respondsToSelector:@selector(menuScroller:didChangeItemAtIndex:)]) {
        [self.delegate menuScroller:self didChangeItemAtIndex:_currentIndex];
    }
}

@end
