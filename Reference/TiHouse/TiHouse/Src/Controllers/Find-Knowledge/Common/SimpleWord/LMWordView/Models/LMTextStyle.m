//
//  LMTextStyle.m
//  SimpleWord
//
//  Created by Chenly on 16/5/14.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "LMTextStyle.h"
#import "UIFont+LMText.h"

@interface LMTextStyle ()



@end

@implementation LMTextStyle

- (instancetype)init {
    if (self = [super init]) {
        _fontSize = 13.0f;
        _textColor = [UIColor blackColor];
    }
    return self;
}

+ (instancetype)textStyleWithType:(LMTextStyleType)type {
    
    LMTextStyle *textStyle = [[self alloc] init];
    textStyle.type = type;
    textStyle.bold = type == LMTextStyleFormatNormal ? NO : YES;
    return textStyle;
}

#pragma mark - setter & getter

- (void)setType:(LMTextStyleType)type {
    
    _type = type;
    switch (type) {
        case LMTextStyleFormatNormal:
            self.fontSize = 13.0f;
            break;
        case LMTextStyleFormatH2:
            self.fontSize = 13.0f*1.3;
            break;
        case LMTextStyleFormatH3:
            self.fontSize = 13.0f;
            break;
    }
}

- (UIFont *)font {
    return [UIFont lm_fontWithFontSize:self.fontSize bold:self.bold italic:self.italic];
}

@end
