//
//  CWNumberKeyboard.h
//  CWNumberKeyboardDemo
//
//  Created by william on 16/3/19.
//  Copyright © 2016年 陈大威. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^numberKeyboardBlock)(NSString *priceString);

@interface CWNumberKeyboard : UIView

@property (assign, nonatomic) BOOL isShowSymbol; // 处理货币符号 ￥ ,默认YES
@property (assign, nonatomic) NSString *currencySymbol; // 默认￥
@property (assign, nonatomic) BOOL isAdjustTextfieldFont; // 调整字体大小 默认YES

//- (void)showNumKeyboardViewAnimateWithPrice:(NSString *)priceString andBlock:(numberKeyboardBlock)block;

// 使用此方法
// textField: 必须
- (void)showNumKeyboardViewAnimateWithTextField:(UITextField *)textField
                                       andBlock:(numberKeyboardBlock)block;

@end
