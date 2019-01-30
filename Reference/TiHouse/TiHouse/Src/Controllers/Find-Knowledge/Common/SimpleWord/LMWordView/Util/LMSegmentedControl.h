//
//  LMSegmentedControl.h
//  SimpleWord
//
//  Created by Chenly on 16/5/13.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMTextStyle.h"

#define kLMSegmentedControlHeight  (43)

@class LMSegmentedControl;

@protocol LMSegmentedControlDelegate <NSObject>

- (void)lm_segmentedControl:(LMSegmentedControl *)control didTapAtIndex:(NSInteger)index;

- (void)lm_segmentedControl:(LMSegmentedControl *)control didChangedTextStyle:(LMTextStyle *)textStyle;

@end

@interface LMSegmentedControl : UIControl

@property (nonatomic, weak) id<LMSegmentedControlDelegate> delegate;
@property (nonatomic, strong) LMTextStyle *textStyle;

@property (nonatomic, readonly) NSInteger numberOfSegments;
@property (nonatomic, readonly) NSInteger selectedSegmentIndex;

- (void)clearUI;

@end
