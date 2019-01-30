//
//  KTextTableViewCell.m
//  TiHouse
//
//  Created by weilai on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "KTextTableViewCell.h"

@implementation KTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.descLabel.layer setCornerRadius:self.descLabel.size.height / 2.f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
