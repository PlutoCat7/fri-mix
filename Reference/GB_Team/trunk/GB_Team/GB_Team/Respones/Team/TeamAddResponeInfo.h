//
//  TeamAddResponeInfo.h
//  GB_Team
//
//  Created by 王时温 on 2016/11/18.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface TeamAddInfo : GBResponseInfo

@property (nonatomic, assign) NSInteger teamId;

@end

@interface TeamAddResponeInfo : GBResponseInfo

@property (nonatomic, strong) TeamAddInfo *data;

@end
