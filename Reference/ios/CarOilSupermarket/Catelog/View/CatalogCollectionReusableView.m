//
//  CatalogCollectionReusableView.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/11.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "CatalogCollectionReusableView.h"

@implementation CatalogCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)actionCLick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickCatalogCollectionReusableView:)]) {
        [self.delegate didClickCatalogCollectionReusableView:self];
    }
}
@end
