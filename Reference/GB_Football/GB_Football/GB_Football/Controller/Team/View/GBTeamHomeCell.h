//
//  GBTeamHomeCell.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBAvatorView.h"
#import "GBPositionLabel.h"
#import "TeamHomeResponeInfo.h"

@interface GBTeamHomeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet GBAvatorView *avatorView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet GBPositionLabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (nonatomic, assign) TeamPalyerType type;

@end
