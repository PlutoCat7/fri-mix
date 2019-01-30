//
//  FindArtTableViewCell.m
//  TiHouse
//
//  Created by weilai on 2018/4/16.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindArtTableViewCell.h"

@interface FindArtTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *artImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation FindArtTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.artImageView.layer setMasksToBounds:YES];
    [self.artImageView.layer setCornerRadius:5.f];
    
    [self.avatorImageView.layer setMasksToBounds:YES];
    [self.avatorImageView.layer setCornerRadius:self.avatorImageView.bounds.size.width/2.f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithModel:(FindAssemarcInfo *)model {
    self.titleLable.text = model.assemarctitle;
    self.nameLabel.text = model.username;
    
    [self.artImageView sd_setImageWithURL:[NSURL URLWithString:model.urlindex]];
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:model.urlhead]];
}

@end
