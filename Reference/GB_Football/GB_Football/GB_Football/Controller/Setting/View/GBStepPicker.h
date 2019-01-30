//
//  GBStepPicker.h
//  GB_Football
//
//  Created by weilai on 16/8/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GBStepPicker : UIView

+ (instancetype)showWithSelectStep:(NSInteger)step complete:(void(^)(NSInteger step))complete;

@end
