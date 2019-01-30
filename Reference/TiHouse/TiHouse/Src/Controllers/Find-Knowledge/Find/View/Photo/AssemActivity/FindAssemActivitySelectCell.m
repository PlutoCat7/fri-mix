//
//  FindAssemActivitySelectCell.m
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindAssemActivitySelectCell.h"

@interface FindAssemActivitySelectCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end

@implementation FindAssemActivitySelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithName:(NSString *)name isSelect:(BOOL)isSelect {
    
    _nameLabel.text = [NSString stringWithFormat:@"#%@#", name];
    self.selectImageView.image = [UIImage imageNamed:isSelect?@"find_assem_activity_selected":@"find_assem_activity_unselected"];
    
}

@end
