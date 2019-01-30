//
//  PlayerDetailViewController.h
//  GB_Video
//
//  Created by yahua on 2018/1/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoDetailInfo;
@interface PlayerDetailViewController : UIViewController

- (instancetype)initWithVideoId:(NSInteger)videoId;
- (instancetype)initWithVideoInfo:(VideoDetailInfo *)videoInfo;

@end
