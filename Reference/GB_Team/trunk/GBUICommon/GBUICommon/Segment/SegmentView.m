//
//  SegmentView.m
//  GBUICommon
//
//  Created by weilai on 16/9/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "SegmentView.h"
#import "SegmentScrollView.h"

#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define kDefaultTop         UIColorRGBA(  0,   0,   0, 1)
#define kDefaultSlider      UIColorRGBA( 34,  34,  34, 1)
#define kHightLightSlider   UIColorRGBA(  1,  255,  1, 1)
#define kDefaultHighLight   UIColorRGBA(255, 255, 255, 1)
#define kDefaultNomal       UIColorRGBA(144, 144, 144, 1)
#define kSliderHight        2.0f


@interface SegmentView()<UIScrollViewDelegate>

@property (nonatomic,strong) UIView * topView;
@property (nonatomic,strong) UIView * slideContentView;
@property (nonatomic,strong) UIView * slideView;
@property (nonatomic,strong) UIScrollView * topScrollView;
@property (nonatomic,strong) SegmentScrollView * bottomScrollView;
@property (nonatomic,strong) NSMutableArray * btnArray;
@property (nonatomic,strong) NSArray * vcArray;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,assign) CGFloat totalWidth;
@property (nonatomic,assign) CGFloat totalHeight;
@property (nonatomic,assign) CGFloat topHeight;

// 滑动结束或按钮按下的delegate
@property(nonatomic,weak)id<SegmentViewDelegate>delegate;
// 当前页
@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation SegmentView

- (instancetype)initWithFrame:(CGRect)frame
                    topHeight:(CGFloat)topHeight
              viewControllers:(NSArray<SegPageViewController*>*)viewControllers
                       titles:(NSArray<NSString*>*)titles
                     delegate:(id<SegmentViewDelegate>)delegate {
    if (self = [super initWithFrame:frame]) {
        self.currentIndex = 0;
        
        self.titleArray = titles;
        self.vcArray = viewControllers;
        self.totalWidth = frame.size.width;
        self.totalHeight = frame.size.height;
        self.topHeight = topHeight;
        self.btnArray = [NSMutableArray array];
        self.delegate = delegate;
        if (self.titleArray) {
            [self setupTopView];
        }
        [self setupBottomView];
        
    }
    return self;
}

-(void)setScrollerEnable:(BOOL)scrollerEnable {
    _scrollerEnable  = scrollerEnable;
    [self setupButtonEnable:scrollerEnable];
    self.bottomScrollView.scrollEnabled = scrollerEnable;
}

- (void)setIsNeedDelete:(BOOL)isNeedDelete {
    
    _isNeedDelete = isNeedDelete;
    self.bottomScrollView.isNeedDelete = isNeedDelete;
}

-(void)setTitle:(NSString*)title index:(NSInteger)index {
    if (index >= [self.btnArray count]) {
        NSLog(@"传入参数数组越界");
        return;
    }
    for (int i = 0 ;i < [self.btnArray count] ; i++){
        if (index == i) {
            [self.btnArray[i] setTitle:title forState:UIControlStateNormal];
            [self.btnArray[i] setTitle:title forState:UIControlStateHighlighted];
        }
    }
}

-(void)setupButtonEnable:(BOOL)enble {
    for (int i = 0 ;i < [self.btnArray count] ; i++){
        UIButton *button = self.btnArray[i];
        [button setUserInteractionEnabled:enble];
    }
}

