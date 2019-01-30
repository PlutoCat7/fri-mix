//
//  PosterSingleViewCell.m
//  TiHouse
//
//  Created by weilai on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PosterSingleViewCell.h"

@interface PosterSingleViewCell()

@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (strong, nonatomic) KnowModeInfo *knowModeInfo;

@end

@implementation PosterSingleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.containView.layer setMasksToBounds:YES];
    [self.containView.layer setCornerRadius:5.f];
    
    [self.dateLabel.layer setMasksToBounds:YES];
    [self.dateLabel.layer setCornerRadius:5.f];
    self.dateLabel.font = [UIFont fontWithName:@"Heiti SC" size:12];
    
    self.descLabel.numberOfLines = 0;
    
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithKnowModeInfo:(KnowModeInfo *)knowModeInfo date:(NSString *)date {
    
    _knowModeInfo = knowModeInfo;

    NSDate *dateObj = [NSDate dateWithTimeIntervalSince1970:(knowModeInfo.knowctime/1000)];
    NSString *key = [NSString stringWithFormat:@" %02d-%02d %02d:%02d ", (int)dateObj.month, (int)dateObj.day, (int)dateObj.hour, (int)dateObj.minute];
    
    self.dateLabel.text = key;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:knowModeInfo.knowurlindex]];
    self.titleLabel.text = knowModeInfo.knowtitle;
    self.descLabel.text = knowModeInfo.knowtitlesub;
}

- (IBAction)actionItem:(id)sender {
    if (self.clickItemBlock) {
        self.clickItemBlock(_knowModeInfo);
    }
}

+ (CGFloat)calculateHeight:(NSString *)content {
    // 展开后得高度 = 计算出文本内容的高度 + 固定控件的高度
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12.f]};
    
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(320, 0) options:option attributes:attribute context:nil].size;
    
    return size.height + 340;
}

@end
