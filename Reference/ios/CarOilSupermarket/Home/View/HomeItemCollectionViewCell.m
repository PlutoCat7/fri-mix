//
//  HomeItemCollectionViewCell.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/9.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "HomeItemCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface HomeItemCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation HomeItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshWithInfo:(HomeCategoryInfo *)info {
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:info.icon] placeholderImage:[UIImage imageNamed:@"default_icon"]];
    self.nameLabel.text = info.name;
}

@end
