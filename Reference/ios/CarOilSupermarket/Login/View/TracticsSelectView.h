//
//  TracticsSelectView.h
//  GB_Football
//
//  Created by yahua on 2017/7/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TracticsSelectView : UIView

+ (instancetype)showWithTopY:(CGFloat)topY entries:(NSArray<NSString *> *)entries selectIndex:(NSInteger)selectIndex cancel:(void(^)())cancel complete:(void(^)(NSInteger index))complete;

- (void)dismiss;

@end
