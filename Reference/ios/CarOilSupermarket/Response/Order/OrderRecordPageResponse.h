//
//  OrderRecordPageResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/12.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "COSPageResponseInfo.h"
#import "AddressListResponse.h"

typedef NS_ENUM(NSUInteger, OrderType) {
    OrderType_PendingPayment,
    OrderType_Delivered,
    OrderType_Received,
    OrderType_Completed,
};

@interface OrderRecordGoodsInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat marketprice;
@property (nonatomic, assign) CGFloat productprice;
@property (nonatomic, copy) NSString *optiontitle;
@property (nonatomic, assign) NSInteger optionid;

@end

@interface OrderRecordInfo : YAHActiveObject

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *ordersn;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat freight; //运费
@property (nonatomic, assign) OrderType status;
@property (nonatomic, copy) NSString *refundid;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *paytime;
@property (nonatomic, copy) NSString *expresscom; //顺风 快递公司
@property (nonatomic, copy) NSString *express; //shunfeng
@property (nonatomic, copy) NSString *expresssn; //快递单号
@property (nonatomic, copy) NSString *paytype;
@property (nonatomic, assign) NSInteger goodscount;
@property (nonatomic, copy) NSString *statusstr;  //待付款  状态
@property (nonatomic, assign) BOOL canrefund;
@property (nonatomic, strong) NSArray<OrderRecordGoodsInfo *> *goods;

@property (nonatomic, strong) AddressInfo *address;

@end

@interface OrderRecordPageInfo : YAHActiveObject

@property (nonatomic, strong) NSArray<OrderRecordInfo *> *list;
@property (nonatomic, assign) NSInteger pages;     //总页数
@property (nonatomic, assign) NSInteger pageSize;

@end

@interface OrderRecordPageResponse : COSPageResponseInfo

@property (nonatomic, strong) OrderRecordPageInfo *data;

@end
