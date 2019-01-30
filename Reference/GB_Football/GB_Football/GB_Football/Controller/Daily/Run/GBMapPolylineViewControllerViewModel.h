//
//  GBMapPolylineViewControllerViewModel.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunInfo.h"

@interface GBMapPolylineViewControllerViewModel : NSObject

@property (nonatomic, strong) NSArray<RunInfo *> *runInfoList;
@property (nonatomic, copy) void(^exceptionBlock)();    //轨迹异常

- (instancetype)initWithDictData:(NSDictionary *)dictData exceptionBlock:(void(^)())exceptionBlock;

- (UIImage *)imageWithOriginImage:(UIImage *)originImage addView:(UIView *)addView;

@end
