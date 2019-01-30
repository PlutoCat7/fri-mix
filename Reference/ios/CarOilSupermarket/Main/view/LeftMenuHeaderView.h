//
//  LeftMenuHeaderView.h
//  MagicBean
//
//  Created by yahua on 16/3/29.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *userAvatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

- (void)reloadWithAvatorURL:(NSString *)avatorURL name:(NSString *)name userID:(NSString *)userID;

@end
