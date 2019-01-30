//
//  FindWaterfallModel.h
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindWaterfallModel : NSObject

@property (nonatomic, assign) long identifier;
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, copy) NSURL *imageUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSAttributedString *contentAttributedString;
@property (nonatomic, copy) NSURL *userAvatorUrl;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) BOOL isMeLike;   //我是否收藏

//缓存计算完的高度
@property (nonatomic, assign) CGFloat caculateHeight;

@end
