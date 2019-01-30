//
//  MyOrderHeaderMenuView.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/16.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyOrderHeaderMenuViewDelegate<NSObject>

- (void)menuDidSelectWithIndex:(NSInteger)index;

@end

@interface MyOrderHeaderMenuView : UIView

@property (nonatomic, strong) NSArray<NSString *> *titles;

@property (nonatomic, weak) id<MyOrderHeaderMenuViewDelegate> delegate;

@property (nonatomic, assign) NSInteger selectIndex;

@end
