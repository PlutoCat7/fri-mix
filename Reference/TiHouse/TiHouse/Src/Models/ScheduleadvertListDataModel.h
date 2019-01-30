//
//  ScheduleadvertListDataModel.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleadvertListDataModel : NSObject

@property (nonatomic, assign  ) NSInteger advertendtime;
@property (nonatomic, assign  ) NSInteger advertstarttime;
@property (nonatomic, copy  ) NSString *allurllink;
@property (nonatomic, copy  ) NSString *createtime;
@property (nonatomic, copy  ) NSString *scheadvertcolor;
@property (nonatomic, copy  ) NSString *scheadvertdesc;
@property (nonatomic, copy  ) NSString *scheadvertid;
@property (nonatomic, copy  ) NSString *scheadvertname;
@property (nonatomic, copy  ) NSString *statusshow;
@property (nonatomic, copy  ) NSString *updatetime;
@property (nonatomic, copy  ) NSString *urlpicindex;
@property (nonatomic, copy  ) NSString *adverttype; 

@end
