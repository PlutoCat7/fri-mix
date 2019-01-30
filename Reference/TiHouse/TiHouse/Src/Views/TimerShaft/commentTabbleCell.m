//
//  commentTabbleCell.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#define kTweet_CommentFont [UIFont systemFontOfSize:13]
#define kTweetCommentCell_LeftOrRightPading 0.01
#define kTweetCommentCell_ContentWidth kScreen_Width - 42 - 48
#define kTweetCommentCell_ContentMaxHeight 105.0

#import "commentTabbleCell.h"

@interface commentTabbleCell()

@property (nonatomic, retain) TweetComment *curComment;

@end

@implementation commentTabbleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView = nil;
        self.backgroundView = nil;
        self.bottomLineStyle = CellLineStyleNone;
        if (!_commentLabel) {
            _commentLabel = [[UITTTAttributedLabel alloc] initWithFrame:CGRectMake(kTweetCommentCell_LeftOrRightPading, 0, kTweetCommentCell_ContentWidth, 20)];
            _commentLabel.numberOfLines = 0;
            _commentLabel.backgroundColor = [UIColor clearColor];
            _commentLabel.font = kTweet_CommentFont;
            _commentLabel.textColor = kColorDark4;
            _commentLabel.linkAttributes = kLinkAttributes;
            _commentLabel.activeLinkAttributes = kLinkAttributesActive;
            [self.contentView addSubview:_commentLabel];
        }
        if (!_allCommentLabel) {
            _allCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTweetCommentCell_LeftOrRightPading, 0, kTweetCommentCell_ContentWidth, 25)];
            _allCommentLabel.height = YES;
            [self.contentView addSubview:_allCommentLabel];
        }
    }
    return self;
}


- (void)configWithComment:(TweetComment *)curComment topLine:(BOOL)has{
    _curComment = curComment;
    NSString *commentStr;
    if (_curComment.dairycommuidon == -1) {
        commentStr = [NSString stringWithFormat:@"%@：%@",[_curComment.dairycommname stringByRemovingPercentEncoding],
                      [_curComment.dairycommcontent stringByRemovingPercentEncoding]];
    }else{
        commentStr = [NSString stringWithFormat:@"%@回复%@：%@",[_curComment.dairycommname stringByRemovingPercentEncoding],[_curComment.dairycommnameon stringByRemovingPercentEncoding],[_curComment.dairycommcontent stringByRemovingPercentEncoding]];
    }
    [_commentLabel setLongString:commentStr withFitWidth:kTweetCommentCell_ContentWidth maxHeight:kTweetCommentCell_ContentMaxHeight];
    
    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc]initWithString:commentStr];
    NSString* keyStr1 = [_curComment.dairycommname stringByRemovingPercentEncoding], * keyStr2 = [_curComment.dairycommnameon stringByRemovingPercentEncoding];
    
    NSRange range1 = [attStr.string rangeOfString:keyStr1 ? keyStr1 : @""];
    [_commentLabel addLinkToTransitInformation:[NSDictionary dictionaryWithObject:keyStr1 ? keyStr1 : @"" forKey:@"value"] withRange:range1];
    
    NSRange range2;
    if (_curComment.dairycommuidon != -1) {
        range2 = [attStr.string rangeOfString:keyStr2 ? keyStr2 : @""];
        [_commentLabel addLinkToTransitInformation:[NSDictionary dictionaryWithObject:keyStr2 ? keyStr2 : @"" forKey:@"value"] withRange:range2];
    }
    
    
    
    
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[TweetComment class]]) {
        TweetComment *curComment = (TweetComment *)obj;
        NSString *commentStr;
        if (curComment.dairycommuidon == -1) {
            commentStr = [NSString stringWithFormat:@"%@：%@",[curComment.dairycommname stringByRemovingPercentEncoding],[curComment.dairycommcontent stringByRemovingPercentEncoding]];
        }else{
            commentStr = [NSString stringWithFormat:@"%@回复%@：%@",[curComment.dairycommname stringByRemovingPercentEncoding],[curComment.dairycommnameon stringByRemovingPercentEncoding],[curComment.dairycommcontent stringByRemovingPercentEncoding]];
        }
        cellHeight = MIN(kTweetCommentCell_ContentMaxHeight, [commentStr getHeightWithFont:kTweet_CommentFont constrainedToSize:CGSizeMake(kTweetCommentCell_ContentWidth, CGFLOAT_MAX)])+5;
    }
    return ceilf(cellHeight);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

