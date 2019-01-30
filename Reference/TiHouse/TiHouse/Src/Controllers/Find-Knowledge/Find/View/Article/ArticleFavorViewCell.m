//
//  ArticleFavorViewCell.m
//  TiHouse
//
//  Created by weilai on 2018/2/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ArticleFavorViewCell.h"

@interface ArticleFavorViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *articleTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *collectionButton;

@property (strong, nonatomic) FindAssemarcInfo * info;
@end

@implementation ArticleFavorViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.avatorImageView.layer.cornerRadius = self.avatorImageView.height/2;
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithInfo:(FindAssemarcInfo *)info {
    _info = info;
    
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:info.urlhead]];
    self.userNameLabel.text = info.username;
    self.dateLabel.text = info.createtimeStr;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:info.urlindex]];
    self.articleTitleLabel.text = info.assemarctitle;
    
    self.collectionButton.selected = info.assemarciscoll;
    
}

#pragma mark - Action

- (IBAction)actonCollection:(id)sender {
    
    if (self.clickFavorBlock) {
        self.clickFavorBlock(_info);
    }
}

+ (CGFloat)defaultHeight:(NSString *)content{
    
    // 展开后得高度 = 计算出文本内容的高度 + 固定控件的高度
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14.f]};
    
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(kScreen_Width - 40, 0) options:option attributes:attribute context:nil].size;
    
    return size.height + 270;
    
}

@end
