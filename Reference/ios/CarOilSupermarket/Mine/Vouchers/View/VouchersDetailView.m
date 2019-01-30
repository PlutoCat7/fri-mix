//
//  VouchersDetailView.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/17.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "VouchersDetailView.h"
#import "VouchersBuyCellModel.h"

static const CGFloat kVouchersDetailViewAnimationDuration = 0.25;

@interface VouchersDetailView ()

@property (weak, nonatomic) IBOutlet UIView *animationView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (nonatomic, strong) VouchersBuyCellModel *cellModel;

@end

@implementation VouchersDetailView

+ (void)showWithModel:(VouchersBuyCellModel *)model delegate:(id)delegate {
    
    VouchersDetailView *view = [[NSBundle mainBundle] loadNibNamed:@"VouchersDetailView" owner:self options:nil].firstObject;
    view.frame = [UIApplication sharedApplication].keyWindow.bounds;
    view.delegate = delegate;
    [view refreshWithModel:model];
    [view startAnimate];
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (void)refreshWithModel:(VouchersBuyCellModel *)model {
    
    self.cellModel = model;
    
    self.titleView.text = model.title;
    self.priceLabel.attributedText = model.priceAttributedString;
    self.addButton.enabled = [model isEnable];
    self.infoTextView.text = model.vouchersInfo;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)layoutSubviews {
    

}

#pragma mark - Action

- (IBAction)actionClose:(id)sender {
    
    [UIView animateWithDuration:kVouchersDetailViewAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.animationView.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)actionAdd:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(vouchersDetailViewdidAdd:view:)]){
        [self.delegate vouchersDetailViewdidAdd:self.cellModel view:self];
    }
}

#pragma mark - Private

- (void)startAnimate {
    
    self.animationView.top = self.height;
    [UIView animateWithDuration:kVouchersDetailViewAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn  animations:^{
        self.animationView.bottom = self.height;
    } completion:^(BOOL finished) {
        
    }];
}

@end
