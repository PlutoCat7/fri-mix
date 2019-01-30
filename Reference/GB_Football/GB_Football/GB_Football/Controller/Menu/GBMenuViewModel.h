//
//  GBMenuViewModel.h
//  GB_Football
//
//  Created by yahua on 2017/8/22.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageRequest.h"

@interface GBMenuViewModel : NSObject

//退出足球模式蒙版教程
@property (nonatomic, assign) BOOL isShowCourseMask;

//menu
@property (nonatomic, strong) NSArray<NSString *> *bigItemNames;
@property (nonatomic, strong) NSArray<NSString *> *bigItemImageNames;
@property (nonatomic, strong) NSArray<NSString *> *smallItemImageNames;

//消息
@property (nonatomic, assign) BOOL isNewMessage;
@property (nonatomic, strong, readonly) NewMessageInfo *hasNewMessageInfo;

- (void)checkHasNewMessage;
- (UIImage *)messageIcon;


@end
