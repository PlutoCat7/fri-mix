//
//  ShoppingCartSectionHeaderView.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/5.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShoppingCartSectionHeaderView;
@protocol ShoppingCartSectionHeaderViewDelegate <NSObject>

- (void)didClickSelectAll:(ShoppingCartSectionHeaderView *)headerView;

@end

@interface ShoppingCartSectionHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (nonatomic, weak) id<ShoppingCartSectionHeaderViewDelegate> delegate;

@end
