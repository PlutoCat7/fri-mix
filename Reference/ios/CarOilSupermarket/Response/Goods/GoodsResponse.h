//
//  GoodsResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/4.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSResponseInfo.h"
/*
"title": "测试1", // 商品标题
"marketprice": "11.00", // 售价
"productprice": "2.00", // 原价
"stock": "20", // 库存
"sales": "0", // 销量
"cat1": "汽车机油", // 一级分类
"cat2": "运通节能", //二级分类
"images": [ // 图片
           "http://106.14.212.172/attachment/png/2017/07/s7b2n7rUsxbstxX.png"
           ],

// 商品图文详情url
"contentUrl": "http://106.14.212.172/app.php?do=goods&act=content&goodsId=1&mid=1213"
 */

@interface GoodsInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger goodId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *marketprice;  // 售价
@property (nonatomic, copy) NSString *productprice;  // 原价
@property (nonatomic, copy) NSString *pointsTxt;  //兑换所需积分，0不显示积分信息
@property (nonatomic, assign) NSInteger stock;  //
@property (nonatomic, assign) NSInteger sales;
@property (nonatomic, copy) NSString *cat1;
@property (nonatomic, copy) NSString *cat2;
@property (nonatomic, strong) NSArray<NSString *> *images;
@property (nonatomic, copy) NSString *contentUrl;  // 商品图文详情url

@end


@interface GoodsResponse : COSResponseInfo

@property (nonatomic, strong) GoodsInfo *data;

@end
