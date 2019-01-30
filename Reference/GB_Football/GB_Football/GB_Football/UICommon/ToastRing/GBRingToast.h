//
//  GBRingToast.h
//  GB_Football
//
//  Created by Pizza on 2016/12/2.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBRingToast : UIView
+ (GBRingToast *)showWithTip:(NSString*)tip;
+ (void)hide;
@end

