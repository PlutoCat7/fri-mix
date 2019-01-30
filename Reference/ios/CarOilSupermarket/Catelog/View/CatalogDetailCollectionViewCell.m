//
//  CatalogDetailCollectionViewCell.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/10.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "CatalogDetailCollectionViewCell.h"

#import "UIImageView+WebCache.h"

@interface CatalogDetailCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *item1ImageView;
@property (weak, nonatomic) IBOutlet UILabel *item1NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *item1PriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *item1PriceHideLabel;
@property (weak, nonatomic) IBOutlet UILabel *item1PointsLabel;

@end

@implementation CatalogDetailCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)refreshWithData:(HomeGoodsInfo *)goodInfo {
    
    [self.item1ImageView sd_setImageWithURL:[NSURL URLWithString:goodInfo.thumb] placeholderImage:[UIImage imageNamed:@"default_icon"]];
    self.item1NameLabel.text = goodInfo.title;
    self.item1PriceLabel.text = goodInfo.price;
    self.item1PointsLabel.hidden = [goodInfo.pointsTxt floatValue] <= 0;
    self.item1PointsLabel.text = [NSString stringWithFormat:@" %@ ", goodInfo.pointsTxt];
}

@end
