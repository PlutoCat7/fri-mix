//
//  TweetWHModel.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/3/18.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetWHModel : NSObject
// 时间轴页面图片长宽比model
@property (nonatomic, assign) int fileindex;
@property (nonatomic, assign) float filepercentwh;
@property (nonatomic, copy) NSString *fileurlsmall;

@end
