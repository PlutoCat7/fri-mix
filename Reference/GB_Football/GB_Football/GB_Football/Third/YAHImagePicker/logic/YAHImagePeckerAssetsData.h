//
//  YHImagePeckerAssetsData.h
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/2.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "YAHAlbumModel.h"
#import "YAHPhotoModel.h"

/**
 *    kvo通知类型
 */
typedef NS_ENUM(NSInteger, NDSelectAssetsChangeType) {
    /**
     *    添加
     */
    YHSelectAssetsChangeAdd		=	1,
    /**
     *    删除
     */
    YHSelectAssetsChangeDelete	=	2,
    /**
     *    添加溢出，超过最大数量
     */
    YHSelectAssetsChangeAddOverFlow	=	3,
};

/**
 *    图片选取器过滤类型
 */
typedef NS_ENUM(NSUInteger, YAHImagePickerFilterType) {
    /**
     *    不过滤
     */
    YHImagePickerFilterTypeNone,
    /**
     *    只过滤照片
     */
    YHImagePickerFilterTypePhotos,
    /**
     *    只过滤视频
     */
    YHImagePickerFilterTypeVideos
};

@interface YAHImagePeckerAssetsData : NSObject

#pragma mark - Property

@property (nonatomic, strong, readonly) NSMutableArray<YAHPhotoModel *> *selectAssetsArray;

/**
 *  记录改变Assets
 */
@property (nonatomic, copy, readonly) NSDictionary *changeDic;
/**
 *  最大选取个数   默认9个
 */
@property (nonatomic, assign) NSInteger maximumNumberOfSelection;
/**
 *  照片过滤类型，默认为图片
 */
@property (nonatomic, assign) YAHImagePickerFilterType filterType;

#pragma mark - Method
//单例
+ (instancetype)shareInstance;

+ (void)destroyInstance;

/**
 *  从相册中读取分组
 *
 *  @param successBlock 成功的block
 *  @param failBlock    失败的block
 */
- (void)loadGroupAssetsSuccessBlock:(void(^)(NSArray<YAHAlbumModel *> *groupAssets))successBlock
                       failureBlock:(void(^)(NSError *error))failBlock;
/**
 *  从分组中读取照片信息
 *
 *  @param resultBlock 返回结果
 */
- (void)loadAssetsWithGroup:(YAHAlbumModel *)albumModel
                resultBlock:(void(^)(NSArray<YAHPhotoModel *> *assets))resultBlock;

/**
 *  获取选中的asset
 *
 *  @param successBlock 成功的block
 *  @param failBlock    失败的block
 */
- (void)getSelectAssetsSuccessBlock:(void(^)(NSArray<YAHPhotoModel *> *assets))successBlock
                       failureBlock:(void(^)(NSError *error))failBlock;


/**
 *  asset 是否已被选中
 */
- (BOOL)isContainAsset:(YAHPhotoModel *)asset;

- (void)addAsset:(YAHPhotoModel *)asset;

- (void)addAssetWithArray:(NSArray<YAHPhotoModel *> *)assets;

- (void)removeAsset:(YAHPhotoModel *)asset;

/**
 *  是否最少选中一个
 */
- (BOOL)isSelectOneMore;

/**
 *    验证最大数量是否合法
 *
 *    @param numberOfSelections 需要验证的数量
 *
 *    @return 返回YES如果数量没有超过最大值，否则返回NO
 */
- (BOOL)validateMaximumNumberOfSelections:(NSUInteger)numberOfSelections;

@end
