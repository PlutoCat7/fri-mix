//
//  BudgetDetailsTabbleHeaderView.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/25.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXCategorySliderBar.h"
@class BudgetOneClass,SGTopScrollMenu;
@interface BudgetDetailsTabbleHeaderView : UITableViewHeaderFooterView

@property (nonatomic, retain) ZXCategorySliderBar *sliderBar;//不能用 冲突
@property (nonatomic, strong) SGTopScrollMenu *topScrollMenu;
@property (nonatomic, retain) BudgetOneClass *oneClass;
@property (nonatomic, copy) void(^sortBlock)(void);
@property (nonatomic, copy) void(^screenBlock)(void);

@end
