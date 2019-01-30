//
//  GBVerticalCell.h
//  GB_Football
//
//  Created by Pizza on 16/8/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 垂直对齐方向 */
typedef NS_ENUM(NSInteger, VerticalAlignment) {
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom
};


@interface GBVerticalCell : UITableViewCell
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) NSTextAlignment alignment;
@property (nonatomic, assign) VerticalAlignment verticalAlignment;



@end