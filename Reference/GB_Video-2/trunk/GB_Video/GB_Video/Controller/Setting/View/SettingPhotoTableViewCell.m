//
//  SettingPhotoTableViewCell.m
//  GB_Video
//
//  Created by gxd on 2018/1/31.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "SettingPhotoTableViewCell.h"

@interface SettingPhotoTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation SettingPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
    self.bgView.backgroundColor = highlighted?[UIColor colorWithHex:0xffffff andAlpha:0.5]:[UIColor colorWithHex:0xffffff];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.photoImageView.layer setMasksToBounds:YES];
        [self.photoImageView.layer setCornerRadius:self.photoImageView.width/2];
        
    });
}

@end
