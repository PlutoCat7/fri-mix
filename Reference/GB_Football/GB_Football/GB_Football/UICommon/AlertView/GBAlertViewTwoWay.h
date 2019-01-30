//
//  GBAlertViewTwoWay.h
//  GB_TransferMarket
//
//  Created by Pizza on 2017/2/16.
//  Copyright © 2017年 gxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBAlertViewTwoWay : UIView
+(GBAlertViewTwoWay*)showWithTitle:(NSString*)title
                           content:(NSString*)content
                     buttonStrings:(NSArray*)buttonStrings
                              onOk:(void (^)())okBlock
                          onCancel:(void (^)())cancelBlock;
@end
