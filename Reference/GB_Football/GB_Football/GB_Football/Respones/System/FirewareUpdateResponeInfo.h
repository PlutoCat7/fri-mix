//
//  FirewareUpdateResponeInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface FirewareUpdateInfo : YAHActiveObject

@property (nonatomic, copy) NSString *firewareUrl;
@property (nonatomic, assign) BOOL isForce;

@end

@interface FirewareUpdateResponeInfo : GBResponseInfo

@property (nonatomic, strong) FirewareUpdateInfo *data;

@end
