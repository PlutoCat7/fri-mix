//
//  GBView.h
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/7/28.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface GBView : UIView

@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;

@property (nonatomic) IBInspectable UIColor *bgStartColor;
@property (nonatomic) IBInspectable CGPoint bgStartPoint;
@property (nonatomic) IBInspectable UIColor *bgEndColor;
@property (nonatomic) IBInspectable CGPoint bgEndPoint;

@end
