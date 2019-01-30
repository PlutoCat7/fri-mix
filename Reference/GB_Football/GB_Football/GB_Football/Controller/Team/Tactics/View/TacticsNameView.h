//
//  TacticsNameView.h
//  GB_Football
//
//  Created by yahua on 2018/1/17.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TacticsNameView : UIView

+ (void)showWithName:(NSString *)name block:(void(^)(NSString *name))block;

@end
