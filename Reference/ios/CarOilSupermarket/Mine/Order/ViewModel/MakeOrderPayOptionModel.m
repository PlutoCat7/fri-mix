//
//  MakeOrderPayOptionModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/23.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "MakeOrderPayOptionModel.h"

@implementation MakeOrderPayOptionModel

- (NSString *)vouchersId {
    
    if (self.pointSwitchOn) {
        return @"";
    }
    NSMutableArray *voucherIdList = [NSMutableArray arrayWithCapacity:1];
    for (MyVouchersInfo *info in self.selectVouchersInfos) {
        [voucherIdList addObject:@(info.vouchersId).stringValue];
    }
    if (voucherIdList.count == 0) {
        return @"";
    }
    return [voucherIdList componentsJoinedByString:@"|"];
}

- (CGFloat)totalVouchersPrice {
    
    if (self.pointSwitchOn) {
        return 0;
    }
    
    CGFloat totalPrice = 0;
    for (MyVouchersInfo *voucherInfo in self.selectVouchersInfos) {
        totalPrice += voucherInfo.price;
    }
    return totalPrice;
}

- (BOOL)isShow {
    
    return (self.canUseBalance || self.canUsePoint || self.canUseVoucher);
}

//显示时的高度
- (CGFloat)showHeight {
    
    if (self.pointSwitchOn) {
        return 50*kAppScale;
    }
    
    CGFloat height = 0;
    if (self.canUseVoucher) {
        height += 50*kAppScale;
    }
    if (self.canUsePoint) {
        height += 50*kAppScale;
    }
    if (self.canUseBalance) {
        height += 50*kAppScale;
    }
    return height;
}

- (BOOL)balanceSwitchOn {
    
    if (self.pointSwitchOn) {
        return NO;
    }
    return _balanceSwitchOn;
}

- (BOOL)canUseVoucher {
    
    if (self.pointSwitchOn) {
        return NO;
    }
    return _canUseVoucher;
}

- (BOOL)canUseBalance {
    
    if (self.pointSwitchOn) {
        return NO;
    }
    return _canUseBalance;
}

@end
