//
//  MyVouchersPageResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/14.
//  Copyright © 2018年 王时温. All rights reserved.
//

//"id": "1",
//"title": "代金券",
//"prefix1": "¥",
//"price": "100.00",
//"buyTime": "购买时间：2017-09-20"


#import "COSPageResponseInfo.h"

@interface MyVouchersInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger vouchersId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *prefix1;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, copy) NSString *buyTime;

@end

@interface MyVouchersPageInfo : YAHActiveObject

@property (nonatomic, strong) NSArray<MyVouchersInfo *> *list;
@property (nonatomic, assign) NSInteger pages;     //总页数
@property (nonatomic, assign) NSInteger pageSize;

@end

@interface MyVouchersPageResponse : COSPageResponseInfo

@property (nonatomic, strong) MyVouchersPageInfo *data;

@end
