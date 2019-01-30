//
//  AdverHeadView.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdverHeadViewModel;

@protocol AdverHeadViewDelegate;

@interface AdverHeadView : UIView

@property (nonatomic, weak  ) id<AdverHeadViewDelegate> delegate;

- (void)resetViewWithViewModel:(AdverHeadViewModel *)viewModel;

@end

@protocol AdverHeadViewDelegate <NSObject>

- (void)adverHeadView:(AdverHeadView *)view clickLargeImageWithViewModel:(AdverHeadViewModel *)viewModel;

@end
