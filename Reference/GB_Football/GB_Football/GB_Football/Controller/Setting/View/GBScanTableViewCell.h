//
//  GBScanTableViewCell.h
//  GB_Football
//
//  Created by weilai on 16/8/29.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBHightLightButton.h"

@interface GBScanTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet GBHightLightButton *bindButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addrLbl;
@property (weak, nonatomic) IBOutlet UILabel *userLbl;
@property (nonatomic, copy) void (^clickBlock)();
@end
