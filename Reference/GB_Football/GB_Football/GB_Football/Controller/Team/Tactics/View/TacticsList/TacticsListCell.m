//
//  TacticsListCell.m
//  GB_Football
//
//  Created by yahua on 2018/1/12.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "TacticsListCell.h"
#import "TacticsListViewModel.h"

@interface TacticsListCell ()

@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *tacticsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateStringLabel;

@end

@implementation TacticsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithModel:(TacticsListCellModel *)cellModel {
    
    self.numLabel.attributedText = cellModel.playerNumberAttributedString;
    self.tacticsNameLabel.text = cellModel.tacticsName;
    self.dateStringLabel.text = cellModel.dateString;
}

@end
