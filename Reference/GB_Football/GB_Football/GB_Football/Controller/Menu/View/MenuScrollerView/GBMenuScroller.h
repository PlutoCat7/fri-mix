//
//  GBMenuScroller.h
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/7/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMenuScrollerHeight 125.0

@class GBMenuScroller;
@protocol GBMenuScrollerDelegate <NSObject>

@optional
- (void)menuScroller:(GBMenuScroller *)menuScroller didSelectItemAtIndex:(NSInteger)index;
- (void)menuScroller:(GBMenuScroller *)menuScroller didEndScrollingAtIndex:(NSInteger)index;
- (void)menuScroller:(GBMenuScroller *)menuScroller didChangeItemAtIndex:(NSInteger)index;

@end

@interface GBMenuScroller : UIView

@property (nonatomic, weak) id<GBMenuScrollerDelegate> delegate;
@property (nonatomic, assign, readonly)  NSInteger currentIndex;

- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames currentIndex:(NSInteger)index;

- (void)setCurrentMovieIndex:(NSInteger)index animated:(BOOL)animated;
- (void)setImageName:(NSString*)imageName currentIndex:(NSInteger)index;
// 修改内部图片接口
- (void)setupIcons:(NSArray<NSString*>*)imageNames;

@end
