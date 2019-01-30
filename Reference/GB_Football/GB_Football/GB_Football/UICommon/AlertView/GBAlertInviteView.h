//
//  GBAlertInviteView.h
//  GB_Football
//
//  Created by 王时温 on 2017/5/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseAlertView.h"

@interface GBAlertInviteView : GBBaseAlertView

+ (instancetype)alertWithImageUrl:(NSString *)imageUrl
                             name:(NSString *)name
                        matchName:(NSString *)matchName
                        courtName:(NSString *)courtName
                    CallBackBlock:(GBAlertViewCallBackBlock)alertViewCallBackBlock;

- (void)dismiss;

@end
