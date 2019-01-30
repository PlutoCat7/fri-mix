//
//  SGTopScrollMenu.m
//  SGTopScrollMenu
//
//  Created by Sorgle on 16/8/14.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

// 欢迎来Github上下载最完整的Demo
// Github下载地址 https://github.com/Hanymore/SGTopScrollMenu.git


#import "SGTopScrollMenu.h"
#import "UIView+SGExtension.h"

#define labelFontOfSize [UIFont systemFontOfSize:17]
#define SG_screenWidth [UIScreen mainScreen].bounds.size.width

@interface SGTopScrollMenu ()
@property (nonatomic, strong) UILabel *titleLabel;
/** 选中时的label */
@property (nonatomic, strong) UILabel *selectedLabel;
/** 指示器 */
@property (nonatomic, strong) UIView *indicatorView;

@end


@implementation SGTopScrollMenu

/** label之间的间距 */
static CGFloat const labelMargin = 15;
/** 指示器的高度 */
static CGFloat const indicatorHeight = 4;
/** 形变的度数 */
static CGFloat const radio = 1.0;

- (NSMutableArray *)allTitleLabel {
    if (_allTitleLabel == nil) {
        _allTitleLabel = [NSMutableArray array];
    }
    return _allTitleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
    }
    return self;
}

+ (instancetype)topScrollMenuWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}


/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)setTitlesArr:(NSArray *)titlesArr {
    
    if ([_titlesArr.firstObject isEqualToString:titlesArr.firstObject]) {
        return;
    }
    
    _titlesArr = titlesArr;
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    /** 创建标题Label */
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat labelH = self.frame.size.height - indicatorHeight;
    
    for (NSUInteger i = 0; i < self.titlesArr.count; i++) {
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.userInteractionEnabled = YES;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = kTitleAddHouseTitleCOLOR;
        _titleLabel.text = self.titlesArr[i];
        // 设置高亮文字颜色
        _titleLabel.highlightedTextColor = kTitleAddHouseTitleCOLOR;

        _titleLabel.tag = i;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        // 计算内容的Size
        CGSize labelSize = [self sizeWithText:_titleLabel.text font:labelFontOfSize maxSize:CGSizeMake(MAXFLOAT, labelH)];
        // 计算内容的宽度
        CGFloat labelW = labelSize.width + 2 * labelMargin;
        
        _titleLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        // 计算每个label的X值
        labelX = labelX + labelW;
        
        // 添加到titleLabels数组
        [self.allTitleLabel addObject:_titleLabel];
        
        // 添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        [_titleLabel addGestureRecognizer:tap];
        
        // 默认选中第0个label
        if (i == 0) {
            [self titleClick:tap];
        }

        [self addSubview:_titleLabel];
    }
    
    // 计算scrollView的宽度
    CGFloat scrollViewWidth = CGRectGetMaxX(self.subviews.lastObject.frame);
    self.contentSize = CGSizeMake(scrollViewWidth, self.frame.size.height);
    
    // 取出第一个子控件
    UILabel *firstLabel = self.subviews.firstObject;
    
    // 添加指示器
    self.indicatorView = [[UIView alloc] init];
    _indicatorView.backgroundColor = XWColorFromHex(0xfdf086);
    _indicatorView.SG_height = indicatorHeight;
    _indicatorView.layer.cornerRadius = 2.0f;
    _indicatorView.SG_y = self.frame.size.height - indicatorHeight;
    [self addSubview:_indicatorView];
    
    
    // 立刻根据文字内容计算第一个label的宽度
    _indicatorView.SG_width = firstLabel.SG_width - 2 * labelMargin;
    _indicatorView.SG_centerX = firstLabel.SG_centerX;
}

#pragma mark - - - Label的点击事件
- (void)titleClick:(UITapGestureRecognizer *)tap {
    // 0.获取选中的label
    UILabel *selLabel = (UILabel *)tap.view;
    
    // 1.标题颜色变成红色,设置高亮状态下的颜色， 以及指示器位置
    [self selectLabel:selLabel];
    
    // 2.让选中的标题居中
    [self setupTitleCenter:selLabel];
    
    
    NSInteger index = selLabel.tag;
    if ([self.topScrollMenuDelegate respondsToSelector:@selector(SGTopScrollMenu:didSelectTitleAtIndex:)]) {
        [self.topScrollMenuDelegate SGTopScrollMenu:self didSelectTitleAtIndex:index];
    }
}

/** 选中label标题颜色变成红色以及指示器位置 */
- (void)selectLabel:(UILabel *)label {
    // 取消高亮
    _selectedLabel.highlighted = NO;
    // 取消形变
    _selectedLabel.transform = CGAffineTransformIdentity;
    // 颜色恢复
    _selectedLabel.textColor = kTitleAddHouseTitleCOLOR;
    
    _selectedLabel.font = [UIFont systemFontOfSize:15];
    
    // 高亮
    label.highlighted = YES;
    // 形变
    label.transform = CGAffineTransformMakeScale(radio, radio);
    label.font = [UIFont systemFontOfSize:15 weight:10];
    
    _selectedLabel = label;
    
    // 改变指示器位置
    [UIView animateWithDuration:0.20 animations:^{
        self.indicatorView.SG_width = label.SG_width - 2 * labelMargin;
        self.indicatorView.SG_centerX = label.SG_centerX;
    }];
}

/** 设置选中的标题居中 */
- (void)setupTitleCenter:(UILabel *)centerLabel {
    // 计算偏移量
    CGFloat offsetX = centerLabel.center.x - SG_screenWidth * 0.5;
    
    if (offsetX < 0) offsetX = 0;
    
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.contentSize.width - SG_screenWidth;
    
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    
    // 滚动标题滚动条
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}



@end


