//
//  GBSortPan.h
//  GB_Team
//
//  Created by Pizza on 2016/11/29.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBSortPan;
@protocol GBSortPanDelegate <NSObject>
-(void)GBSortPan:(GBSortPan*)sorPan index:(NSInteger)index;
@end

@interface GBSortPan : UIView
@property (nonatomic,assign) NSInteger index;// 类型: 0 移动距离 1 最高速度 2 体能消耗
@property (nonatomic,weak) id<GBSortPanDelegate> delegate;
@end
