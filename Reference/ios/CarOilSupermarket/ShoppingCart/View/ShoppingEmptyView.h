//
//  ShoppingEmptyView.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/3.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNibBridge.h"

@protocol ShoppingEmptyViewDelegate <NSObject>

- (void)didClickLookup;

@end

@interface ShoppingEmptyView : UIView <XXNibBridge>

@property (nonatomic, weak) id<ShoppingEmptyViewDelegate> delegate;

@end
