//
//  GBBarChart.h
//  GB_Football
//
//  Created by Pizza on 2017/1/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBBarChart : UIView
-(void)showWithTopValue:(NSArray<NSString*>*)topValue
            bottomValue:(NSArray<NSString*>*)bottomValue
            progress:(NSArray<NSNumber*>*)progress;
-(void)showProgressWithAnimation;
@end
