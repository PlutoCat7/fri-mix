//
//  HouseTweet.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/16.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "modelDairy.h"

typedef NS_ENUM(NSInteger ,TweetType) {
    TweetTypeText = 1,
    TweetTypePhoto,
    TweetTypeVideo
};

@class Folder ,PHAsset ,House ,HXPhotoModel;

@interface FileModel: NSObject

@property (nonatomic, copy) NSString *fileurl; // 大图url
@property (nonatomic, assign) NSInteger fileid; // 文件id
@property (nonatomic, assign) NSInteger filetype; // 类型 1 图片 2 视频
@property (nonatomic, copy) NSString *phototime; // 拍摄毫秒时间戳
@property (nonatomic, assign) CGFloat filepercentwh; // 宽高比
@property (nonatomic, assign) NSInteger fileseconds; // 视频秒数
@property (nonatomic, copy) NSString *fileurlsmall; // 小图url
@property (nonatomic, copy) NSString *urlshare; // 图片分享路径
@property (nonatomic, assign) BOOL typecollect; // 是否收藏

@end

@interface RangeModel: NSObject

@property (nonatomic, copy) NSString *dairyrangeuid;

@end

@interface RemindModel: NSObject

@property (nonatomic, assign) NSInteger *dairyreminduid;
@property (nonatomic, copy) NSString *dairyremindurlhead;
@property (nonatomic, copy) NSString *dairyremindusername;

@end

@interface HouseTweet : NSObject

@property (nonatomic, retain) NSMutableArray *visibleArr ,*remindArr ,*urlImages ,*images;
@property (nonatomic, retain) NSArray *visibleFriends ,*remindFriends ,*folders ,*UIModels; //缓存可见好友，提醒好友，文件夹
@property (nonatomic, retain) Folder *folder;
@property (nonatomic, retain) House *house;
@property (nonatomic, assign) TweetType type;
@property (nonatomic, retain) NSData *dairytime ,*modificationDate, *fileData;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSString *dairydesc ,*arruidrange ,*arrurlfile ,*createData ,*filename, *sandBoxFilePath;
@property (nonatomic, assign) NSInteger visibleRange ,dateIndex;
@property (nonatomic, strong) modelDairy *dairy;
@property (nonatomic, assign) NSInteger dairytimetype;
// 新接口需要的字段
@property (nonatomic, copy) NSString *diytime;
@property (nonatomic, strong) NSMutableArray *fileJAstr;
@property (nonatomic, strong) NSMutableArray *dairyrangeJAstr;
@property (nonatomic, strong) NSMutableArray *dairyremindJAstr;

- (NSString *)toPath:(BOOL)isEdit;
- (NSDictionary *)toParams:(BOOL)isEdit;
- (BOOL)isAllImagesDoneSucess;
+ (void) convertVideoWithModel:(HouseTweet *) model;

@end


typedef NS_ENUM(NSInteger, TweetImageUploadState)
{
    TweetImageUploadStateInit = 0,
    TweetImageUploadStateIng,
    TweetImageUploadStateSuccess,
    TweetImageUploadStateFail
};

@interface TweetImage : NSObject
@property (readwrite, nonatomic, strong) UIImage *image, *thumbnailImage;
@property (strong, nonatomic) NSURL *assetURL;
@property (strong, nonatomic) HXPhotoModel *beforeModel;
@property (assign, nonatomic) TweetImageUploadState uploadState;
@property (readwrite, nonatomic, strong) NSString *imageStr;
@property (nonatomic, retain) UIImageView *imageV;
@property (strong, nonatomic) NSDate *creationDate;
+ (void)saveImageDate:(NSDate *)date;
+ (BOOL)UserSaveImageDate:(NSDate *)date;
+ (instancetype)tweetImageWithAsset:(PHAsset *)asset;
+ (instancetype)tweetImageWithURL:(NSString *)imageurl;
+ (instancetype)tweetImageWithAssetURL:(NSURL *)assetURL andImage:(UIImage *)image;
@end

