//
//  BasePopAlertView.h
//  FWRACProject
//
//  Created by apple on 2017/6/7.
//  Copyright © 2017年 he. All rights reserved.
//

#import "BaseView.h"
//#import "PopDownAlertViewModel.h"

typedef NS_ENUM(NSUInteger, PopAlertViewDirection) {
    PopAlertViewDirectionUp,
    PopAlertViewDirectionDown,
    PopAlertViewDirectionLeft,
    PopAlertViewDirectionRight,
    PopAlertViewDirectionCenter,
    PopAlertViewDirectionBottom,
};

@interface BasePopAlertView : BaseView


/**
 不带输入框的

 @param contentView <#contentView description#>
 @param direction <#direction description#>
 */
- (void)showWithContentView:(UIView *)contentView direction:(PopAlertViewDirection)direction;

/**
 带输入框的

 @param contentView <#contentView description#>
 @param direction <#direction description#>
 */
- (void)showFromRootVCWithContentView:(UIView *)contentView direction:(PopAlertViewDirection)direction;

- (void)dismissAlertView;


@end
