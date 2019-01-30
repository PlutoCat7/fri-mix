//
//  MakeOrderHeaderView.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/10.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "MakeOrderHeaderView.h"

@interface MakeOrderHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *receiverLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation MakeOrderHeaderView

- (void)refreshWithModel:(MakeOrderHeaderModel *)model {
    
    self.receiverLabel.text = model.receiverName;
    self.phoneLabel.text = model.phone;
    self.addressLabel.text = model.address;
}

- (IBAction)actionClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickHeaderView:)]) {
        [self.delegate didClickHeaderView:self];
    }
}


@end
