//
//  MakeOrderHeaderView.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/10.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MakeOrderHeaderModel.h"

@class MakeOrderHeaderView;
@protocol MakeOrderHeaderViewDelegate <NSObject>

- (void)didClickHeaderView:(MakeOrderHeaderView *)view;

@end

@interface MakeOrderHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIImageView *nextPageImageView;
@property (nonatomic, weak) id<MakeOrderHeaderViewDelegate> delegate;

- (void)refreshWithModel:(MakeOrderHeaderModel *)model;

@end
