//
//  GBFriendCell.m
//  GB_Football
//
//  Created by Pizza on 16/8/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBFriendCell.h"
#import "UIImageView+WebCache.h"
#import <pop/POP.h>

@interface GBFriendCell()
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
// 分隔线
@property (weak, nonatomic) IBOutlet UIView *seprateLine;
// 名称标签
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation GBFriendCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headImageView.clipsToBounds = YES;
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.headImageView.layer setCornerRadius:self.headImageView.width/2];
        [self.headImageView.layer setMasksToBounds:YES];
    });
}

#pragma mark - Public

- (void)refreshWithName:(NSString *)name imageUrl:(NSString *)imageUrl {
    
    self.nameLabel.text = name;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"portrait"]];
}

#pragma mark - Getter and Setter
-(void)setIsLastCell:(BOOL)isLastCell
{
    _isLastCell = isLastCell;
    if (isLastCell) {
        self.seprateLine.backgroundColor = [UIColor blackColor];
    }
}

@end
