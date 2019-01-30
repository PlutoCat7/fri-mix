//
//  PlayTopToolBar.h
//  PlayView
//
//  Created by Rainy on 2017/12/29.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>

//顶部底部工具条高度
#define ToolBarHeight     50

@class CLPlayTopToolBar;

@protocol CLPlayTopToolBarDelegate <NSObject>

- (void)didClickBackInPlayTopToolBar:(CLPlayTopToolBar *)topToolBar;

@end

@interface CLPlayTopToolBar : UIView

@property (nonatomic, weak) id<CLPlayTopToolBarDelegate> delegate;

- (void)setTitle:(NSString *)title;

@end
