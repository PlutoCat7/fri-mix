//
//  VideoListCellModel.h
//  GB_Video
//
//  Created by yahua on 2018/1/25.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "CLVideoModel.h"

@interface VideoListCellModel : CLVideoModel

@property (nonatomic, copy) NSString *videoImageUrl; //视频图片， 用于默认显示

@property (nonatomic, assign) NSInteger watchCount;  //观看次数
@property (nonatomic, assign) BOOL isPraise;         //用户是否点赞了
@property (nonatomic, assign) BOOL isCollection;     //用户是否收藏了

@end
