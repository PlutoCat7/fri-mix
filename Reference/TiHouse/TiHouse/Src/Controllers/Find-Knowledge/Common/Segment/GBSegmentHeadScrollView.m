//
//  GBSegmentHeadScrollView.m
//  GB_Football
//
//  Created by gxd on 17/7/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBSegmentHeadScrollView.h"


@interface GBSegmentHeadScrollView()<UIScrollViewDelegate, GBSegmentTitleViewDelegate> {
    CGFloat _currentWidth;
    NSUInteger _currentIndex;
    NSUInteger _oldIndex;
}
// 所有标题的设置
@property (strong, nonatomic) GBSegmentStyle *segmentStyle;
// 响应标题点击
@property (copy, nonatomic) TitleBtnOnClickBlock titleBtnOnClick;
// 滚动条
@property (strong, nonatomic) UIView *scrollLine;
// 滚动条背景
@property (strong, nonatomic) UIView *scrollLineBg;
// 滚动scrollView
@property (strong, nonatomic) UIScrollView *scrollView;
/** 缓存所有标题label */
@property (nonatomic, strong) NSMutableArray *titleViews;
// 缓存计算出来的每个标题的宽度
@property (nonatomic, strong) NSMutableArray *titleWidths;
@end

@implementation GBSegmentHeadScrollView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect )frame style:(GBSegmentStyle *)style titles:(NSArray *)titles titleDidClick:(TitleBtnOnClickBlock)titleDidClick {
    if (self = [super initWithFrame:frame]) {
        self.segmentStyle = style;
        self.titles = titles;
        self.titleBtnOnClick = titleDidClick;
        _currentIndex = 0;
        _oldIndex = 0;
        _currentWidth = frame.size.width;
        
        
        // 设置了frame之后可以直接设置其他的控件的frame了, 不需要在layoutsubView()里面设置
        [self setupSubviews];
        [self setupUI];
        
    }
    
    return self;
}
- (void)setupSubviews {
    
    [self addSubview:self.scrollView];
    [self addScrollLine];
    [self setupTitles];
}

- (void)addScrollLine {
    if (self.segmentStyle.isShowLine) {
        [self.scrollView addSubview:self.scrollLineBg];
        [self.scrollView addSubview:self.scrollLine];
    }
}

- (void)dealloc
{
    
}

#pragma mark - button action
- (void)GBSegmentTitleView:(GBSegmentTitleView *)titleView {
    _oldIndex = _currentIndex;
    _currentIndex = titleView.tag;
    
    // 这个可以不用设置，因为会根据下面的视图滚动而滚动
    // [self adjustUIWhenBtnOnClickWithAnimate:true taped:YES];
    GBSegmentTitleView *oldTitleView = (GBSegmentTitleView *)self.titleViews[_oldIndex];
    GBSegmentTitleView *currentTitleView = (GBSegmentTitleView *)self.titleViews[_currentIndex];

    oldTitleView.textColor = self.segmentStyle.normalTitleColor;
    currentTitleView.textColor = self.segmentStyle.selectedTitleColor;
    oldTitleView.selected = NO;
    currentTitleView.selected = YES;
    if (self.segmentStyle.highlightSelectTitle) {
        oldTitleView.font = self.segmentStyle.titleFont;
        currentTitleView.font = self.segmentStyle.highlightTitleFont;
    }
    
    if (self.titleBtnOnClick) {
        self.titleBtnOnClick(titleView, _currentIndex);
    }
}

#pragma mark - private helper

- (void)setupTitles {
    
    if (self.titles.count == 0) return;
    
    NSInteger index = 0;
    for (NSString *title in self.titles) {
        
        GBSegmentTitleView *titleView = [[GBSegmentTitleView alloc] initWithFrame:CGRectZero];
        titleView.tag = index;
        
        titleView.font = self.segmentStyle.titleFont;
        if (self.segmentStyle.highlightSelectTitle) {
            titleView.highlightFont = self.segmentStyle.highlightTitleFont;
        }
        
        titleView.text = title;
        titleView.textColor = self.segmentStyle.normalTitleColor;
        titleView.delegate = self;
        
        CGFloat titleViewWidth = [titleView titleViewWidth];
        [self.titleWidths addObject:@(titleViewWidth)];
        
        [self.titleViews addObject:titleView];
        [self.scrollView addSubview:titleView];
        
        index++;
        
    }
    
}

