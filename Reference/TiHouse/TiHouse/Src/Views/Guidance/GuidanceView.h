//
//  GuidanceView.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/7.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuidanceView : UIView

@property (nonatomic, assign) CGRect toRect;
@property (nonatomic, copy) void(^nexGuidanceView)(GuidanceView *);
- (void)newUserGuideWithImage:(UIImage *)image;

@end
