//
//  MineOptionDetailView.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/23.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MineOptionDetailViewModel;

@protocol MineOptionDetailViewDelegate;

@interface MineOptionDetailView : UIView

@property (nonatomic, weak  ) id<MineOptionDetailViewDelegate> delegate;

- (void)resetViewWithViewModel:(MineOptionDetailViewModel *)viewModel;

@end

@protocol MineOptionDetailViewDelegate <NSObject>

- (void)mineOptionDetailView:(MineOptionDetailView *)view clickViewWithViewModel:(MineOptionDetailViewModel *)viewModel;

@end
