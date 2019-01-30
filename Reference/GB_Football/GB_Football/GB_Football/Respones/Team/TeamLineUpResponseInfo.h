//
//  TeamTracticsResponseInfo.h
//  GB_Football
//
//  Created by 王时温 on 2017/8/1.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"
#import "TeamHomeResponeInfo.h"

@interface TeamLineUpInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger position;
@property (nonatomic, strong) TeamPalyerInfo *user_mess;

@end

@interface TeamLineUpResponseInfo : GBResponseInfo

@property (nonatomic, strong) NSArray<TeamLineUpInfo *> *data;

@end
