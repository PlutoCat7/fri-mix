//
//  Enums.h
//  TiHouse
//
//  Created by weilai on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#ifndef Enums_h
#define Enums_h

// 知识类型
typedef enum
{
    KnowType_None = 0,
    KnowType_Poster = 1,//小报
    KnowType_SFurniture = 11,//尺寸家具
    KnowType_SIndoor = 12,//尺寸室内常用
    KnowType_SLiveroom = 13,//尺寸客厅
    KnowType_SRestaurant = 14,//尺寸餐厅
    KnowType_SRoom = 15,//尺寸卧室
    KnowType_SKitchen = 16,//尺寸厨房
    KnowType_FLiveroom = 21,//风水客厅
    KnowType_FRoom = 22,//风水卧室
    KnowType_FToilet = 23,//风水卫生间
    KnowType_FKitchen = 24,//风水厨房
    KnowType_FRestaurant = 25,//风水餐厅
    KnowType_FOther = 26,//风水其它
    KnowType_Temp = 50, // 临时使用
} KnowType;

typedef enum
{
    KnowTypeSub_Size = 1,//尺寸宝典
    KnowTypeSub_Arrange = 2,//风水
    KnowTypeSub_Poster = 3,//小报
} KnowTypeSub;

typedef enum {
    CommentType_Know = 0,
    CommentType_Asse = 1,
}CommentType;

#endif /* Enums_h */
