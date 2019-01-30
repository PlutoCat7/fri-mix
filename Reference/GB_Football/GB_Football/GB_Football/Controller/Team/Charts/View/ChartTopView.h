//
//  ChartTopView.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/21.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChartTopView;
@protocol ChartTopViewDelegate <NSObject>

- (void)actionMore:(ChartTopView *)chartTopView;

@end

@interface ChartTopView : UIView

@property (nonatomic, strong) UIColor *textcColor;
@property (nonatomic, weak) id<ChartTopViewDelegate> delegate;

- (void)refreshUIWith:(NSInteger)number text:(NSString *)text detailText:(NSString *)detailText;
- (void)hideMoreButton;

@end
