//
//  LoginOpenIDOAuthView.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/29.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginOpenIDOAuthView : UIView

@property (nonatomic, copy) void(^click)(NSInteger itemIndex);
-(void)showItems;
-(void)hideItems;

@end