- (void)setupUI {
    if (self.titles.count == 0) return;
    
    [self setupScrollView];
    [self setUpTitleViewsPosition];
    [self setupScrollLine];
    
    if (self.segmentStyle.isScrollTitle) { // 设置滚动区域
        GBSegmentTitleView *lastTitleView = (GBSegmentTitleView *)self.titleViews.lastObject;
        
        if (lastTitleView) {
            self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastTitleView.frame) + self.segmentStyle.titleMargin, 0.0);
        }
    }
    
}

- (void)setupScrollView {
    
    CGFloat scrollW = _currentWidth;
    self.scrollView.frame = CGRectMake(0.0, 0.0, scrollW, self.frame.size.height);
}

- (void)setUpTitleViewsPosition {
    CGFloat titleX = 0.0;
    CGFloat titleY = 0.0;
    CGFloat titleW = 0.0;
    CGFloat titleH = self.frame.size.height - self.segmentStyle.scrollLineHeight;
    
    if (!self.segmentStyle.isScrollTitle) {// 标题不能滚动, 平分宽度
        titleW = self.scrollView.bounds.size.width / self.titles.count;
        
        NSInteger index = 0;
        for (GBSegmentTitleView *titleView in self.titleViews) {
            
            titleX = index * titleW;
            
            titleView.frame = CGRectMake(titleX, titleY, titleW, titleH);
            [titleView adjustSubviewFrame];
            index++;
        }
        
    } else {
        NSInteger index = 0;
        float allTitlesWidth = self.segmentStyle.titleMargin;
        for (int i = 0; i<self.titleWidths.count; i++) {
            allTitlesWidth = allTitlesWidth + [self.titleWidths[i] floatValue] + self.segmentStyle.titleMargin;
        }
        BOOL isAvg = allTitlesWidth < self.scrollView.bounds.size.width ;
        float margin = isAvg ? 0 : self.segmentStyle.titleMargin;
        float lastLableMaxX = margin;
        
        for (GBSegmentTitleView *titleView in self.titleViews) {
            titleW = isAvg ? (self.scrollView.bounds.size.width / self.titles.count) : [self.titleWidths[index] floatValue];
            titleX = lastLableMaxX;
            
            lastLableMaxX += (titleW + margin);
            
            titleView.frame = CGRectMake(titleX, titleY, titleW, titleH);
            [titleView adjustSubviewFrame];
            index++;
            
        }
        
    }
    
    GBSegmentTitleView *currentTitleView = (GBSegmentTitleView *)self.titleViews[_currentIndex];
    currentTitleView.currentTransformSx = 1.0;
    if (currentTitleView) {
        
        // 设置初始状态文字的颜色
        currentTitleView.textColor = self.segmentStyle.selectedTitleColor;
        if (self.segmentStyle.highlightSelectTitle) {
            currentTitleView.font = self.segmentStyle.highlightTitleFont;
        }
    }
    
}

- (void)setupScrollLine {
    
    GBSegmentTitleView *firstLabel = (GBSegmentTitleView *)self.titleViews[0];
    CGFloat coverX = firstLabel.frame.origin.x;
    CGFloat coverW = firstLabel.frame.size.width;
    
    if (self.scrollLine) {
        float allTitlesWidth = self.segmentStyle.titleMargin;
        for (int i = 0; i<self.titleWidths.count; i++) {
            allTitlesWidth = allTitlesWidth + [self.titleWidths[i] floatValue] + self.segmentStyle.titleMargin;
        }
        allTitlesWidth = allTitlesWidth < self.frame.size.width ? self.frame.size.width : allTitlesWidth;
        
        self.scrollLineBg.frame = CGRectMake(0, self.frame.size.height - self.segmentStyle.scrollLineHeight, allTitlesWidth, self.segmentStyle.scrollLineHeight);
        
        if (self.segmentStyle.isScrollTitle) {
            self.scrollLine.frame = CGRectMake(coverX , self.frame.size.height - self.segmentStyle.scrollLineHeight, coverW , self.segmentStyle.scrollLineHeight);
            
        } else {
            self.scrollLine.frame = CGRectMake(coverX , self.frame.size.height - self.segmentStyle.scrollLineHeight, coverW , self.segmentStyle.scrollLineHeight);
            
        }
    }
    
}


