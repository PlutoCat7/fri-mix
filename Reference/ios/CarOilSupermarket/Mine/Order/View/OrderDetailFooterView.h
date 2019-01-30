//
//  OrderDetailFooterView.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/17.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailFooterView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *expresscomLabel;
@property (weak, nonatomic) IBOutlet UILabel *expresssnLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
