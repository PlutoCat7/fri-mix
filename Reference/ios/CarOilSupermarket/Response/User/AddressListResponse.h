//
//  AddressListResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/5.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSResponseInfo.h"

//{
//    "id": "1",
//    "realname": "姓名1",
//    "mobile": "18766665455",
//    "province": "身份1",
//    "city": "城市1",
//    "area": "区域1",
//    "address": "接到路名1",
//    "isdefault": "1" // 是否默认
//}


@interface AddressInfo : YAHActiveObject

@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *address;  //详细地址
@property (nonatomic, assign) BOOL isdefault;

@end

@interface AddressListInfo : YAHDataResponseInfo

@property (nonatomic, strong) NSArray<AddressInfo *> *list;

@end

@interface AddressListResponse : COSResponseInfo

@property (nonatomic, strong) AddressListInfo *data;

@end
