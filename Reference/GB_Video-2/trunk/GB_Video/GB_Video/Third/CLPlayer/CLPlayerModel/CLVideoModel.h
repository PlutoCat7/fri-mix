//
//  CLVideoModel.h
//  PlayView
//
//  Created by yahua on 2018/1/23.
//  Copyright © 2018年 Rainy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLVideoModel : NSObject

@property (nonatomic, assign) NSInteger currentSecond;
@property (nonatomic, assign) NSInteger videoDuration;
@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, copy) NSURL *videoUrl;

@end
