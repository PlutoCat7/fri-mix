//
//  AreaInfo.h
//  GB_Football
//
//  Created by wsw on 16/8/3.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaInfo : NSObject

@property (nonatomic, weak) AreaInfo *superAreaInfo;
@property (nonatomic, assign) NSInteger      areaID;
@property (nonatomic, copy  ) NSString       *areaName;
@property (nonatomic, strong) NSMutableArray *areaChidlArray;   //例如：area是省的话，就是市级数组

@end
