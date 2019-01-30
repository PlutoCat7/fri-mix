//
//  FindDraftCell.m
//  TiHouse
//
//  Created by yahua on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindDraftCell.h"
#import "FindDraftCellModel.h"
#import "UIImageView+WebCache.h"

@interface FindDraftCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView; //封面
@property (weak, nonatomic) IBOutlet UIView *emptyCoverView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *editDateLabel;

@end

@implementation FindDraftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshWithModel:(FindDraftCellModel *)model {
    
    self.titleLabel.text = model.title;
    self.editDateLabel.text = model.editDateString;
    if (!model.coverImageUrl) {
        self.emptyCoverView.hidden = NO;
    }else {
        self.emptyCoverView.hidden = YES;
        [self.coverImageView sd_setImageWithURL:model.coverImageUrl placeholderImage:nil];
    }
}

@end
