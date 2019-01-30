//
//  THAlertView.m
//  TiHouse
//
//  Created by Charles Zou on 2018/4/18.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "THAlertView.h"
#import "PXAlertView+Customization.h"

@implementation THAlertView

+ (void)showAlert:(NSString *)title
          message:(NSString *)message
      cancelTitle:(NSString *)cancelTitle
      clickCancel:(void(^)(void))clickCancel
       otherTitle:(NSString *)otherTitle
       clickOther:(void(^)(void))clickOther {
    
    PXAlertView *alertView = [PXAlertView showAlertWithTitle:title ? : @""
                                        message:message ? : @""
                                    cancelTitle:cancelTitle
                                     otherTitle:otherTitle
                                     completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                         if (buttonIndex == 0) {
                                             if (clickCancel) {clickCancel();}
                                         } else if (buttonIndex == 1) {
                                             if (clickOther) {clickOther();}
                                         }
                                     }];
    [alertView useDefaultIOS7Style];
}

@end
