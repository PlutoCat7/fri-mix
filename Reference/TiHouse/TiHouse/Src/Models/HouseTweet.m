//
//  HouseTweet.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/16.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "HouseTweet.h"
#import "Folder.h"
#import "Login.h"
#import "HXPhotoTools.h"
#import "House.h"
#import "NSDate+Extend.h"
#import <YYModel.h>
#import "UIImage+Resize.h"

@implementation FileModel

@end

@implementation RangeModel

@end

@implementation RemindModel

@end


@implementation HouseTweet

-(instancetype)init{
    if (self = [super init]) {
        self.images = [NSMutableArray new];
        self.fileJAstr = [NSMutableArray new];
        self.dairyrangeJAstr = [NSMutableArray new];
        self.dairyremindJAstr = [NSMutableArray new];
    }
    return self;
}

- (NSString *)toPath:(BOOL)isEdit {
    return isEdit ? @"/api/inter/dairy/editnew" : @"api/inter/dairy/addnew";
}

- (NSDictionary *)toParams:(BOOL)isEdit {
    
    //    NSDate *nowDate = [NSDate date];
    
    //    NSString *dateStr = [NSString stringWithFormat:@"%.0f", [nowDate timeIntervalSince1970]*1000];
    
    //    long lastDateStr = [[dateStr substringFromIndex:dateStr.length-3] integerValue];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setValue:@(_house.houseid) forKey:@"houseid"];
    
    [dic setValue:_dairydesc ? : @"" forKey:@"dairydesc"];
    
    [dic setValue:_folder ? @(_folder.folderid) : @(_house.defaultfoldid) forKey:@"folderid"];
    
    [dic setValue:@(_dairytimetype) forKey:@"dairytimetype"];
    // 1 自己 2部分 3所有人
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)_visibleRange] forKey:@"dairyrangetype"];
    // 自定义时间字段
    [dic setValue:_diytime ? : @"" forKey:@"diytime"];
    // 文件数组
    [dic setValue:[[self getArrurlfile] yy_modelToJSONString] forKey:@"fileJAstr"];
    // 可见范围数组
    [dic setValue:[[self visibleRangeStr]yy_modelToJSONString] forKey:@"dairyrangeJAstr"];
    // 提醒谁看数组
    [dic setValue:[[self remindRangeStr] yy_modelToJSONString]forKey:@"dairyremindJAstr"];
    
    if (isEdit) {
        [dic setValue:@(self.dairy.dairy.dairyid) forKey:@"dairyid"];
    }
    
    //    [dic setValue:_createData ? _createData : dateStr forKey:@"dairytime"];
    //    [dic setValue:[self visibleRangeStr] forKey:@"arruidrange"];
    //    [dic setValue:[self getArrurlfile] forKey:@"arrurlfile"];
    //    [dic setValue:_type == 1 && _images.count > 0 ? @(2) : @(_type)  forKey:@"dairytype"];
    //    [dic setValue:[self remindRangeStr] forKey:@"arruidremind"];
    return dic;
}

- (NSMutableArray *)remindRangeStr
{
    if (_remindArr.count != 0) { // 编辑时选择了范围则先清空
        [_dairyremindJAstr removeAllObjects];
    }
    //    NSString *remindRangeStr = @"";
    for (User *user in _remindArr) {
        //        if (remindRangeStr.length <= 0) {
        //            remindRangeStr = [NSString stringWithFormat:@"%ld",user.uidconcert];
        //        }else{
        //            remindRangeStr = [NSString stringWithFormat:@"%@,%ld",remindRangeStr,user.uidconcert];
        //        }
        [_dairyremindJAstr addObject:@{@"dairyreminduid": @(user.uidconcert)}];
    }
    return _dairyremindJAstr;
}

-(NSMutableArray *)getArrurlfile{
    //    NSString *arrurlfile = @"";
    for (TweetImage *imageItem in _images) {
        FileModel *fileModel = [[FileModel alloc] init];
        fileModel.phototime = [NSString stringWithFormat:@"%.0f", [imageItem.creationDate timeIntervalSince1970]*1000];
        fileModel.filetype = [imageItem.imageStr hasSuffix:@".mp4"] ? 2 : 1;
        fileModel.fileurl = imageItem.imageStr;
        [_fileJAstr addObject:fileModel];
    }
    
    return _fileJAstr;
}



