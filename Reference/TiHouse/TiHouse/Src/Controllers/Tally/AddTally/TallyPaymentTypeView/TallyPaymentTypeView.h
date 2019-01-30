//
//  AddTallyPaymentTypeView.h
//  TiHouse
//
//  Created by AlienJunX on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//
// 支付方式

#import <UIKit/UIKit.h>
typedef void(^SelectedBlock)(NSInteger index, NSString *paymentType);

@interface TallyPaymentTypeView : UIView
@property (assign, nonatomic) NSInteger selectedIndex;
@property (copy, nonatomic) SelectedBlock selectedBlock;

- (void)show;

@end