- (void)setupTopView {
    CGFloat buttonWight = self.totalWidth / self.vcArray.count;
    CGFloat buttonhight = self.topHeight - 4;
    CGRect topViewFrame = CGRectMake(0, 0, self.totalWidth, self.topHeight);
    self.topView = [[UIView alloc]initWithFrame:topViewFrame];
    [self.topView setBackgroundColor:kDefaultTop];
    [self addSubview:self.topView];
    
    self.slideContentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.topHeight - kSliderHight, self.totalWidth, kSliderHight)];
    self.slideContentView.backgroundColor = kDefaultSlider;
    [self.topView addSubview:self.slideContentView];
    
    self.slideView = [[UIView alloc] initWithFrame:CGRectMake(0,self.topHeight - kSliderHight, buttonWight,kSliderHight)];
    [self.slideView setBackgroundColor:kHightLightSlider];
    [self.topView  addSubview:self.slideView];
    
    for (int i = 0; i < self.vcArray.count ; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * buttonWight, 0, buttonWight, buttonhight)];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWight, buttonhight)];
        button.tag = i;
        if (self.titleArray)
        {
            NSString * buttonTitle =  self.titleArray[i];
            [button setTitle:buttonTitle forState:UIControlStateNormal];
        }
        [button setBackgroundColor:[UIColor blackColor]];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
        button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [button setTitleColor:kDefaultNomal forState:UIControlStateNormal];
        if (i == 0) [button setTitleColor:kDefaultHighLight forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tabButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [view addSubview:button];
        [self.btnArray addObject:button];
        [self.topView addSubview:view];
    }
}

- (void)setupBottomView
{
    CGRect  bottomScrollViewFrame = CGRectMake(0, self.topHeight, self.totalWidth, self.totalHeight - self.topHeight );
    self.bottomScrollView = [[SegmentScrollView alloc]initWithFrame:bottomScrollViewFrame];
    [self addSubview:self.bottomScrollView];
    for (int i = 0; i < self.vcArray.count ; i ++) {
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
    
    if (self.delegate && self.currentIndex < [self.vcArray count]){
        if([self.delegate respondsToSelector:@selector(SegmentView:fromIndex:toIndex:)]){
            [self.delegate SegmentView:self fromIndex:-1 toIndex:self.currentIndex];
        }
        if([self.delegate respondsToSelector:@selector(SegmentView:fromController:toController:)]){
            [self.delegate SegmentView:self fromController:nil toController:self.vcArray[self.currentIndex]];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = self.slideView.frame;
    frame.origin.x = scrollView.contentOffset.x/self.vcArray.count;
    self.slideView.frame = frame;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int pageNum = scrollView.contentOffset.x / self.totalWidth;
    for (UIButton * btn in self.btnArray) {
        if (btn.tag == pageNum ) {
            [btn setTitleColor:kDefaultHighLight forState:UIControlStateNormal];
            
        } else {
            [btn setTitleColor:kDefaultNomal forState:UIControlStateNormal];
        }
    }
    
    if (self.currentIndex != pageNum) {
        NSInteger preIndex = self.currentIndex;
        self.currentIndex = pageNum;
        
        if (self.delegate){
            if([self.delegate respondsToSelector:@selector(SegmentView:fromIndex:toIndex:)]){
                [self.delegate SegmentView:self fromIndex:preIndex toIndex:self.currentIndex];
            }
            if([self.delegate respondsToSelector:@selector(SegmentView:fromController:toController:)]){
                [self.delegate SegmentView:self fromController:self.vcArray[preIndex] toController:self.vcArray[self.currentIndex]];
            }
        }
    }
    
}

-(void) tabButton: (id) sender{
    UIButton *button = sender;
    for (UIButton * btn in self.btnArray) {
        if (button.tag !=btn.tag) {
            [btn setTitleColor:kDefaultNomal forState:UIControlStateNormal];
        } else {
            [button setTitleColor:kDefaultHighLight forState:UIControlStateNormal];
        }
    }
    [self.bottomScrollView setContentOffset:CGPointMake(button.tag * self.totalWidth, 0) animated:YES];
    
    if (self.currentIndex != button.tag) {
        NSInteger preIndex = self.currentIndex;
        self.currentIndex = button.tag;
        
        if (self.delegate){
            if([self.delegate respondsToSelector:@selector(SegmentView:fromIndex:toIndex:)]){
                [self.delegate SegmentView:self fromIndex:preIndex toIndex:self.currentIndex];
            }
            if([self.delegate respondsToSelector:@selector(SegmentView:fromController:toController:)]){
                [self.delegate SegmentView:self fromController:self.vcArray[preIndex] toController:self.vcArray[self.currentIndex]];
            }
        }
    }
}


- (void)setCurrentController:(NSInteger)index {
    [self.bottomScrollView setContentOffset:CGPointMake(index * self.totalWidth, 0) animated:YES];
}

@end
