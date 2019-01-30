//
//  TracticsModel.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/31.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "YAHActiveObject.h"

@interface LineUpModel : YAHActiveObject

@property (nonatomic, assign) TracticsType tracticsType;
@property (nonatomic, copy, readonly) NSString *name;

@end
