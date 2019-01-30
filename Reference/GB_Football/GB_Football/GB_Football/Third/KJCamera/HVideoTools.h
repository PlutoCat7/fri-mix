//
//  HVideoTools.h
//  GB_Football
//
//  Created by yahua on 2017/12/14.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HVideoTools : UIView

//压缩视频
+ (AVAssetExportSession *)compressedVideoWithMediumQualityWriteToTemp:(id)obj progress:(void (^)(float progress))progress success:(void (^)(NSURL *url))success failure:(void (^)())failure;

@end
