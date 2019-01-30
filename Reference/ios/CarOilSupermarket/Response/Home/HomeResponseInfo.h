//
//  HomeResponseInfo.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/8.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSResponseInfo.h"

@interface HomeBannerInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, copy) NSString *act;  // act： goods 跳转到商品详情页，h5 跳转到url h5页面
@property (nonatomic, copy) NSString *url;

@end

typedef NS_ENUM(NSUInteger, CategoryType) {
    CategoryType_None,
    CategoryType_Normal,
    CategoryType_More,
};

@interface HomeCategoryInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *act;  // act: category 跳转到分类页并指向对应cid，//categoryMore 跳转到分类页，不指定cid
@property (nonatomic, copy) NSString *name;

- (CategoryType)type;

@end

@interface HomeGoodsInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *pointsTxt;  //兑换所需积分，0不显示积分信息

@end

@interface HomeNetworkData : YAHDataResponseInfo

@property (nonatomic, copy) NSString *notice;
@property (nonatomic, strong) NSArray<HomeBannerInfo *> *bannerList;
@property (nonatomic, strong) NSArray<HomeCategoryInfo *> *categoryList;
@property (nonatomic, strong) NSArray<HomeGoodsInfo *> *goodsList;

@end

@interface HomeResponseInfo : COSResponseInfo

@property (nonatomic, strong) HomeNetworkData *data;

@end
