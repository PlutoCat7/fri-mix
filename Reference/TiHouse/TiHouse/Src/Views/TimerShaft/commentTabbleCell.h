//
//  commentTabbleCell.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "TweetComment.h"
#import "UITTTAttributedLabel.h"

@interface commentTabbleCell : CommonTableViewCell

@property (strong, nonatomic) UITTTAttributedLabel *commentLabel;
@property (strong, nonatomic) UILabel *allCommentLabel;

- (void)configWithComment:(TweetComment *)curComment topLine:(BOOL)has;
+ (CGFloat)cellHeightWithObj:(id)obj;

@end
