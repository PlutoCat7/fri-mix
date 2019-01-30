//
//  THAlertView.h
//  TiHouse
//
//  Created by Charles Zou on 2018/4/18.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THAlertView : NSObject

+ (void)showAlert:(NSString *)title
          message:(NSString *)message
      cancelTitle:(NSString *)cancelTitle
      clickCancel:(void(^)(void))clickCancel
       otherTitle:(NSString *)otherTitle
       clickOther:(void(^)(void))clickOther;

@end
