//
//  MonthDairyModel.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/4/16.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonthDairyFile: NSObject

@property (nonatomic, assign) NSInteger fileindex;
@property (nonatomic, copy) NSString *fileurlsmall;
@property (nonatomic, assign) CGFloat filepercentwh;
@property (nonatomic, assign) NSInteger filetype;

@end

@interface MonthDairyModel : NSObject

@property (nonatomic, copy) NSString *dairymonth;
@property (nonatomic, assign) NSInteger dairymonthnum;
@property (nonatomic, copy) NSArray<MonthDairyFile *> *dairymonthfileJA;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *MM;
@property (assign, nonatomic) BOOL isMonthFile;//是否是月份过来的数据
@end
