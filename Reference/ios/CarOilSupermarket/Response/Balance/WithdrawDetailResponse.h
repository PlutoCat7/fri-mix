//
//  WithdrawDetailResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/18.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "COSResponseInfo.h"

//"bank": "建行",
//"name": "张三",
//"acc": "6124394208342432",
//"money": "2000",
//"prefix1": "¥",
//"mobile": "18600000000",
//"fTime": "2018-01-01",
//"status": "处理中",
//"contact": "400-000-000",


@interface WithdrawDetailInfo : YAHActiveObject

@property (nonatomic, copy) NSString *bank;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *acc;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *prefix1;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *fTime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *contact;

@end

@interface WithdrawDetailResponse : COSResponseInfo

@property (nonatomic, strong) WithdrawDetailInfo *data;

@end
