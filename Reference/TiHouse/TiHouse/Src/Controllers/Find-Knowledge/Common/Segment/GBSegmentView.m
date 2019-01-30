//
//  GBSegmentView.m
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/7/11.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBSegmentView.h"
#import "GBSegmentScrollView.h"

#define LR_COUNT 5

@interface GBSegmentView()<UIScrollViewDelegate>

@property (nonatomic,strong) GBSegmentScrollView * bottomScrollView;
@property (nonatomic,strong) GBSegmentHeadScrollView * headScrollView;
@property (nonatomic,strong) NSArray * vcArray;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,assign) CGFloat totalWidth;
@property (nonatomic,assign) CGFloat totalHeight;
@property (nonatomic,assign) CGFloat topHeight;

@property (nonatomic,strong) NSArray *modeArray;
@property (nonatomic,strong) NSMutableArray *modeVCArray;

@property (nonatomic,strong) GBSegmentStyle *segmentStyle;

// 滑动结束或按钮按下的delegate
@property(nonatomic,weak)id<GBSegmentViewDelegate>delegate;
// 当前页
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,assign) CGFloat oldOffSetX;

@end

@implementation GBSegmentView

-(void)setScrollerEnable:(BOOL)scrollerEnable
{
    _scrollerEnable  = scrollerEnable;
    self.bottomScrollView.scrollEnabled = scrollerEnable;
}

- (void)setIsNeedDelete:(BOOL)isNeedDelete {
    
    _isNeedDelete = isNeedDelete;
    self.bottomScrollView.isNeedDelete = isNeedDelete;
}

