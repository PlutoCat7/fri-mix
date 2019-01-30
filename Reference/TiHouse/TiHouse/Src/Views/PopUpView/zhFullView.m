//
//  zhFullView.m
//  zhPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "zhFullView.h"
#import "NSDate+Extend.h"
#import "zhIconLabel.h"

@interface zhFullView () <UIScrollViewDelegate> {
    CGFloat _gap, _space;
}
@property (nonatomic, strong) UILabel  *dateLabel;
@property (nonatomic, strong) UILabel  *weekLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *closeIcon;
@property (nonatomic, strong) UIScrollView *scrollContainer;
@property (nonatomic, strong) UIView *lineview;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *pageViews;

@end

@implementation zhFullView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullViewClicked:)]];
        
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont fontWithName:@"Heiti SC" size:30];
        _dateLabel.textColor = kRKBNAVBLACK;
//        _dateLabel.textColor = [UIColor blackColor];
        [self addSubview:_dateLabel];
        
        _weekLabel = [UILabel new];
        _weekLabel.numberOfLines = 0;
        _weekLabel.font = [UIFont fontWithName:@"Heiti SC" size:14];
        _weekLabel.textColor = kRKBNAVBLACK;
        [self addSubview:_weekLabel];
        
        _lineview = [UIView new];
        _lineview.backgroundColor = kLineColer;
        [self addSubview:_lineview];
        
        _closeButton = [UIButton new];
        _closeButton.backgroundColor = [UIColor clearColor];
        _closeButton.userInteractionEnabled = NO;
        [_closeButton addTarget:self action:@selector(closeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
        
        _closeIcon = [UIButton new];
        _closeIcon.userInteractionEnabled = NO;
        _closeIcon.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_closeIcon setImage:[UIImage imageNamed:@"close_sw"] forState:UIControlStateNormal];
        [self addSubview:_closeIcon];
        
        [self setContent];
        [self commonInitialization];
    }
    return self;
}

- (void)setContent {
    NSDate *date = [NSDate date];
    _dateLabel.text = [NSString stringWithFormat:@"%@", [NSDate ymdFormat]];
    _dateLabel.size = [_dateLabel sizeThatFits:CGSizeMake(100, 40)];
    _dateLabel.origin = CGPointMake(42, 67);
    
    NSString *text = [NSString stringWithFormat:@"%@", date.dayFromWeekday];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    [paragraphStyle setLineSpacing:5];
    _weekLabel.attributedText = string;
    _weekLabel.size = [_weekLabel sizeThatFits:CGSizeMake(42, 30)];
    _weekLabel.origin = CGPointMake(42, 107);
//    _weekLabel.x = _dateLabel.right + 10;
//    _weekLabel.centerY = _dateLabel.centerY;
    
    _lineview.size = CGSizeMake(kScreen_Width*0.8, 0.5);
    _lineview.bottom = kScreen_Height - 72;
    _lineview.centerX = self.centerX;

    _closeButton.size = CGSizeMake(kScreen_Width, 72);
    _closeButton.bottom = kScreen_Height;
    _closeIcon.size = CGSizeMake(20, 20);
    _closeIcon.center = _closeButton.center;
}

- (void)commonInitialization {
    _scrollContainer = [UIScrollView new];
    _scrollContainer.bounces = NO;
    _scrollContainer.pagingEnabled = YES;
    _scrollContainer.showsHorizontalScrollIndicator = NO;
    _scrollContainer.delaysContentTouches = YES;
    _scrollContainer.delegate = self;
    [self addSubview:_scrollContainer];
    
    _itemSize = CGSizeMake(60, 95);
    _gap = 15;
    _space = (kScreen_Width - ROW_COUNT * _itemSize.width) / (ROW_COUNT + 1);
    
    _scrollContainer.size = CGSizeMake(kScreen_Width, _itemSize.height * ROWS + _gap  + 150);
    _scrollContainer.bottom = kScreen_Height - _closeButton.height;
    _scrollContainer.contentSize = CGSizeMake(PAGES * kScreen_Width, _scrollContainer.height);
    
    _pageViews = @[].mutableCopy;
    for (NSInteger i = 0; i < PAGES; i++) {
        UIImageView *pageView = [UIImageView new];
        pageView.size = _scrollContainer.size;
        pageView.x = i * kScreen_Width;
        pageView.userInteractionEnabled = YES;
        [_scrollContainer addSubview:pageView];
        [_pageViews addObject:pageView];
    }
}

