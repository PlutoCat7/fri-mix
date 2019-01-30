//
//  MenuView.m
//  MagicBean
//
//  Created by yahua on 16/3/13.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView

- (void)awakeFromNib {
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.layer.cornerRadius = self.width/2;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickMenu:)]) {
        [self.delegate clickMenu:self];
    }
}

#pragma mark - Public

- (void)setImage:(UIImage *)image text:(NSString *)text {
    
    self.imageView.image = image;
    self.textLabel.text = text;
}

- (void)setSelected:(BOOL)select {
    
    if (select) {
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.textLabel.textColor = [AppColor _leftMenuyellowColor];
    }else {
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [AppColor _leftMenuyellowColor].CGColor;
        self.textLabel.textColor = [UIColor whiteColor];
    }
}

@end
