//
//  GBAlertViewOneWay.h
//  GB_TransferMarket
//
//  Created by Pizza on 2017/2/17.
//  Copyright © 2017年 gxd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBAlertView.h"

@interface GBAlertViewOneWay : UIView
+(GBAlertViewOneWay*)showWithTitle:(NSString*)title
                           content:(NSString*)content
                            button:(NSString*)button
                              onOk:(void (^)())okBlock
                             style:(GBALERT_STYLE)style;
@end
