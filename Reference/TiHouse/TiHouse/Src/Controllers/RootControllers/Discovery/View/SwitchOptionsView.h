//
//  SwitchOptionsView.h
//  YouSuHuoPinDot
//
//  Created by Teen Ma on 2017/11/2.
//  Copyright © 2017年 Teen Ma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchOptionsViewModel;

@protocol SwitchOptionsViewDelegate;

@interface SwitchOptionsView : UIView

@property (nonatomic, weak ) id<SwitchOptionsViewDelegate> delegate;

- (void)resetViewWithArray:(NSMutableArray *)viewModels;

- (void)refreshOptionViewWithIndex:(NSInteger)index;

@end

@protocol SwitchOptionsViewDelegate <NSObject>

- (void)switchOptionsView:(SwitchOptionsView *)view clickOptionWithViewModel:(SwitchOptionsViewModel *)viewModel;

@end
