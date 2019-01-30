//
//  GBCircleHub.h
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/7/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBCircleHub : UIView
+ (GBCircleHub *)showWithTip:(NSString*)tip view:(UIView *)view;
+ (BOOL)hide;
+ (GBCircleHub *)show;
+ (GBCircleHub *)changeText:(NSString*)string;
@end
