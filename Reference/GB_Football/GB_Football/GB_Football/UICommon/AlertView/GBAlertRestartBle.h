//
//  GBAlertRestartBle.h
//  GB_Football
//
//  Created by gxd on 17/6/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBAlertRestartBle : UIView

+(GBAlertRestartBle*)showUpdateHint:(void (^)())okBlock;

@end
