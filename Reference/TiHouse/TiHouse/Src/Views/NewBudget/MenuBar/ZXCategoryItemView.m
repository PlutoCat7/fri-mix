//
//  ZXCategoryItemView.m
//  ZXPageScrollView
//
//  Created by anphen on 2017/3/29.
//  Copyright © 2017年 anphen. All rights reserved.
//

#import "ZXCategoryItemView.h"

extern NSString *const RESETCOLORNOTIFICATION;

@interface ZXCategoryItemView()

@end

@implementation ZXCategoryItemView

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetColor:) name:RESETCOLORNOTIFICATION object:@"color"];
    
}

- (void)resetColor:(NSNotification *)notification
{
    if (self.index == [[notification.userInfo objectForKey:@"index"]integerValue]) {
        return;
    }
    self.contentLabel.textColor = [notification.userInfo objectForKey:@"color"];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
}

- (void)setItemContent:(NSString *)itemContent
{
    _itemContent = itemContent;
    self.contentLabel.text = itemContent;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
