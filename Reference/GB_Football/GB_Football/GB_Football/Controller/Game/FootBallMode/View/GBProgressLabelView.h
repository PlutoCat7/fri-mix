//
//  GBProgressLabelView.h
//  GB_Football
//
//  Created by Pizza on 2016/11/9.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PROGRESS_STATE) {
    PROGRESS_STATE_IDLE,    // 空闲
    PROGRESS_STATE_ING0,    // 状态0/3
    PROGRESS_STATE_ING1,    // 状态1/3
    PROGRESS_STATE_ING2,    // 状态2/3
    PROGRESS_STATE_ING3,    // 状态3/3
    PROGRESS_STATE_FAILED,  // 失败
    PROGRESS_STATE_GUIDE,   // 未进入足球模式,引导页面
};

@interface GBProgressLabelView : UIView

@property (assign, nonatomic) PROGRESS_STATE state;

@end
