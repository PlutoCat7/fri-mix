//
//  YHImagePeckerAssetsData.m
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/2.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import "YAHImagePeckerAssetsData.h"
#import "YAHPhotoTools.h"


NSString *const kObserverSelectAssetsKeyPath		=		@"selectAssetsArray";

@interface YAHImagePeckerAssetsData ()

@property (nonatomic, strong) NSMutableArray<YAHPhotoModel *> *selectAssetsArray;
@property (nonatomic, copy) NSDictionary *changeDic;

@property (nonatomic, strong) NSMutableArray<YAHAlbumModel *> *albums;

@end

@implementation YAHImagePeckerAssetsData

static YAHImagePeckerAssetsData *instance = nil;

+ (instancetype)shareInstance {
    
    if (!instance) {
        instance = [[YAHImagePeckerAssetsData alloc] init];
    }
    return instance;
    //只运行一次，及时instance=nil
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[YHImagePeckerAssetsData alloc] init];
//    });
//    return instance;
}

+ (void)destroyInstance {
    
    instance = nil;
}

- (void)dealloc
{
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectAssetsArray = [NSMutableArray arrayWithCapacity:1];
        _maximumNumberOfSelection = 9;
        _filterType = YHImagePickerFilterTypePhotos;
        _albums = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

#pragma mark - Public

- (void)loadGroupAssetsSuccessBlock:(void(^)(NSArray<YAHAlbumModel *> *groupAssets))successBlock
                       failureBlock:(void(^)(NSError *error))failBlock {
    if (self.albums.count > 0) [self.albums removeAllObjects];
    void(^getAblumBlock)() = ^{
        // 获取系统智能相册
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        __weak __typeof(self)weakSelf = self;
        [smartAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf parsePHAssetCollection:collection];
        }];
        // 获取用户相册
        PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        [userAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf parsePHAssetCollection:collection];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (successBlock) {
                successBlock([self.albums copy]);
            }
        });
    };
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                getAblumBlock();
            }
        }];
    }else {
        getAblumBlock();
    }
    
}

- (void)loadAssetsWithGroup:(YAHAlbumModel *)albumModel
                resultBlock:(void(^)(NSArray<YAHPhotoModel *> *assets))resultBlock {
    
    __block NSMutableArray *assets = [NSMutableArray arrayWithCapacity:1];
    [albumModel.result enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        
        YAHPhotoModel *model = [[YAHPhotoModel alloc] init];
        model.asset = asset;
        [assets addObject:model];
    }];
    if (resultBlock) {
        resultBlock([assets copy]);
    }
}

- (void)getSelectAssetsSuccessBlock:(void(^)(NSArray<YAHPhotoModel *> *assets))successBlock
                       failureBlock:(void(^)(NSError *error))failBlock {

    if (successBlock) {
        successBlock([self.selectAssetsArray copy]);
    }
}

- (BOOL)isContainAsset:(YAHPhotoModel *)asset {
    
    for (YAHPhotoModel *selectAsset in self.selectAssetsArray) {
        
        if (selectAsset.asset == asset.asset) {
            return YES;
        }
        
        NSString *selfIdentifier = selectAsset.asset.localIdentifier;
        NSString *otherIdentifier = asset.asset.localIdentifier;
        
        if ([selfIdentifier isEqualToString:otherIdentifier]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)addAsset:(YAHPhotoModel *)asset {
    
    if (![self isContainAsset:asset]) {
        [self willChangeValueForKey:kObserverSelectAssetsKeyPath];
        self.changeDic = @{[@(YHSelectAssetsChangeAdd) stringValue]: asset};
        [self.selectAssetsArray addObject:asset];
        [self didChangeValueForKey:kObserverSelectAssetsKeyPath];
    }
}

- (void)addAssetWithArray:(NSArray<YAHPhotoModel *> *)assets {
    
    if ([assets count] > 0) {
        __block BOOL needKVO = NO;
        [assets enumerateObjectsUsingBlock:^(YAHPhotoModel *asset, NSUInteger idx, BOOL *stop) {
            if (![self isContainAsset:asset]) {
                needKVO = YES;
                if (self.selectAssetsArray.count < self.maximumNumberOfSelection) {
                    [self.selectAssetsArray addObject:asset];
                }
            }
        }];
        if (needKVO) {
            [self willChangeValueForKey:kObserverSelectAssetsKeyPath];
            self.changeDic = @{[@(YHSelectAssetsChangeAdd) stringValue]: [assets copy]};
            [self didChangeValueForKey:kObserverSelectAssetsKeyPath];
        }
    }
}

- (void)removeAsset:(YAHPhotoModel *)asset {
    
    YAHPhotoModel *findAsset = nil;
    for (YAHPhotoModel *selectAsset in self.selectAssetsArray) {
        
        if (selectAsset == asset) {
            findAsset = selectAsset;
            break;
        }
        NSString *selfIdentifier = selectAsset.asset.localIdentifier;
        NSString *otherIdentifier = asset.asset.localIdentifier;
        
        if ([selfIdentifier isEqualToString:otherIdentifier]) {
            findAsset = selectAsset;
            break;
        }
    }
    if (findAsset) {
        [self willChangeValueForKey:kObserverSelectAssetsKeyPath];
        [self.selectAssetsArray removeObject:findAsset];
        self.changeDic = @{[@(YHSelectAssetsChangeDelete) stringValue]: findAsset};
        [self didChangeValueForKey:kObserverSelectAssetsKeyPath];
    }
}

- (BOOL)isSelectOneMore {
    
    return (self.selectAssetsArray.count>0)?YES:NO;
}

- (BOOL)validateMaximumNumberOfSelections:(NSUInteger)numberOfSelections {
    
    BOOL notOverFlow = YES;
    
    notOverFlow = (numberOfSelections <= self.maximumNumberOfSelection);
    
    if (!notOverFlow) {
        [self willChangeValueForKey:kObserverSelectAssetsKeyPath];
        self.changeDic = @{[@(YHSelectAssetsChangeAddOverFlow) stringValue]: [NSNull null]};
        [self didChangeValueForKey:kObserverSelectAssetsKeyPath];
    }
    
    return notOverFlow;
}

#pragma mark - Custom Accessors


#pragma mark - Private

- (void)parsePHAssetCollection:(PHAssetCollection *)assetCollection {
    
    // 是否按创建时间排序
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    if (self.filterType == YHImagePickerFilterTypePhotos) {
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    }else if (self.filterType == YHImagePickerFilterTypeVideos) {
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
    }
    // 获取相册照片集合
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    // 过滤掉空相册
    if (result.count > 0) {
        YAHAlbumModel *albumModel = [[YAHAlbumModel alloc] init];
        albumModel.count = result.count;
        albumModel.albumName = [YAHPhotoTools transFormPhotoTitle:assetCollection.localizedTitle];
        albumModel.result = result;
        if ([albumModel.albumName isEqualToString:@"相机胶卷"] ||
            [albumModel.albumName isEqualToString:@"所有照片"] ||
            [albumModel.albumName isEqualToString:@"All Photos"]) {
            [self.albums insertObject:albumModel atIndex:0];
        }else {
            [self.albums addObject:albumModel];
        }
    }
}

@end
