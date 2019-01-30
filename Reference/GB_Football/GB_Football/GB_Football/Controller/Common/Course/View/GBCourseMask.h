//
//  GBCourseMask.h
//  GB_Football
//
//  Created by Pizza on 2017/3/11.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, COURSE_MASK_TYPE) {
    COURSE_MASK_MENU        = 1,
    COURSE_MASK_FOOTBALL    = 2,
    COURSE_MASK_COMPLETE    = 3,
    COURSE_MASK_TEAM        = 4,
};

@interface GBCourseMask : UIView
-(void)showWithType:(COURSE_MASK_TYPE)type;
@property (nonatomic, copy) void (^action)();
@end
