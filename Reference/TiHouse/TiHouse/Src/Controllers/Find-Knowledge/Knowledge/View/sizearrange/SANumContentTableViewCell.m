//
//  SANumContentTableViewCell.m
//  TiHouse
//
//  Created by weilai on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SANumContentTableViewCell.h"

@interface SANumContentTableViewCell()

@property (strong, nonatomic) KnowModeInfo *knowModeInfo;
@end

@implementation SANumContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentLabel.numberOfLines = 0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)refreshWithKnowModeInfo:(KnowModeInfo *)knowModeInfo {
    _knowModeInfo = knowModeInfo;
    _contentLabel.text = knowModeInfo.knowcontentdown;
    
}

- (IBAction)actionItem:(id)sender {
    if (self.clickItemBlock) {
        self.clickItemBlock(_knowModeInfo);
    }
}

- (CGFloat)contentHeight:(NSString *)content{
    
    // 展开后得高度 = 计算出文本内容的高度 + 固定控件的高度
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12.f]};
    
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(kScreen_Width - 40, 0) options:option attributes:attribute context:nil].size;
    
    return size.height;
    
}

+ (CGFloat)defaultHeight:(NSString *)content{
    
    // 展开后得高度 = 计算出文本内容的高度 + 固定控件的高度
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12.f]};
    
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(kScreen_Width - 40, 0) options:option attributes:attribute context:nil].size;
    
    return size.height + 35;
    
}

@end
