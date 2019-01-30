//
//  HVideoTools.m
//  GB_Football
//
//  Created by yahua on 2017/12/14.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "HVideoTools.h"

@implementation HVideoTools

+ (AVAssetExportSession *)compressedVideoWithMediumQualityWriteToTemp:(id)obj progress:(void (^)(float progress))progress success:(void (^)(NSURL *url))success failure:(void (^)())failure {
    AVAsset *avAsset;
    if ([obj isKindOfClass:[AVAsset class]]) {
        avAsset = obj;
    }else {
        avAsset = [AVURLAsset URLAssetWithURL:obj options:nil];
    }
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        
        NSString *fileName = [[self uploadFileName] stringByAppendingString:@".mp4"];
        NSString *fullPathToFile = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        NSURL *videoURL = [NSURL fileURLWithPath:fullPathToFile];
        exportSession.outputURL = videoURL;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                if (success) {
                    success(videoURL);
                }
            }else if ([exportSession status] == AVAssetExportSessionStatusFailed){
                if (failure) {
                    failure();
                }
            }else if ([exportSession status] == AVAssetExportSessionStatusCancelled) {
                if (failure) {
                    failure();
                }
            }
        }];
        return exportSession;
    }else {
        if (failure) {
            failure();
        }
        return nil;
    }
}

#pragma mark - Private

+ (NSString *)uploadFileName {
    NSString *fileName = @"";
    NSDate *nowDate = [NSDate date];
    NSString *dateStr = [NSString stringWithFormat:@"%ld", (long)[nowDate timeIntervalSince1970]];
    
    NSString *numStr = [NSString stringWithFormat:@"%d",arc4random()%10000];
    
    fileName = [fileName stringByAppendingString:@"hx"];
    fileName = [fileName stringByAppendingString:dateStr];
    fileName = [fileName stringByAppendingString:numStr];
    return fileName;
}

@end
