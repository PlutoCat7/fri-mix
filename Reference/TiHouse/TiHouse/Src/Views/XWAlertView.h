//
//  XWAlertView.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/12.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWAlertView : UIView

@property (nonatomic, retain) UIImage *image;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) void(^BtnClikc)(void);

- (void)show;
- (void)hide;

@end
