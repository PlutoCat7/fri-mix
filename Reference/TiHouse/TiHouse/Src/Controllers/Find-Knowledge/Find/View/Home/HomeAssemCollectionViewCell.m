//
//  HomeAssemCollectionViewCell.m
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "HomeAssemCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface HomeAssemCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation HomeAssemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshWithInfo:(FindAssemActivityInfo *)info {
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:info.assemurlindex]];
    self.nameLabel.text = info.assemtitle;
}

@end
