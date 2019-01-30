//
//  SAAnswerTableViewCell.m
//  TiHouse
//
//  Created by weilai on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SAAnswerTableViewCell.h"

@interface SAAnswerTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *favorImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) KnowModeInfo *knowModeInfo;

@end

@implementation SAAnswerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithKnowModeInfo:(KnowModeInfo *)knowModeInfo isFontBold:(BOOL)isFontBold {
    _knowModeInfo = knowModeInfo;
    
    if (_knowModeInfo.knowiscoll) {
        self.favorImageView.image = [UIImage imageNamed:@"klistfavor.png"];
    } else {
        self.favorImageView.image = [UIImage imageNamed:@"klistunfavor.png"];
    }
    self.titleLabel.text = _knowModeInfo.knowtitle;
    if (isFontBold) {
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    }
    
    NSString *content = _knowModeInfo.knowtitlesub.length == 0 ? _knowModeInfo.knowcontentdown : [NSString stringWithFormat:@"%@\n%@", _knowModeInfo.knowtitlesub, _knowModeInfo.knowcontentdown];
    self.contentLabel.text = content;
}

- (IBAction)actionItem:(id)sender {
    if (self.clickItemBlock) {
        self.clickItemBlock(_knowModeInfo);
    }
}

- (IBAction)actionFavor:(id)sender {
    if (self.clickFavorBlock) {
        self.clickFavorBlock(_knowModeInfo);
    }
}

- (CGFloat)contentHeight:(NSString *)content{
    
    // 展开后得高度 = 计算出文本内容的高度 + 固定控件的高度
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12.f]};
    
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(kScreen_Width - 40, 0) options:option attributes:attribute context:nil].size;
    
    return size.height + 10;
    
}

+ (CGFloat)defaultHeight:(NSString *)content{
    
    // 展开后得高度 = 计算出文本内容的高度 + 固定控件的高度
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12.f]};
    
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(kScreen_Width - 40, 0) options:option attributes:attribute context:nil].size;
    
    return size.height + 95;
    
}

@end
