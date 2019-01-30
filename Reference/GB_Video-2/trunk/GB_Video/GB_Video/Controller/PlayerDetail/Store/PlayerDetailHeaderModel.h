//
//  PlayerDetailHeaderModel.h
//  GB_Video
//
//  Created by yahua on 2018/1/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerDetailHeaderModel : NSObject

@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, assign) NSInteger watchCount; //观看次数
@property (nonatomic, assign) NSInteger praiseCount; //点赞次数
@property (nonatomic, assign) BOOL isPraise; //用户是否点赞了
@property (nonatomic, assign) BOOL isCollection; //用户是否收藏了

@end
