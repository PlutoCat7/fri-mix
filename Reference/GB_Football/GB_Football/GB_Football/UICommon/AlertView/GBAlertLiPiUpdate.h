//
//  GBAlertLiPiUpdate.h
//  GB_Football
//
//  Created by Pizza on 2017/3/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBAlertLiPiUpdate : UIView
+(GBAlertLiPiUpdate*)showWithTitle:(NSString*)title
                           content:(NSString*)content
                     buttonStrings:(NSArray*)buttonStrings
                              onOk:(void (^)())okBlock
                          onCancel:(void (^)())cancelBlock;
@end
