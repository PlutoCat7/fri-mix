//
//  ShoppingEmptyView.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/3.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "ShoppingEmptyView.h"

@interface ShoppingEmptyView ()

@property (weak, nonatomic) IBOutlet UIButton *lookupButton;

@end

@implementation ShoppingEmptyView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.lookupButton.layer.cornerRadius = 5.0f;
}

- (IBAction)actionLookup:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickLookup)]) {
        [self.delegate didClickLookup];
    }
}
@end
