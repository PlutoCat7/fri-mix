//
//  PointsCell.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/18.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "PointsCell.h"
#import "PointsCellModel.h"

@interface PointsCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation PointsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshWithModel:(PointsCellModel *)model {
    
    self.nameLabel.text = model.name;
    self.dateLabel.text = model.dateString;
    self.countLabel.text = model.point;
    self.countLabel.textColor = model.pointColor;
}

@end