#pragma mark - public helper

- (void)adjustUIWhenBtnOnClickWithAnimate:(BOOL)animated taped:(BOOL)taped {
    if (_currentIndex == _oldIndex && taped) { return; }
    
    GBSegmentTitleView *oldTitleView = (GBSegmentTitleView *)self.titleViews[_oldIndex];
    GBSegmentTitleView *currentTitleView = (GBSegmentTitleView *)self.titleViews[_currentIndex];
    
    CGFloat animatedTime = animated ? 0.30 : 0.0;
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:animatedTime animations:^{
        oldTitleView.textColor = weakSelf.segmentStyle.normalTitleColor;
        currentTitleView.textColor = weakSelf.segmentStyle.selectedTitleColor;
        oldTitleView.selected = NO;
        currentTitleView.selected = YES;
        if (self.segmentStyle.highlightSelectTitle) {
            oldTitleView.font = self.segmentStyle.titleFont;
            currentTitleView.font = self.segmentStyle.highlightTitleFont;
        }
        
        if (weakSelf.scrollLine) {
            if (weakSelf.segmentStyle.isScrollTitle) {
                CGRect frame = weakSelf.scrollLine.frame;
                frame.origin.x = currentTitleView.frame.origin.x;
                frame.size.width = currentTitleView.frame.size.width;
                weakSelf.scrollLine.frame = frame;
                
            } else {
                CGRect frame = weakSelf.scrollLine.frame;
                frame.origin.x = currentTitleView.frame.origin.x;
                frame.size.width = currentTitleView.frame.size.width;
                weakSelf.scrollLine.frame = frame;
            }
            
        }
        
    } completion:^(BOOL finished) {
        [weakSelf adjustTitleOffSetToCurrentIndex:_currentIndex animated:YES];
        
    }];
    
    _oldIndex = _currentIndex;
}

- (void)adjustUIWithProgress:(CGFloat)progress oldIndex:(NSInteger)oldIndex currentIndex:(NSInteger)currentIndex {
    if (oldIndex < 0 ||
        oldIndex >= self.titles.count ||
        currentIndex < 0 ||
        currentIndex >= self.titles.count
        ) {
        return;
    }
    _oldIndex = currentIndex;
    
    GBSegmentTitleView *oldTitleView = (GBSegmentTitleView *)self.titleViews[oldIndex];
    GBSegmentTitleView *currentTitleView = (GBSegmentTitleView *)self.titleViews[currentIndex];
    
    
    CGFloat xDistance = currentTitleView.frame.origin.x - oldTitleView.frame.origin.x;
    CGFloat wDistance = currentTitleView.frame.size.width - oldTitleView.frame.size.width;
    
    if (self.scrollLine) {
        
        if (self.segmentStyle.isScrollTitle) {
            CGRect frame = self.scrollLine.frame;
            frame.origin.x = oldTitleView.frame.origin.x + xDistance * progress;
            frame.size.width = oldTitleView.frame.size.width + wDistance * progress;
            self.scrollLine.frame = frame;
        } else {
            CGRect frame = self.scrollLine.frame;
            frame.origin.x = oldTitleView.frame.origin.x + xDistance * progress;
            frame.size.width = oldTitleView.frame.size.width + wDistance * progress;
            self.scrollLine.frame = frame;
        }
        
    }
    
}

