//
//  TracticsSinglePlayerCollectionViewCell.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "LineUpSinglePlayerCollectionViewCell.h"

@interface LineUpSinglePlayerCollectionViewCell ()
@property (strong, nonatomic) UIButton *deleteBtn;

@end

@implementation LineUpSinglePlayerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"invite_friends_dekete"] forState:UIControlStateNormal];
    [self.contentView addSubview:button];
    self.deleteBtn = button;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.nameView.layer.cornerRadius = 4.f;
    self.deleteBtn.top  = 0;
    self.deleteBtn.right = self.width;
}

- (void)setHasSelected:(BOOL)hasSelected {
    
    _hasSelected = hasSelected;
    self.avatorView.bgColor = hasSelected?[UIColor colorWithHex:0x01ff00]:[UIColor colorWithHex:0x252525];
}

- (void)setShowDeleteIcon:(BOOL)showDeleteIcon {
    
    _showDeleteIcon = showDeleteIcon;
    self.deleteBtn.hidden = !showDeleteIcon;
}

- (IBAction)deleteAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickDeleteBtn:)]) {
        [self.delegate didClickDeleteBtn:self];
    }
}


@end
