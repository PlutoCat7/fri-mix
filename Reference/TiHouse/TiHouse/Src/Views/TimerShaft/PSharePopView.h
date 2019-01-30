//
//  PSharePopView.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/2/10.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSharePopView : UIView

@property (nonatomic, copy) void(^ClickBtnWithTag)(NSInteger tag);
@property (nonatomic, assign) BOOL collected;
-(void)show;
-(void)close;

@end
