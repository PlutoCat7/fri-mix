//
//  GoodsHeaderView.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/18.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "GoodsHeaderView.h"
#import "SDCycleScrollView.h"

#import "GoodsHeaderModel.h"

@interface GoodsHeaderView ()
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;

@end

@implementation GoodsHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.cycleScrollView.placeholderImage = [UIImage imageNamed:@"default_icon"];
    self.cycleScrollView.pageControlAliment  = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView.currentPageDotColor = [ColorManager styleColor];
    self.cycleScrollView.pageDotColor = [UIColor lightGrayColor];
    self.cycleScrollView.autoScrollTimeInterval = 3.f;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.cycleScrollView.currentPageDotColor = [ColorManager styleColor];
}

- (void)refreshWithModel:(GoodsHeaderModel *)model {
    
    self.cycleScrollView.imageURLStringsGroup = model.imagesURL;
    self.titleLabel.text = model.title;
    self.nowPriceLabel.text = model.nowPriceString;
    self.oldPriceLabel.text = model.oldPriceString;
    self.saleDescLabel.text = model.saleDesc;
    self.pointLabel.hidden = model.point.floatValue <= 0;
    self.pointLabel.text = [NSString stringWithFormat:@" %@ ", model.point];
}

@end
