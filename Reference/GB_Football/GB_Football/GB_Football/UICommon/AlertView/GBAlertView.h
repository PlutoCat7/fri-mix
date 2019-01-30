//
//  GBAlertView.h
//  GB_Football
//
//  Created by wsw on 16/8/23.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GBALERT_STYLE) {
    GBALERT_STYLE_NOMAL,
    GBALERT_STYLE_CANCEL_GREEN,
    GBALERT_STYLE_SURE_GREEN,
};
typedef void(^GBAlertViewCallBackBlock)(NSInteger buttonIndex);

@interface GBAlertView : UIView

+ (instancetype)alertWithCallBackBlock:(GBAlertViewCallBackBlock)alertViewCallBackBlock title:(NSString *)title message:(NSString *)message cancelButtonName:(NSString *)cancelButtonName otherButtonTitle:(NSString *)otherButtonTitle style:(GBALERT_STYLE)style;

- (void)dismiss;

@end
