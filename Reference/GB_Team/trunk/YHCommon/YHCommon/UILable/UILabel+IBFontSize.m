//
//  UILabel+IBFontSize.m
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/8/1.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "UILabel+IBFontSize.h"

#define JumpTag 9999
#define BaseScale 375.f
#define IPHONE_WIDTH [UIScreen mainScreen].bounds.size.width
#define SizeScale ((IPHONE_WIDTH != BaseScale) ? IPHONE_WIDTH/BaseScale : 1)

@implementation UIButton(IBFontSize)

+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)myInitWithCoder:(NSCoder *)aDecode{
    
    [self myInitWithCoder:aDecode];
    if (self) {
        if (self.titleLabel.tag != JumpTag) {
            CGFloat fontSize = self.titleLabel.font.pointSize;
            self.titleLabel.font = [UIFont fontWithName:self.titleLabel.font.fontName size:fontSize * SizeScale];
        }
    }
    return self;
}

@end

@implementation UILabel(IBFontSize)

+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)myInitWithCoder:(NSCoder *)aDecode{
    
    [self myInitWithCoder:aDecode];
    if (self) {
        if (self.tag != JumpTag) {
            CGFloat fontSize = self.font.pointSize;
            self.font = [UIFont fontWithName:self.font.fontName size:fontSize * SizeScale];
        }
    }
    return self;
}

@end

@implementation UITextField(IBFontSize)

+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)myInitWithCoder:(NSCoder *)aDecode{
    
    [self myInitWithCoder:aDecode];
    if (self) {
        if (self.tag != JumpTag) {
            CGFloat fontSize = self.font.pointSize;
            self.font = [UIFont fontWithName:self.font.fontName size:fontSize * SizeScale];
        }
    }
    return self;
}

@end

