//
//  PlayerDetailCommontSectionView.m
//  GB_Video
//
//  Created by yahua on 2018/1/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "PlayerDetailCommontSectionView.h"

@interface PlayerDetailCommontSectionView ()

@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

@end

@implementation PlayerDetailCommontSectionView

- (void)refreshWithCommentCount:(NSInteger)count {
    
    self.commentCountLabel.text = [NSString stringWithFormat:@"评论 (%td)", count];
}

@end