- (void)adjustTitleOffSetToCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated {
    _oldIndex = currentIndex;
    _currentIndex = currentIndex;
    // 重置渐变/缩放效果附近其他item的缩放和颜色
    int index = 0;
    for (GBSegmentTitleView *titleView in _titleViews) {
        if (index != currentIndex) {
            titleView.textColor = self.segmentStyle.normalTitleColor;
            titleView.currentTransformSx = 1.0;
            titleView.selected = NO;
            if (self.segmentStyle.highlightSelectTitle) {
                titleView.font = self.segmentStyle.titleFont;
            }
            
        }
        else {
            titleView.textColor = self.segmentStyle.selectedTitleColor;
            titleView.selected = YES;
            if (self.segmentStyle.highlightSelectTitle) {
                titleView.font = self.segmentStyle.highlightTitleFont;
            }
        }
        index++;
    }
    
    if (self.scrollView.contentSize.width != self.scrollView.bounds.size.width + self.segmentStyle.titleMargin) {// 需要滚动
        GBSegmentTitleView *currentTitleView = (GBSegmentTitleView *)_titleViews[currentIndex];
        
        CGFloat offSetx = currentTitleView.center.x - _currentWidth * 0.5;
        if (offSetx < 0) {
            offSetx = 0;
            
        }
        CGFloat maxOffSetX = self.scrollView.contentSize.width - _currentWidth;
        
        if (maxOffSetX < 0) {
            maxOffSetX = 0;
        }
        
        if (offSetx > maxOffSetX) {
            offSetx = maxOffSetX;
        }
        
        [self.scrollView setContentOffset:CGPointMake(offSetx, 0.0) animated:animated];
    }
    
    
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated {
    NSAssert(index >= 0 && index < self.titles.count, @"设置的下标不合法!!");
    
    if (index < 0 || index >= self.titles.count) {
        return;
    }
    
    _currentIndex = index;
    [self adjustUIWhenBtnOnClickWithAnimate:animated taped:NO];
}

- (void)reloadTitlesWithNewTitles:(NSArray *)titles {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _currentIndex = 0;
    _oldIndex = 0;
    self.titleWidths = nil;
    self.titleViews = nil;
    self.titles = nil;
    self.titles = [titles copy];
    if (self.titles.count == 0) return;
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    [self setupSubviews];
    [self setupUI];
    [self setSelectedIndex:0 animated:YES];
    
}

- (void)setTitleWithIndex:(NSString *)title index:(NSInteger)index {
    if (index >= self.titles.count) {
        return;
    }
    NSMutableArray *titles = [NSMutableArray arrayWithArray:self.titles];
    [titles replaceObjectAtIndex:index withObject:title];
    self.titles = [titles copy];
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.titleWidths = nil;
    self.titleViews = nil;
    self.titles = nil;
    self.titles = [titles copy];
    if (self.titles.count == 0) return;
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    [self setupSubviews];
    [self setupUI];
    [self setSelectedIndex:_currentIndex animated:NO];
    
}

#pragma mark - getter --- setter

- (UIView *)scrollLine {
    
    if (!self.segmentStyle.isShowLine) {
        return nil;
    }
    
    if (!_scrollLine) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = self.segmentStyle.scrollLineColor;
        
        _scrollLine = lineView;
        
    }
    
    return _scrollLine;
}

- (UIView *)scrollLineBg {
    if (!self.segmentStyle.isShowLine) {
        return nil;
    }
    
    if (!_scrollLineBg) {
        UIView *lineBgView = [[UIView alloc] init];
        lineBgView.backgroundColor = self.segmentStyle.scrollLineBgColor;
        
        _scrollLineBg = lineBgView;
    }
    
    return _scrollLineBg;
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.bounces = YES;
        scrollView.pagingEnabled = NO;
        scrollView.delegate = self;
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (NSMutableArray *)titleViews
{
    if (_titleViews == nil) {
        _titleViews = [NSMutableArray array];
    }
    return _titleViews;
}

- (NSMutableArray *)titleWidths
{
    if (_titleWidths == nil) {
        _titleWidths = [NSMutableArray array];
    }
    return _titleWidths;
}


@end
