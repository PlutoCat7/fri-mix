//
//  GBMallCell.m
//  GB_Football
//
//  Created by Pizza on 2016/12/5.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBMallCell.h"
#import "UIImageView+WebCache.h"

@interface GBMallCell()
@property (weak, nonatomic) IBOutlet UIButton       *button;
@property (weak, nonatomic) IBOutlet UIImageView    *adImageView;

@end

@implementation GBMallCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)refreshWithImageUrl:(NSString *)imageUrl
{
    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"place_holder_image"]];
}

- (IBAction)actionPress:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(GBMallCellDidSelect:)]) {
        [self.delegate GBMallCellDidSelect:self];
    }
}

@end
