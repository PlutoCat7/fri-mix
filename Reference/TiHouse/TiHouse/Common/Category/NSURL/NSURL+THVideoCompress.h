//
//  NSURL+THVideoCompress.h
//  iOSTest
//
//  Created by Charles Zou on 2018/4/23.
//  Copyright © 2018年 Charles Zou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (THVideoCompress)

/**
 视频压缩

 @param completion 视频压缩成功回调
 */
- (void)thVideoCompress:(void(^)(NSURL *assetURL))completion;

@end
