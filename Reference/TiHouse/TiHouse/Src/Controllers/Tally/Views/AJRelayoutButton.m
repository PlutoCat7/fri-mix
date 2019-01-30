//
//  AJVerticalButton.m
//  TiHouse
//
//  Created by AlienJunX on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AJRelayoutButton.h"

@implementation AJRelayoutButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isRenderingMode = NO;
    }
    return self;
}



- (void)setSpace:(NSInteger)space {
    _space = space;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect imgFrame = self.imageView.frame;
    if (self.fixedImageSize.height>0 && self.fixedImageSize.width>0) {
        imgFrame.size = self.fixedImageSize;
        self.imageView.frame = imgFrame;
    }
    
    if (self.isRenderingMode) {
        UIImage *icon = [self.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self setImage:icon forState:UIControlStateNormal];
    }
    
    CGPoint imgCenter = self.imageView.center;
    CGRect labelFrame = [self titleLabel].frame;
    
    switch (self.style) {
        case AJButtonLayoutStyleTop:
        {
            // image
            imgCenter.x = self.frame.size.width/2;
            imgCenter.y = self.imageView.frame.size.height/2;
            self.imageView.center = imgCenter;
            
            // text
            labelFrame.origin.x = 0;
            labelFrame.origin.y = self.imageView.frame.size.height + self.space;
            labelFrame.size.width = self.frame.size.width;
            labelFrame.size.height = self.titleLabel.font.lineHeight;
            self.titleLabel.frame = labelFrame;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
        case AJButtonLayoutStyleLeft:
        {
            // image
            imgFrame.origin.x = 0;
            imgFrame.origin.y = self.frame.size.height/2 - imgFrame.size.height/2;
            self.imageView.frame = imgFrame;
            
            // text
            labelFrame.origin.x = self.imageView.frame.size.width + self.space;
            labelFrame.origin.y = self.frame.size.height/2 - labelFrame.size.height/2;
            labelFrame.size.height = self.titleLabel.font.lineHeight;
            labelFrame.size.width = self.frame.size.width - imgFrame.size.width - self.space;
            self.titleLabel.frame = labelFrame;
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
        }
            break;
        case AJButtonLayoutStyleBottom:
        {
            CGFloat contentHeight = imgFrame.size.height + self.space + self.titleLabel.font.lineHeight;
            
            CGFloat margin = (self.frame.size.height - contentHeight)*0.5;
            
            // image
            imgFrame.origin.x = self.frame.size.width/2 - imgFrame.size.width /2;
            imgFrame.origin.y = self.frame.size.height - imgFrame.size.height - margin;
            self.imageView.frame = imgFrame;
            
            // text
            labelFrame.size.width = self.frame.size.width;
            labelFrame.size.height = self.titleLabel.font.lineHeight;
            labelFrame.origin.x = 0;
            labelFrame.origin.y = margin;
            self.titleLabel.frame = labelFrame;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
        case AJButtonLayoutStyleRight:
        {
            // image
            imgFrame.origin.x = self.frame.size.width - imgFrame.size.width;
            imgFrame.origin.y = self.frame.size.height/2 - imgFrame.size.height/2;
            self.imageView.frame = imgFrame;
            
            // text
            labelFrame.origin.x = 0;
            labelFrame.origin.y = self.frame.size.height/2 - labelFrame.size.height/2;
            labelFrame.size.width = self.frame.size.width - imgFrame.size.width - self.space;
            labelFrame.size.height = self.titleLabel.font.lineHeight;
            self.titleLabel.frame = labelFrame;
            self.titleLabel.textAlignment = NSTextAlignmentRight;
        }
            break;
        default:
            break;
    }
    
    
    
}

@end