- (void)setModels:(NSArray<zhIconLabelModel *> *)models {
    
    _items = @[].mutableCopy;
    [_pageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSInteger i = 0; i < ROWS * ROW_COUNT; i++) {
            NSInteger l = i % ROW_COUNT;
            NSInteger v = i / ROW_COUNT;
            
            zhIconLabel *item = [zhIconLabel new];
            [imageView addSubview:item];
            [_items addObject:item];
            item.tag = i + idx * (ROWS *ROW_COUNT);
            if (item.tag < models.count) {
                [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked:)]];
                item.model = [models objectAtIndex:item.tag];
                item.iconView.userInteractionEnabled = NO;
                item.textLabel.font = [UIFont systemFontOfSize:14];
                item.textLabel.textColor = kRKBNAVBLACK;
                [item updateLayoutBySize:_itemSize finished:^(zhIconLabel *item) {
                    item.x = _space + (_itemSize.width  + _space) * l;
                    item.y = (_itemSize.height + _gap) * v + _gap + 70;
                }];
            }
        }
    }];
    
    [self startAnimationsCompletion:NULL];
}

- (void)fullViewClicked:(UITapGestureRecognizer *)recognizer {
    __weak typeof(self) _self = self;
    [self endAnimationsCompletion:^(zhFullView *fullView) {
        if (nil != self.didClickFullView) {
            _self.didClickFullView((zhFullView *)recognizer.view);
        }
    }];
}

- (void)itemClicked:(UITapGestureRecognizer *)recognizer  {
//    if (ROWS * ROW_COUNT - 1 == recognizer.view.tag) {
//        [_scrollContainer setContentOffset:CGPointMake(kScreen_Width, 0) animated:YES];
//    } else {
        if (nil != self.didClickItems) {
            self.didClickItems(self, recognizer.view.tag);
        }
//    }
}

- (void)closeClicked:(UIButton *)sender {
    [_scrollContainer setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x /kScreen_Width + 0.5;
    _closeButton.userInteractionEnabled = index > 0;
    [_closeIcon setImage:[UIImage imageNamed:(index ? @"Add_Icon" : @"Add_Icon")] forState:UIControlStateNormal];
}

- (void)startAnimationsCompletion:(void (^ __nullable)(BOOL finished))completion {
    
    [UIView animateWithDuration:0.5 animations:^{
        _closeIcon.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:NULL];
    
    [_items enumerateObjectsUsingBlock:^(zhIconLabel *item, NSUInteger idx, BOOL * _Nonnull stop) {
        item.alpha = 0;
        item.transform = CGAffineTransformMakeTranslation(0, ROWS * _itemSize.height);
        [UIView animateWithDuration:0.85
                              delay:idx * 0.035
             usingSpringWithDamping:0.6
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             item.alpha = 1;
                             item.transform = CGAffineTransformIdentity;
                         } completion:completion];
    }];
}

- (void)endAnimationsCompletion:(void (^)(zhFullView *))completion {
    if (!_closeButton.userInteractionEnabled) {
        [UIView animateWithDuration:0.35 animations:^{
            _closeIcon.transform = CGAffineTransformIdentity;
        } completion:NULL];
    }
    
    [_items enumerateObjectsUsingBlock:^(zhIconLabel * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        [UIView animateWithDuration:0.25
                              delay:0.04f * (_items.count - idx)
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             item.alpha = 0;
                             item.transform = CGAffineTransformMakeTranslation(0, ROWS * _itemSize.height);
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 if (idx == _items.count - 1) {
                                     completion(self);
                                 }
                             }
                         }];
    }];
}

@end
