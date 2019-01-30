//
//  TracticsPlayerSelectCollectionViewCell.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "LineUpPlayerSelectCollectionViewCell.h"

@interface LineUpPlayerSelectCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *avatorContainerView;

@end

@implementation LineUpPlayerSelectCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.avatorContainerView.layer.cornerRadius = self.avatorContainerView.width/2;
    self.avatorImageView.layer.cornerRadius = self.avatorImageView.width/2;
}

@end
