//
//  NSURL+THVideoCompress.m
//  iOSTest
//
//  Created by Charles Zou on 2018/4/23.
//  Copyright © 2018年 Charles Zou. All rights reserved.
//

#import "NSURL+THVideoCompress.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@implementation NSURL (THVideoCompress)

- (void)thVideoCompress:(void(^)(NSURL *assetURL))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *assetURL = self;
        NSLog(@"压缩前: %f MB", [[NSData dataWithContentsOfURL:assetURL] length]/1024/1024.0);
        AVAsset* asset = [AVAsset assetWithURL:assetURL];
        //暂时先改成高质量. 根据需求 前面压缩过的视频 被压缩得太模糊
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
        session.shouldOptimizeForNetworkUse = YES;

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMdd-HHmmssSSS";
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
                          stringByAppendingPathComponent:[NSString stringWithFormat:@"th_tmp_%@.mp4", dateString]];
        [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
        session.outputURL = [NSURL fileURLWithPath:path];
        session.outputFileType = AVFileTypeMPEG4;
        [session exportAsynchronouslyWithCompletionHandler:^{
            //压缩完成
            if(session.status==AVAssetExportSessionStatusCompleted) {
                NSLog(@"压缩完成 ,压缩后大小 %f MB", [[NSData dataWithContentsOfURL:session.outputURL] length]/1024/1024.0);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(session.outputURL);
                    };
                });
            }
        }];
    });
}


@end
