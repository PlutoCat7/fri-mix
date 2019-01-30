//
//  ScheduleDayModel.h
//  TiHouse
//
//  Created by apple on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduleDayListModel.h"

@interface ScheduleDayModel : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) NSArray <ScheduleDayListModel*>*list;


@end
