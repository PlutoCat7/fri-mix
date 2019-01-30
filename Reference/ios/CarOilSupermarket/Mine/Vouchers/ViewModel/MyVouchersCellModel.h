//
//  MyVouchersCellModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/15.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyVouchersCellModel : NSObject

@property (nonatomic, assign) NSInteger vouchersId;

@property (nonatomic, copy) NSString *title;  
@property (nonatomic, copy) NSString *validDate;  //有效日期至
@property (nonatomic, copy) NSAttributedString *worthAttributedString; //价值
@property (nonatomic, copy) NSString *buyDate;  //够买日期
@property (nonatomic, assign) BOOL isSelected; //是否被选择了

@end
