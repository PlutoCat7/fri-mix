//
//  GBReportCell.h
//  GB_Football
//
//  Created by Pizza on 2017/1/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface GBReportCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet RTLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *englishLabel;

@end
