//
//  AppColorProtocol.h
//  GB_Football
//
//  Created by wsw on 16/8/5.
//  Copyright © 2016年 Go Brother. All rights reserved.
//
#import <Foundation/Foundation.h>


@protocol AppColor <NSObject>

- (UIColor *)styleColor;

- (UIColor *)styleColor_50;

- (UIColor *)bgColor;

- (UIColor *)textColor;

- (UIColor *)placeholderColor;

- (UIColor *)inputBgColor;

- (UIColor *)disableColor;

@end

