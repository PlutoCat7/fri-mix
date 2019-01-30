//
//  HomeTableViewCell.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/5.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "HomeTableViewCell.h"

#import "UIImageView+WebCache.h"

@interface HomeTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *item1View;
@property (weak, nonatomic) IBOutlet UIView *item2View;

@property (weak, nonatomic) IBOutlet UIImageView *item1ImageView;
@property (weak, nonatomic) IBOutlet UILabel *item1NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *item1PriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *item1PointsLabel;


@property (weak, nonatomic) IBOutlet UIImageView *item2ImageView;
@property (weak, nonatomic) IBOutlet UILabel *item2NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *item2PriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *item2PointsLabel;


@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Action

- (void)refreshWithData:(NSArray<HomeGoodsInfo *> *)goods {
    
    HomeGoodsInfo *firstGoodsInfo = [goods firstObject];
    [self.item1ImageView sd_setImageWithURL:[NSURL URLWithString:firstGoodsInfo.thumb] placeholderImage:[UIImage imageNamed:@"default_icon"]];
    self.item1NameLabel.text = firstGoodsInfo.title;
    self.item1PriceLabel.text = firstGoodsInfo.price;
    self.item1PointsLabel.hidden = [firstGoodsInfo.pointsTxt floatValue] <= 0;
    self.item1PointsLabel.text = [NSString stringWithFormat:@" %@ ", firstGoodsInfo.pointsTxt];
    if (goods.count == 2) {
        self.item2View.hidden = NO;
        HomeGoodsInfo *secondGoodsInfo = [goods lastObject];
        [self.item2ImageView sd_setImageWithURL:[NSURL URLWithString:secondGoodsInfo.thumb] placeholderImage:[UIImage imageNamed:@"default_icon"]];
        self.item2NameLabel.text = secondGoodsInfo.title;
        self.item2PriceLabel.text = secondGoodsInfo.price;
        self.item2PointsLabel.hidden = [secondGoodsInfo.pointsTxt floatValue] == 0;
        self.item2PointsLabel.text = [NSString stringWithFormat:@" %@ ", secondGoodsInfo.pointsTxt];
    }else {
        self.item2View.hidden = YES;
    }
}

- (IBAction)item1Action:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickCell:index:)]) {
        [self.delegate didClickCell:self index:0];
    }
}

- (IBAction)item2Action:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickCell:index:)]) {
        [self.delegate didClickCell:self index:1];
    }
}

@end
