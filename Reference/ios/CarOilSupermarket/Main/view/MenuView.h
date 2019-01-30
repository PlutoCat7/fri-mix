//
//  MenuView.h
//  MagicBean
//
//  Created by yahua on 16/3/13.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuView;
@protocol MenuViewDelegate <NSObject>

- (void)clickMenu:(MenuView *)MenuView;

@end

@interface MenuView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (nonatomic, weak) id<MenuViewDelegate> delegate;

- (void)setImage:(UIImage *)image text:(NSString *)text;

- (void)setSelected:(BOOL)select;

@end
