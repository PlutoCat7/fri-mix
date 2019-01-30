//
//  LeftMenuHeaderView.m
//  MagicBean
//
//  Created by yahua on 16/3/29.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "LeftMenuHeaderView.h"

@implementation LeftMenuHeaderView

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor clearColor];
    self.userAvatorImageView.layer.masksToBounds = YES;
    self.bottomLine.height = 0.5f;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.userAvatorImageView.layer.cornerRadius = self.userAvatorImageView.width/2;
}

#pragma mark - Public

- (void)reloadWithAvatorURL:(NSString *)avatorURL name:(NSString *)name userID:(NSString *)userID {
    
    [self.userAvatorImageView yy_setImageWithURL:[NSURL URLWithString:avatorURL]
                                     placeholder:[UIImage imageNamed:@"mine_icon_avatar"]];
    self.userNameLabel.text = name;
    self.userIDLabel.text = userID;
}

@end
