//
//  SearchHistoryCell.m
//  TiHouse
//
//  Created by weilai on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SearchHistoryCell.h"

@interface SearchHistoryCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) KnowLabelInfo *knowLabelInfo;

@end

@implementation SearchHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithKnowLabelInfo:(KnowLabelInfo *)knowLabelInfo {
    _knowLabelInfo = knowLabelInfo;
    
    self.nameLabel.text = knowLabelInfo.lableknowname;
}

- (IBAction)actionDelete:(id)sender {
    if (self.clickItemDel) {
        self.clickItemDel(_knowLabelInfo);
    }
}

@end
