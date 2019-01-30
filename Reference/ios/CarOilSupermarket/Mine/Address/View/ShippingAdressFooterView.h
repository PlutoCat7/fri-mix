//
//  ShippingAdressFooterView.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/30.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShippingAdressFooterViewDelegate <NSObject>

- (void)didClickShippingAdressFooterView;

@end

@interface ShippingAdressFooterView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<ShippingAdressFooterViewDelegate> delegate;

@end
