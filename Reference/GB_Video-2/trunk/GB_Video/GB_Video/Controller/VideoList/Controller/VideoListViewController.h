//
//  VideoListViewController.h
//  GB_Video
//
//  Created by yahua on 2018/1/25.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBBaseViewController.h"

@interface VideoListViewController : GBBaseViewController

- (instancetype)initWithTopicId:(NSInteger)topicId;
- (instancetype)initWithTopicId:(NSInteger)topicId title:(NSString *)title;

@end
