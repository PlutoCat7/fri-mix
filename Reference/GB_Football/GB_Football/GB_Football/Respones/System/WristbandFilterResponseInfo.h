//
//  WristbandFilterResponseInfo.h
//  GB_Football
//
//  Created by 王时温 on 2016/12/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"
#import "GBBluetoothManager.h"

@interface WristbandFilterInfo : YAHActiveObject

@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *handEquipName;
@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *showNumber;    //序列号界面显示文本
@property (nonatomic, strong) iBeaconInfo *ibeacon;   //扫描到的手环信息

@end

@interface WristbandFilterResponseInfo : GBResponseInfo

@property (nonatomic, strong) NSArray<WristbandFilterInfo *> *data;

@end
