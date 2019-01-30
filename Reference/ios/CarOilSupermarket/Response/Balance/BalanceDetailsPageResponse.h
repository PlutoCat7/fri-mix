//
//  BalanceDetailsPageResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/18.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "COSPageResponseInfo.h"

//"id": "12",
//"remark": "建设银行-张三",
//"type": "1", //0 充值 1 提现，提现类型可跳转到提现详情页
//"prefix1": "-",
//"prefix2": "¥",
//"money": "5.00",
//"status": "处理中",
//"fTime": "2018-01-12"

typedef NS_ENUM(NSUInteger, BalanceDetailsType) {
    BalanceDetailsType_Charge,
    BalanceDetailsType_Withdraw,
};

@interface BalanceDetailsInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger balanceDetailsId;
@property (nonatomic, assign) BalanceDetailsType type;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *prefix1;
@property (nonatomic, copy) NSString *prefix2;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *fTime;

@end

@interface BalanceDetailsPageInfo : YAHActiveObject

@property (nonatomic, strong) NSArray<BalanceDetailsInfo *> *list;
@property (nonatomic, assign) NSInteger pages;     //总页数
@property (nonatomic, assign) NSInteger pageSize;

@end

@interface BalanceDetailsPageResponse : COSPageResponseInfo

@property (nonatomic, strong) BalanceDetailsPageInfo *data;

@end