-(NSMutableArray *)visibleRangeStr{
    if (_visibleArr.count != 0) { // 编辑时选择了范围则先清空
        [_dairyrangeJAstr removeAllObjects];
    }
    //    NSString *arruidrange = @"";
    for (User *user in _visibleArr) {
        //        if (arruidrange.length <= 0) {
        //            arruidrange = [NSString stringWithFormat:@"%ld",user.uidconcert];
        //        }else{
        //            arruidrange = [NSString stringWithFormat:@"%@,%ld",arruidrange,user.uidconcert];
        //        }
        [_dairyrangeJAstr addObject:@{@"dairyrangeuid": @(user.uidconcert)}];
    }
    
    return _dairyrangeJAstr;
}


- (BOOL)isAllImagesDoneSucess{
    for (TweetImage *imageItem in _images) {
        if (imageItem.imageStr.length <= 0) {
            return NO;
        }
    }
    return YES;
}


+ (void) convertVideoWithModel:(HouseTweet *) model
{
    model.filename = [NSString stringWithFormat:@"%ld.mp4",[NSDate timestampFromDate:[NSDate date]]];
    //保存至沙盒路径
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *videoPath = [NSString stringWithFormat:@"%@/Image", pathDocuments];
    model.sandBoxFilePath = [videoPath stringByAppendingPathComponent:model.filename];
    
    //转码配置
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:model.url options:nil];
    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputURL = [NSURL fileURLWithPath:model.sandBoxFilePath];
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exportSession.status;
        switch (exportStatus)
        {
            case AVAssetExportSessionStatusFailed:
            {
                // log error to text view
                NSError *exportError = exportSession.error;
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                break;
            }
            case AVAssetExportSessionStatusCompleted:
            {
                
                NSData *data = [NSData dataWithContentsOfFile:model.sandBoxFilePath];
                model.fileData = data;
            }
        }
    }];
    
}



@end


@implementation TweetImage

+ (void)saveImageDate:(NSDate *)date{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *images = [defaults objectForKey:@"saveImageDate"];
    if (images) {
        if ([images containsObject:date]) {
            return;
        }
        images = [images mutableCopy];
        [images addObject:date];
        [defaults setObject:images forKey:@"saveImageDate"];
        [defaults synchronize];
    }else{
        NSMutableArray *arr = [NSMutableArray new];
        [arr addObject:date];
        [defaults setObject:arr forKey:@"saveImageDate"];
        [defaults synchronize];
    }
}

+ (BOOL)UserSaveImageDate:(NSDate *)date{
    NSMutableArray *images = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveImageDate"];
    if ([images containsObject:date]) {
        return YES;
    }
    return NO;
}

+ (instancetype)tweetImageWithAsset:(PHAsset *)asset{
    TweetImage *tweetImg = [[TweetImage alloc] init];
    tweetImg.uploadState = TweetImageUploadStateInit;
    __block NSData *data;
    [HXPhotoTools getImageData:asset startRequestIcloud:^(PHImageRequestID cloudRequestId) {
        
    } progressHandler:^(double progress) {
        
    } completion:^(NSData *imageData, UIImageOrientation orientation) {
        data = imageData;
    } failed:^(NSDictionary *info) {
        
    }];
    tweetImg.image = [UIImage imageWithData:data];
    return tweetImg;
}

+ (instancetype)tweetImageWithAssetURL:(NSURL *)assetURL andImage:(UIImage *)image{
    TweetImage *tweetImg = [[TweetImage alloc] init];
    tweetImg.uploadState = TweetImageUploadStateInit;
    tweetImg.assetURL = assetURL;
    tweetImg.image = image;
    tweetImg.thumbnailImage = [image scaledToSize:CGSizeMake(kRKBWIDTH(70), kRKBWIDTH(70)) highQuality:YES];
    return tweetImg;
}

+ (instancetype)tweetImageWithURL:(NSString *)imageurl{
    
    TweetImage *tweetImg = [[TweetImage alloc] init];
    tweetImg.uploadState = TweetImageUploadStateInit;
    tweetImg.image = [[SDImageCache sharedImageCache] imageFromCacheForKey:imageurl];
    tweetImg.thumbnailImage = [tweetImg.image scaledToSize:CGSizeMake(kRKBWIDTH(70), kRKBWIDTH(70)) highQuality:YES];
    return tweetImg;
}

@end


