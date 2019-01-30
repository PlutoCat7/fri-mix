//
//  RecordListCellModel.h
//  GB_Football
//
//  Created by yahua on 2017/9/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordListCellModel : NSObject

@property (nonatomic, copy) NSString *dayString;
@property (nonatomic, copy) NSString *yearMonthString;
@property (nonatomic, copy) NSString *matchName;
@property (nonatomic, copy) NSString *matchAddress;
@property (nonatomic, copy) NSString *matchTypeString;
@property (nonatomic, assign) BOOL isWating;  //是否是等待处理

@end
