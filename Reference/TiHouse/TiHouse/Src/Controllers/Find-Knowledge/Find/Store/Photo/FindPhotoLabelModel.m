//
//  FindPhotoLabelModel.m
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoLabelModel.h"
#import "YAHPhotoTools.h"

@implementation FindLabelDescModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _assemfiletagcontent = @"";
        _assemarcfiletagprice = @"";
        _assemarcfiletagbrand = @"";
    }
    return self;
}

- (NSString *)combineBrandAndPrice {
    
    if (([_assemarcfiletagbrand isEmpty] || !_assemarcfiletagbrand) && ([_assemarcfiletagprice isEmpty] || !_assemarcfiletagprice)) {
        return @"";
    }
    if (!([_assemarcfiletagbrand isEmpty] || !_assemarcfiletagbrand) &&
        !([_assemarcfiletagprice isEmpty] || !_assemarcfiletagprice)) {
        return [NSString stringWithFormat:@"%@|%@", _assemarcfiletagprice, _assemarcfiletagbrand];
    }
    if (!([_assemarcfiletagbrand isEmpty] || !_assemarcfiletagbrand)) {
        return _assemarcfiletagbrand;
    }
    if (!([_assemarcfiletagprice isEmpty] || !_assemarcfiletagprice)) {
        return _assemarcfiletagprice;
    }
    return @"";
}

@end

@implementation FindPhotoLabelModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _assemfiletagside = 1;
        _assemfiletagwper = 0.5;
        _assemfiletaghper = 0.5;
        _assemfiletagcontent = [[FindLabelDescModel alloc] init];
    }
    return self;
}

@end

@implementation FindPhotoHandleModel

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"labelModelList":[FindAssemarcFileTagJA class]};
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _labelModelList = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)getUploadImageWithBlock:(void(^)(UIImage *image))block {
    
    if (self.photoModel.previewPhoto) {
        block(self.photoModel.previewPhoto);
    }else {
        @weakify(self)
        [YAHPhotoTools getHighQualityFormatPhoto:self.photoModel.asset size:CGSizeMake(self.photoModel.asset.pixelWidth, self.photoModel.asset.pixelHeight) startRequestIcloud:nil progressHandler:nil completion:^(UIImage *image) {
            
            block(image);
            
        } failed:^(NSDictionary *info) { //获取高清图片失败， 上传缩略图
            @strongify(self)
            block(self.photoModel.thumbPhoto);
        }];
    }
}

@end

