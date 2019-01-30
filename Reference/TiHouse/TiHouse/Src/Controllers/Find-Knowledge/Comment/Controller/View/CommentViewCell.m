//
//  CommentViewCell.m
//  TiHouse
//
//  Created by weilai on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommentViewCell.h"
#import "KnowledgeUtil.h"

#define ContentWidth kScreen_Width-75

@interface CommentViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avtorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *zanImageView;
@property (weak, nonatomic) IBOutlet UILabel *zanCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (strong, nonatomic) id commentInfo;

@end

@implementation CommentViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentLabel.numberOfLines = 0;
    self.commentLabel.numberOfLines = 0;
    
    [self.avtorImageView.layer setMasksToBounds:YES];
    [self.avtorImageView.layer setCornerRadius:self.avtorImageView.bounds.size.width/2];
    
    self.commentLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    
    [self.commentLabel addGestureRecognizer:labelTapGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithCommentInfo:(id)comment  type:(CommentType)type {
    _commentInfo = comment;
    
    if (type == CommentType_Asse) {
        FindAssemarcCommentInfo *commentInfo = comment;
        _nameLabel.text = commentInfo.assemarccommname;
        if (commentInfo.assemarccommnameon.length == 0) {
            _contentLabel.text = @"";
            _lineView.hidden = YES;
            
        } else {
            NSString *string = [NSString stringWithFormat:@"%@:%@", commentInfo.assemarccommnameon, commentInfo.assemarccommcontentsub];
            NSRange range = [string rangeOfString: commentInfo.assemarccommcontentsub];
            NSMutableAttributedString*attribute = [[NSMutableAttributedString alloc] initWithString: string];
            [attribute addAttributes: @{NSForegroundColorAttributeName: [UIColor colorWithRGBHex:0x222222]}range: range];
            [attribute addAttributes: @{NSForegroundColorAttributeName: [UIColor colorWithRGBHex:0x606060]}range: NSMakeRange(0, range.location)];
            
            _contentLabel.attributedText = attribute;
//            _contentLabel.text = [NSString stringWithFormat:@"%@:%@", commentInfo.assemarccommnameon, commentInfo.assemarccommcontentsub];
            _lineView.hidden = NO;
        }
        _commentLabel.text = commentInfo.assemarccommcontent;
        _zanCountLabel.text = [NSString stringWithFormat:@"%td", commentInfo.assemarccommnumzan];
        _timeLabel.text = [KnowledgeUtil compareCurrentTime:(commentInfo.assemarccommctime)/1000];
        if (commentInfo.assemarccommiszan) {
            _zanImageView.image = [UIImage imageNamed:@"czan"];
        } else {
            _zanImageView.image = [UIImage imageNamed:@"cnozan"];
        }
        
        [_avtorImageView sd_setImageWithURL:[NSURL URLWithString:commentInfo.assemarccommurlhead]];
        
    } else {
        CommentInfo *commentInfo = comment;
        _nameLabel.text = commentInfo.knowcommname;
        if (commentInfo.knowcommnameon.length == 0) {
            _contentLabel.text = @"";
            _lineView.hidden = YES;
            
        } else {
            NSString *string = [NSString stringWithFormat:@"%@:%@", commentInfo.knowcommnameon, commentInfo.knowcommcontentsub];
            NSRange range = [string rangeOfString: commentInfo.knowcommcontentsub];
            NSMutableAttributedString*attribute = [[NSMutableAttributedString alloc] initWithString: string];
            [attribute addAttributes: @{NSForegroundColorAttributeName: [UIColor colorWithRGBHex:0x222222]}range: range];
            [attribute addAttributes: @{NSForegroundColorAttributeName: [UIColor colorWithRGBHex:0x606060]}range: NSMakeRange(0, range.location)];
            
            _contentLabel.attributedText = attribute;
            
//            _contentLabel.text = [NSString stringWithFormat:@"%@:%@", commentInfo.knowcommnameon, commentInfo.knowcommcontentsub];
            _lineView.hidden = NO;
        }
        _commentLabel.text = commentInfo.knowcommcontent;
        _zanCountLabel.text = [NSString stringWithFormat:@"%td", commentInfo.knowcommzan];
        _timeLabel.text = [KnowledgeUtil compareCurrentTime:(commentInfo.knowcommctime)/1000];
        if (commentInfo.knowcommiszan) {
            _zanImageView.image = [UIImage imageNamed:@"czan"];
        } else {
            _zanImageView.image = [UIImage imageNamed:@"cnozan"];
        }
        
        [_avtorImageView sd_setImageWithURL:[NSURL URLWithString:commentInfo.knowcommurlhead]];
    }
    
    
}

- (IBAction)actionZan:(id)sender {
    
    if (self.clickZanBlock) {
        self.clickZanBlock(_commentInfo);
    }
}

- (IBAction)actionComment:(id)sender {
    
    if (self.clickCommentBlock) {
        self.clickCommentBlock(_commentInfo);
    }
}

-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    if (self.clickCommentBlock) {
        self.clickCommentBlock(_commentInfo);
    }
}

+ (CGFloat)defaultHeight:(NSString *)content comment:(NSString *)comment{
    
    // 展开后得高度 = 计算出文本内容的高度 + 固定控件的高度
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14.f]};
    
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    
    CGSize size1 = [content boundingRectWithSize:CGSizeMake(ContentWidth, 0) options:option attributes:attribute context:nil].size;
    CGSize size2 = [comment boundingRectWithSize:CGSizeMake(ContentWidth, 0) options:option attributes:attribute context:nil].size;
    
    return content.length == 0 ? size2.height + 75 : size1.height + size2.height + 75;
    
}

@end
