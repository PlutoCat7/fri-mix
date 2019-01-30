//
//  GBAlertTeamApplyView.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/27.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseAlertView.h"

@interface GBAlertTeamApplyView : GBBaseAlertView

+ (instancetype)alertWithImageUrl:(NSString *)imageUrl
                             name:(NSString *)name
                    CallBackBlock:(GBAlertViewCallBackBlock)alertViewCallBackBlock;

@end
