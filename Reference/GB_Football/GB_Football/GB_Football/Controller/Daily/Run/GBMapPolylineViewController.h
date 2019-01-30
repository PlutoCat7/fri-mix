//
//  GBMapPolylineViewController.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseShareViewController.h"
#import "RunRecordResponseInfo.h"

@interface GBMapPolylineViewController : GBBaseShareViewController

- (instancetype)initWithRunRecordInfo:(RunRecordInfo *)runRecordInfo;

- (instancetype)initWithStartTime:(NSInteger)startTime;

@end