-(void)setTitle:(NSString*)title index:(NSInteger)index
{
    if (index >= [self.titleArray count]) {
        return;
    }
    
    if (self.headScrollView) {
        [self.headScrollView setTitleWithIndex:title index:index];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
                    topHeight:(CGFloat)topHeight
              viewControllers:(NSArray<UIViewController*>*)viewControllers
                       titles:(NSArray<NSString*>*)titles
                     delegate:(id<GBSegmentViewDelegate>)delegate
{
    if (self = [super initWithFrame:frame]) {
        self.currentIndex = 0;
        self.backgroundColor = [UIColor clearColor];
        self.titleArray = titles;
        self.vcArray = viewControllers;
        self.totalWidth = frame.size.width;
        self.totalHeight = frame.size.height;
        self.topHeight = topHeight;
        self.backgroundColor =  [UIColor clearColor];
        self.delegate = delegate;
        if (self.titleArray) {
            [self setupTopView];
        }
        [self setupBottomView];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                    topHeight:(CGFloat)topHeight
              viewControllers:(NSArray<UIViewController*>*)viewControllers
                       titles:(NSArray<NSString*>*)titles
                 segmentStyle:(GBSegmentStyle *)segmentStyle
                     delegate:(id<GBSegmentViewDelegate>)delegate {
    if (self = [super initWithFrame:frame]) {
        self.currentIndex = 0;
        self.backgroundColor = [UIColor clearColor];
        self.titleArray = titles;
        self.vcArray = viewControllers;
        self.totalWidth = frame.size.width;
        self.totalHeight = frame.size.height;
        self.topHeight = topHeight;
        self.backgroundColor =  [UIColor clearColor];
        self.delegate = delegate;
        self.segmentStyle = segmentStyle;
        if (self.titleArray) {
            [self setupTopView];
        }
        [self setupBottomView];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                    topHeight:(CGFloat)topHeight
               colorModeArray:(NSArray<ColorModeInfo*>*)colorModelArray
                       titles:(NSArray<NSString*>*)titles {
    if (self = [super initWithFrame:frame]) {
        self.currentIndex = 0;
        self.backgroundColor = [UIColor clearColor];
        self.titleArray = titles;
        self.modeArray = colorModelArray;
        self.totalWidth = frame.size.width;
        self.totalHeight = frame.size.height;
        self.topHeight = topHeight;
        self.backgroundColor =  [UIColor clearColor];
        if (self.titleArray) {
            [self setupTopView];
        }
        [self setupModeBottomView];
        
    }
    return self;
}

- (void)goCurrentController:(NSInteger)index {
    if (self.headScrollView) {
        [self.headScrollView setSelectedIndex:index animated:NO];
    }
    
    if (self.modeArray.count > 0) {
        for (int i = ((int)index - LR_COUNT); i < (int) (self.modeArray.count) && i < ((int) index + LR_COUNT); i ++) {
            if (i<0 || i >= self.modeArray.count) {
                continue;
            }
            CGRect  VCFrame = CGRectMake(i * self.totalWidth, 0, self.totalWidth, self.bottomScrollView.frame.size.height);
            ColorBigCellViewController *vc = self.modeVCArray[i%(LR_COUNT*2)];
            [vc refreshWithColorModeInfo:self.modeArray[i] big:YES];
            WEAKSELF
            vc.clickBlock = ^(ColorModeInfo * colorModelInfo) {
                if (weakSelf.clickBlock) {
                    weakSelf.clickBlock(colorModelInfo);
                }
            };
            vc.view.frame = VCFrame;
            
        }
    }
    
    [self.bottomScrollView setContentOffset:CGPointMake(index * self.totalWidth, 0) animated:NO];
    
    if (self.currentIndex != index) {
        self.currentIndex = index;
        
        if (self.delegate){
            if([self.delegate respondsToSelector:@selector(GBSegmentView:toIndex:)]){
                [self.delegate GBSegmentView:self toIndex:index];
            }
            if([self.delegate respondsToSelector:@selector(GBSegmentView:toViewController:)]){
                [self.delegate GBSegmentView:self toViewController:self.vcArray[index]];
            }
        }
    }
    
}

- (void)resetTopItemHeight:(CGFloat)height {
    
    self.bottomScrollView.height = self.height - height;
    [UIView animateWithDuration:0.25f animations:^{
        self.bottomScrollView.top = height;
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

#pragma mark - Private

- (void)setupTopView
{
    CGRect topViewFrame = CGRectMake(0, 0, self.totalWidth, self.topHeight);
    if (self.segmentStyle == nil) {
        self.segmentStyle = [[GBSegmentStyle alloc] init];
    }
    @weakify(self)
    self.headScrollView = [[GBSegmentHeadScrollView alloc] initWithFrame:topViewFrame style:self.segmentStyle titles:self.titleArray titleDidClick:^(GBSegmentTitleView *titleView, NSInteger index) {
        
        @strongify(self)
        [self.bottomScrollView setContentOffset:CGPointMake(index * self.totalWidth, 0) animated:YES];
        
        
        if (self.currentIndex != index) {
            self.currentIndex = index;
            
            if (self.delegate){
                if([self.delegate respondsToSelector:@selector(GBSegmentView:toIndex:)]){
                    [self.delegate GBSegmentView:self toIndex:index];
                }
                if([self.delegate respondsToSelector:@selector(GBSegmentView:toViewController:)]){
                    [self.delegate GBSegmentView:self toViewController:self.vcArray[index]];
                }
            }
        }
        
    }];
    [self addSubview:self.headScrollView];

}

- (void)setupBottomView
{
    
    CGRect  bottomScrollViewFrame = CGRectMake(0, self.topHeight, self.totalWidth, self.totalHeight - self.topHeight );
    self.bottomScrollView = [[GBSegmentScrollView alloc]initWithFrame:bottomScrollViewFrame];
    [self addSubview:self.bottomScrollView];
    for (int i = 0; i < self.modeArray.count ; i ++) {
        CGRect  VCFrame = CGRectMake(i * self.totalWidth, 0, self.totalWidth, bottomScrollViewFrame.size.height);
        UIViewController * vc = self.vcArray[i];
        vc.view.frame = VCFrame;
        [self.bottomScrollView addSubview:vc.view];
    }
    self.bottomScrollView.delaysContentTouches = YES;
    self.bottomScrollView.contentSize = CGSizeMake(self.vcArray.count * self.totalWidth, 0);
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    self.bottomScrollView.directionalLockEnabled = YES;
    self.bottomScrollView.bounces = YES;
    self.bottomScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.bottomScrollView.delegate =self;
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.backgroundColor = [UIColor clearColor];
    
    if (self.delegate && self.currentIndex < [self.vcArray count]){
        if([self.delegate respondsToSelector:@selector(GBSegmentView:toIndex:)]){
            [self.delegate GBSegmentView:self toIndex:self.currentIndex];
        }
        if([self.delegate respondsToSelector:@selector(GBSegmentView:toViewController:)]){
            [self.delegate GBSegmentView:self toViewController:self.vcArray[self.currentIndex]];
        }
    }
}

- (void)setupModeBottomView {
    self.modeVCArray = [NSMutableArray arrayWithCapacity:self.modeArray.count];
    CGRect  bottomScrollViewFrame = CGRectMake(0, self.topHeight, self.totalWidth, self.totalHeight - self.topHeight );
    self.bottomScrollView = [[GBSegmentScrollView alloc]initWithFrame:bottomScrollViewFrame];
    [self addSubview:self.bottomScrollView];
    for (int i = 0; i < self.modeArray.count && i < LR_COUNT*2; i ++) {
        ColorBigCellViewController *vc = [[ColorBigCellViewController alloc]init];
        [vc refreshWithColorModeInfo:self.modeArray[i] big:YES];
        CGRect  VCFrame = CGRectMake(i * self.totalWidth, 0, self.totalWidth, bottomScrollViewFrame.size.height);
        vc.view.frame = VCFrame;
        vc.view.backgroundColor = [UIColor clearColor];
        [self.bottomScrollView addSubview:vc.view];
        [self.modeVCArray setObject:vc atIndexedSubscript:i];
    }
    
    self.bottomScrollView.delaysContentTouches = YES;
    self.bottomScrollView.contentSize = CGSizeMake(self.modeArray.count * self.totalWidth, 0);
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    self.bottomScrollView.directionalLockEnabled = YES;
    self.bottomScrollView.bounces = YES;
    self.bottomScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.bottomScrollView.delegate =self;
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.backgroundColor = [UIColor clearColor];
    
    if (self.delegate && self.currentIndex < [self.vcArray count]){
        if([self.delegate respondsToSelector:@selector(GBSegmentView:toIndex:)]){
            [self.delegate GBSegmentView:self toIndex:self.currentIndex];
        }
        if([self.delegate respondsToSelector:@selector(GBSegmentView:toViewController:)]){
            [self.delegate GBSegmentView:self toViewController:self.vcArray[self.currentIndex]];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.oldOffSetX = scrollView.contentOffset.x;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat tempProgress = scrollView.contentOffset.x / self.bounds.size.width;
    NSInteger tempIndex = tempProgress;
    
    CGFloat progress = tempProgress - floor(tempProgress);
    CGFloat deltaX = scrollView.contentOffset.x - self.oldOffSetX;
    NSInteger currentIndex = tempIndex;
    NSInteger oldIndex = tempIndex;
    
    NSInteger pageNum = currentIndex;
    if (self.modeArray.count > 0) {
        
        for (int i = ((int)pageNum - LR_COUNT); i < (int)(self.modeArray.count) && i < ((int) pageNum + LR_COUNT); i ++) {
            if (i<0 || i >= self.modeArray.count) {
                continue;
            }
            CGRect  VCFrame = CGRectMake(i * self.totalWidth, 0, self.totalWidth, self.bottomScrollView.frame.size.height);
            ColorBigCellViewController *vc = self.modeVCArray[i%(LR_COUNT*2)];
            [vc refreshWithColorModeInfo:self.modeArray[i] big:YES];
            WEAKSELF
            vc.clickBlock = ^(ColorModeInfo * colorModelInfo) {
                if (weakSelf.clickBlock) {
                    weakSelf.clickBlock(colorModelInfo);
                }
            };
            
            vc.view.frame = VCFrame;
        }
    }
    
    if (deltaX > 0) {// 向左
        if (progress == 0.0) {
            return;
        }
        currentIndex = tempIndex+1;
        oldIndex = tempIndex;
        
    } else if (deltaX < 0) {
        progress = 1.0 - progress;
        oldIndex = tempIndex+1;
        currentIndex = tempIndex;
        
    } else {
        return;
    }
    
    
    if (self.headScrollView) {
        [self.headScrollView adjustUIWithProgress:progress oldIndex:oldIndex currentIndex:currentIndex];
    }
    
}

- (void)reloadCurrentData {
    ColorBigCellViewController *vc = self.modeVCArray[self.currentIndex%(LR_COUNT*2)];
    [vc refreshWithColorModeInfo:self.modeArray[self.currentIndex] big:YES];
    WEAKSELF
    vc.clickBlock = ^(ColorModeInfo * colorModelInfo) {
        if (weakSelf.clickBlock) {
            weakSelf.clickBlock(colorModelInfo);
        }
    };
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int pageNum = scrollView.contentOffset.x / self.totalWidth;

    if (self.headScrollView) {
        [self.headScrollView adjustTitleOffSetToCurrentIndex:pageNum animated:YES];
    }
    
    if (self.modeArray.count > 0) {
        
        for (int i = ((int)pageNum - LR_COUNT); i < (int)(self.modeArray.count) && i < ((int) pageNum + LR_COUNT); i ++) {
            if (i<0 || i >= self.modeArray.count) {
                continue;
            }
            CGRect  VCFrame = CGRectMake(i * self.totalWidth, 0, self.totalWidth, self.bottomScrollView.frame.size.height);
            ColorBigCellViewController *vc = self.modeVCArray[i%(LR_COUNT*2)];
            [vc refreshWithColorModeInfo:self.modeArray[i] big:YES];
            WEAKSELF
            vc.clickBlock = ^(ColorModeInfo * colorModelInfo) {
                if (weakSelf.clickBlock) {
                    weakSelf.clickBlock(colorModelInfo);
                }
            };
            vc.view.frame = VCFrame;
        }
    }
    
    if (self.currentIndex != pageNum) {
        self.currentIndex = pageNum;
        if (self.delegate){
            if([self.delegate respondsToSelector:@selector(GBSegmentView:toIndex:)]){
                [self.delegate GBSegmentView:self toIndex:pageNum];
            }
            if([self.delegate respondsToSelector:@selector(GBSegmentView:toViewController:)]){
                [self.delegate GBSegmentView:self toViewController:self.vcArray[pageNum]];
            }
        }
    }
    
}

@end
