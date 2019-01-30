//
//  FIndPhotoLabelContactCell.m
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FIndPhotoLabelContactCell.h"

@interface FIndPhotoLabelContactCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation FIndPhotoLabelContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithName:(NSString *)name {
    
    _nameLabel.text = [NSString stringWithFormat:@"#%@", name];
}

@end
