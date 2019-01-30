//
//  ArticleLikeView.m
//  TiHouse
//
//  Created by yahua on 2018/2/6.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ArticleLikeView.h"
#import "FindAssemarcInfo.h"

@interface ArticleLikeView ()

@property (weak, nonatomic) IBOutlet UIView *likeView;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeNumberLabel;

@end

@implementation ArticleLikeView

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.likeView.layer.cornerRadius = self.likeView.width/2;
    });
}

- (void)refreshWithInfo:(FindAssemarcInfo *)info {
    
#warning 图标缺失
    self.likeImageView.image = info.assemarciszan?[UIImage imageNamed:@"find_article_has_like"]:[UIImage imageNamed:@"find_article_no_like"];
    self.likeNumberLabel.text = [NSString stringWithFormat:@"赞 %td", info.assemarcnumzan];
}

- (IBAction)actionLike:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(articleLikeViewActionLike:)]) {
        [_delegate articleLikeViewActionLike:self];
    }
}

@end
