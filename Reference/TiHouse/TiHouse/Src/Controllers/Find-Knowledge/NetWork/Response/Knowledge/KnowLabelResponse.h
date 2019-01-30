//
//  KnowLabelResponse.h
//  TiHouse
//
//  Created by weilai on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "GBResponseInfo.h"

@interface KnowLabelInfo : YAHActiveObject

@property (assign, nonatomic) NSInteger lableknowid;
@property (strong, nonatomic) NSString *lableknowname;

@end

@interface KnowLabelResponse : GBResponseInfo

@property (nonatomic, strong) NSArray<KnowLabelInfo *> *data;

@end
