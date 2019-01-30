//
//  FindPhotoLabelModel.h
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXPhotoModel.h"
#import "YAHActiveObject.h"
#import "FindAssemarcInfo.h"

@interface FindLabelDescModel : YAHActiveObject

@property (nonatomic, copy) NSString *assemfiletagcontent; //标签名称
@property (nonatomic, copy) NSString *assemarcfiletagbrand; //标签品牌
@property (nonatomic, copy) NSString *assemarcfiletagprice; //标签价格

- (NSString *)combineBrandAndPrice;

@end

@interface FindPhotoLabelModel : YAHActiveObject

@property (nonatomic, assign) NSInteger assemfiletagtype;  //1物品2非物品
@property (nonatomic, assign) NSInteger assemfiletagside; //0左边，1右边，默认右边
@property (nonatomic, strong) FindLabelDescModel *assemfiletagcontent; //标签信息
@property (nonatomic, assign) CGFloat assemfiletagwper; //width 百分比
@property (nonatomic, assign) CGFloat assemfiletaghper; //height 百分比

@end

@interface FindPhotoHandleModel : YAHActiveObject

@property (nonatomic, strong) HXPhotoModel *photoModel; //图片数据
@property (nonatomic, copy) NSString *photoUploadUrl; //图片上传完成后的地址
@property (nonatomic, strong) NSMutableArray<FindAssemarcFileTagJA *> *labelModelList;

- (void)getUploadImageWithBlock:(void(^)(UIImage *image))block;

@end

