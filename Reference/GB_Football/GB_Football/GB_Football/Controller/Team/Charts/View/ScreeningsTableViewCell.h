//
//  ScreeningsTableViewCell.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/21.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreeningsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *colorSquare;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;

@end
