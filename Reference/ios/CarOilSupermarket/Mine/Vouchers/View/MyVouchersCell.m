//
//  MyVouchersCell.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/14.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "MyVouchersCell.h"
#import "MyVouchersCellModel.h"

@interface MyVouchersCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *validDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *worthLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;


@end

@implementation MyVouchersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithModel:(MyVouchersCellModel *)model {
    
    self.titleLabel.text = model.title;
    self.validDateLabel.text = model.validDate;
    self.worthLabel.attributedText = model.worthAttributedString;
    self.buyLabel.text = model.buyDate;
    self.selectImageView.hidden = !model.isSelected;
}

@end
