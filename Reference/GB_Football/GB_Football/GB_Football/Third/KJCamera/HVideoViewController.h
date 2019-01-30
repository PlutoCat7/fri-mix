//
//  HVideoViewController.h
//  Join
//
//  Created by 黄克瑾 on 2017/1/11.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HVideoTakeType) {
    HVideoTakeType_ALL,
    HVideoTakeType_Photo,
    HVideoTakeType_Video,
};

typedef void(^TakeOperationSureBlock)(id item);

@interface HVideoViewController : UIViewController

@property (copy, nonatomic) TakeOperationSureBlock takeBlock;

@property (nonatomic, assign) HVideoTakeType takeType;

@property (assign, nonatomic) NSInteger HSeconds;

@end
