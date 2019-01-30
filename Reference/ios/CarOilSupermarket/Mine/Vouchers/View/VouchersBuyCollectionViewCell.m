//
//  VouchersBuyCollectionViewCell.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/15.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "VouchersBuyCollectionViewCell.h"
#import "VouchersBuyCellModel.h"

@interface VouchersBuyCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgTopImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgBottomImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reduceViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation VouchersBuyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Public

- (void)refreshWithModel:(VouchersBuyCellModel *)model {
    
    self.titleLabel.text = model.title;
    self.priceLabel.attributedText = model.priceAttributedString;
    
    self.addButton.enabled = [model isEnable];
    if (model.buyCount>0) {
        self.reduceViewWidthConstraint.constant = kVouchersBuyCollectionViewCellWidth/2;
        self.addViewWidthConstraint.constant = kVouchersBuyCollectionViewCellWidth/2;
        self.bgTopImageView.image = [UIImage imageNamed:@"vouchers_buy__selected_top"];
        self.bgBottomImageView.image = [UIImage imageNamed:@"vouchers_buy__selected_bottom"];
        self.countLabel.hidden = NO;
        self.countLabel.text = @(model.buyCount).stringValue;
    }else {
        self.reduceViewWidthConstraint.constant = 0;
        self.addViewWidthConstraint.constant = kVouchersBuyCollectionViewCellWidth;
        self.bgTopImageView.image = [UIImage imageNamed:@"vouchers_buy_top"];
        self.bgBottomImageView.image = [UIImage imageNamed:@"vouchers_buy_bottom"];
        _countLabel.hidden = YES;
    }
}

#pragma mark - Action

- (IBAction)actionReduce:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteButtonWithCell:)]) {
        [self.delegate didDeleteButtonWithCell:self];
    }
}

- (IBAction)actionAdd:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAddButtonWithCell:)]) {
        [self.delegate didAddButtonWithCell:self];
    }
}

#pragma mark - Private

- (UILabel *)countLabel {
    
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25*kAppScale, 25*kAppScale)];
        _countLabel.center = CGPointMake(0.95*self.width, 0.05*self.height);
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:13.0f*kAppScale];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.backgroundColor = [UIColor colorWithHex:0x00A7FF];
        _countLabel.layer.cornerRadius = _countLabel.width/2;
        _countLabel.clipsToBounds = YES;
        [self addSubview:_countLabel];
    }
    return _countLabel;
}

@end
