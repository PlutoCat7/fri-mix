//
//  GBAlertTeamHomePageView.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseAlertView.h"

@interface GBAlertTeamHomePageView : GBBaseAlertView

+ (instancetype)alertWithFirstName:(NSString *)firstName secondName:(NSString *)secondName handler:(GBAlertViewCallBackBlock)alertViewCallBackBlock;

@end
