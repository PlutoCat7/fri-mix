//
//  TracticsPlayerModel.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "YAHActiveObject.h"
#import "TeamHomeResponeInfo.h"

@interface LineUpPlayerModel : YAHActiveObject

@property (nonatomic, copy) NSString *posName;  //位置名称 eg:后卫
@property (nonatomic, assign) NSInteger posIndex; //阵型位置
@property (nonatomic, copy) NSString *emptyImageName; //无球员时的占位图

@property (nonatomic, strong) TeamPalyerInfo *playerInfo;

@end
