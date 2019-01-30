//
//  GBBorderButton.h
//  GB_Football
//
//  Created by Pizza on 2016/12/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBBorderButton : UIButton
-(void)setupNomalBorderColor:(UIColor*)normal   pressColor:(UIColor*)pressColor;
-(void)setupNomalTextColor:(UIColor*)normal     pressColor:(UIColor*)pressColor;
-(void)setupNomalBackColor:(UIColor*)normal     pressColor:(UIColor*)pressColor;
@end
