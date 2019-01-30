//
//  ShoppingListResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/4.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSResponseInfo.h"

//{
//    "code": "0",
//    "msg": "",
//    "data": {
//        "total": 2, // 购物车总商品件量
//        "list": [
//                 {
//                     "id": "4", // 购物车ID （用于删除）
//                     "total": "2", // 用户选择的数量
//                     "goodsid": "2", // 商品ID
//                     "stock": "10", // 库存量
//                     "maxbuy": "0", // 最大可购买数量，0不限
//                     "title": "测试2",
//                     "thumb": "http://fx/attachment/png/2017/07/s7b2n7rUsxbstxX.png",
//                     "marketprice": "10.00", // 单价 (售价)
//                     "productprice": "10.00", //原价
//                 }
//                 ],
//        "totalprice": "20.00" // 总金额
//    }
//}

@interface ShoppingInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger shoppingId;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, assign) NSInteger stock;
@property (nonatomic, assign) NSInteger maxbuy;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, assign) CGFloat marketprice;
@property (nonatomic, assign) CGFloat productprice;
@property (nonatomic, copy) NSString *pointsTxt;  //兑换所需积分，0不显示积分信息

@end

@interface ShoppingListInfo : YAHDataResponseInfo

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) CGFloat totalprice;
@property (nonatomic, strong) NSArray<ShoppingInfo *> *list;

@end

@interface ShoppingListResponse : COSResponseInfo

@property (nonatomic, strong) ShoppingListInfo *data;

@end
