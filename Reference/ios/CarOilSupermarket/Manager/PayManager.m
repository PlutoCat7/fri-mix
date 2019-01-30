//
//  PayManager.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/15.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "PayManager.h"

#import "OrderPayCallBackInfo.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface PayManager ()

@property (nonatomic, copy) void(^payBlock)(NSString *errorMsg);

@end

@implementation PayManager

+ (PayManager *)sharedPayManager {
    
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[PayManager alloc] init];
        [[NSNotificationCenter defaultCenter]addObserver:instance selector:@selector(weChatPayCallBackNotification:) name:Notification_Order_WeChat_Pay object:nil];
    });
    return instance;
}

- (void)payWithOrderPayCallBackInfo:(OrderPayCallBackInfo *)info hanlder:(void(^)(NSString *errorMsg))hanlder {
    
    if ([info.payType isEqualToString:@"21"]) {
        self.payBlock = hanlder;
        [self jumpToBizPay:info.payData];
    }else if ([info.payType isEqualToString:@"22"]) {
        [[AlipaySDK defaultService] payOrder:info.payData.orderString fromScheme:@"CarOilSuperMarket" callback:^(NSDictionary *resultDic) {
            NSString *errorMsg = @"支付失败，请重试！";
            if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000) { //支付成功
                errorMsg = nil;
            }
            BLOCK_EXEC(hanlder, errorMsg);
        }];
    }else if ([info.payType isEqualToString:@"1"]) {
        BLOCK_EXEC(hanlder, nil);
    }else {
        BLOCK_EXEC(hanlder, @"请选择支付方式");
    }
}

- (void)jumpToBizPay:(PayCallBackDataInfo *)info {
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = info.partnerid;
    req.prepayId            = info.prepayid;
    req.nonceStr            = info.noncestr;
    req.timeStamp           = info.timestamp;
    req.package             = info.package;
    req.sign                = info.sign;
    [WXApi sendReq:req];
}

- (void)weChatPayCallBackNotification:(NSNotification *)notification {
    
    if (!self.payBlock) {
        return;
    }
    
    BaseResp *wechatResp = notification.object;
    NSString *errorMsg = @"支付失败，请重试！";
    if (wechatResp) {
        switch (wechatResp.errCode) {
            case WXSuccess:
                errorMsg = nil;;
                break;
            default:
                break;
        }
    }
    BLOCK_EXEC(self.payBlock, errorMsg);
    self.payBlock = nil;
}

@end
