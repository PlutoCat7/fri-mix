//
//  LMSegmentedControl.m
//  SimpleWord
//
//  Created by Chenly on 16/5/13.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "LMSegmentedControl.h"
#import "LMColorSelectView.h"
#import "LMFontSelectView.h"

@interface LMSegmentedControl ()

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *itemViews;
@property (nonatomic, strong) NSArray *menuNormalIcons;
@property (nonatomic, strong) NSArray *menuSelectIcons;

@property (nonatomic, strong) LMColorSelectView *colorView;
@property (nonatomic, strong) LMFontSelectView *fontView;

@end

@implementation LMSegmentedControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _menuNormalIcons = @[@"find_article_edit_photo", @"find_article_edit_font",@"find_article_edit_color",@"find_article_edit_line",@"find_article_edit_keybord_close"];
        _menuSelectIcons = @[@"find_article_edit_photo", @"find_article_edit_font_select",@"find_article_edit_color_select",@"find_article_edit_line",@"find_article_edit_keybord_close"];
        _itemViews = [NSMutableArray arrayWithCapacity:_menuNormalIcons.count];
        for (NSString *itemImageName in _menuNormalIcons) {
            UIImageView *itemView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:itemImageName]];
            itemView.contentMode = UIViewContentModeCenter;
            [self addSubview:itemView];
            [_itemViews addObject:itemView];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
        //
        self.topLine = [[UIView alloc] initWithFrame:CGRectZero];
        self.topLine.backgroundColor = [UIColor colorWithRGBHex:0xdbdbdb];
        [self addSubview:self.topLine];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.bounds;
    
    self.topLine.frame = CGRectMake(0, 0, CGRectGetWidth(rect), 0.5f);
    
    CGFloat itemWidth = CGRectGetWidth(rect) / self.numberOfSegments;
    CGFloat itemHeight = CGRectGetHeight(rect) - 4.f;
    rect.size = CGSizeMake(itemWidth, itemHeight);
    rect.origin.y = 1.f;
    for (UIView *itemView in _itemViews) {
        itemView.frame = rect;
        rect.origin.x += itemWidth;
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), 0.0)];
    path.lineWidth = 1.f;
    [[UIColor colorWithRGBHex:0xdbdbdb] setStroke];
    [path stroke];
}

#pragma mark - Public

- (void)clearUI {
    
    for (UIImageView *itemView in _itemViews) {
        
        itemView.image = [UIImage imageNamed:_menuNormalIcons[[_itemViews indexOfObject:itemView]]];
    }
}

- (NSInteger)numberOfSegments {
    
    return _menuNormalIcons.count;
}

#pragma mark - Private


- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    CGPoint point = [tap locationInView:self];
    CGFloat itemWidth = CGRectGetWidth(self.bounds) / self.numberOfSegments;
    NSInteger index = point.x / itemWidth;
    UIImageView *imageView = self.itemViews[index];
    if (index == 2) {
        [self.fontView close];
        if (self.colorView) {
            [self.colorView close];
        }else {
            @weakify(self)
            self.colorView = [LMColorSelectView showWithView:self.itemViews[index] completeBlock:^(UIColor *color) {
                @strongify(self)
                [self.colorView close];
                
                self.textStyle.textColor = color;
                if ([self.delegate respondsToSelector:@selector(lm_segmentedControl:didChangedTextStyle:)]) {
                    [self.delegate lm_segmentedControl:self didChangedTextStyle:self.textStyle];
                }
            } cancelBlock:^{
                @strongify(self)
                self.colorView = nil;
                imageView.image = [UIImage imageNamed:self.menuNormalIcons[index]];
            }];
            imageView.image = [UIImage imageNamed:self.menuSelectIcons[index]];
        }
    }else if (index == 1) {
        [self.colorView close];
        if (self.fontView) {
            [self.fontView close];
        }else {
            @weakify(self)
            self.fontView = [LMFontSelectView showWithView:self.itemViews[index] completeBlock:^(NSInteger index) {
                @strongify(self)
                [self.fontView close];
                
                switch (index) {
                    case 0:
                        self.textStyle.type = LMTextStyleFormatH2;
                        break;
                    case 1:
                        self.textStyle.type = LMTextStyleFormatH3;
                        break;
                    case 2:
                        self.textStyle.bold = !self.textStyle.bold;
                        break;
                    case 3://引用
                        break;
                        
                    default:
                        break;
                }
                if ([self.delegate respondsToSelector:@selector(lm_segmentedControl:didChangedTextStyle:)]) {
                    [self.delegate lm_segmentedControl:self didChangedTextStyle:self.textStyle];
                }
            } cancelBlock:^{
                @strongify(self)
                self.fontView = nil;
                imageView.image = [UIImage imageNamed:self.menuNormalIcons[index]];
            }];
            if (self.textStyle.type == LMTextStyleFormatH2) {
                self.fontView.selectFontIndex = 0;
            }else if (self.textStyle.type == LMTextStyleFormatH3) {
                self.fontView.selectFontIndex = 1;
            }
            self.fontView.isBlod = self.textStyle.bold;
            imageView.image = [UIImage imageNamed:self.menuSelectIcons[index]];
        }
    }else {
        [self.colorView close];
        [self.fontView close];
    }
    if ([self.delegate respondsToSelector:@selector(lm_segmentedControl:didTapAtIndex:)]) {
        [self.delegate lm_segmentedControl:self didTapAtIndex:index];
    }
}

@end
