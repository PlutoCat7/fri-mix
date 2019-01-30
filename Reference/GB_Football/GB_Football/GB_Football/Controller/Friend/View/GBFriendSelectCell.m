//
//  GBFriendSelectCell.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBFriendSelectCell.h"

@interface GBFriendSelectCell ()

@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UIView *coverView;

@end

@implementation GBFriendSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userImageView.clipsToBounds = YES;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.userImageView.layer setCornerRadius:self.userImageView.width/2];
        [self.userImageView.layer setMasksToBounds:YES];
    });
}

- (void)setType:(GBFriendSelectCellType)type {
    
    _type = type;
    switch (type) {
        case GBFriendSelectCell_Selected:
            self.selectImageView.image = [UIImage imageNamed:@"invite_checkboxmark"];
            self.selectImageView.hidden = NO;
            self.coverView.hidden = YES;
            break;
        case GBFriendSelectCell_NotSelected:
            self.selectImageView.hidden = YES;
            self.coverView.hidden = NO;
            break;
        case GBFriendSelectCell_UnSelected:
            self.selectImageView.image = [UIImage imageNamed:@"invite_checkboxmark_x"];
            self.selectImageView.hidden = NO;
            self.coverView.hidden = YES;
            break;
            
        default:
            break;
    }
}

@end
