//
//  CloudRecordCollectVC.h
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
#import "CloudRecordCollectView.h"

@interface CloudRecordCollectVC : BaseViewController

@property (assign, nonatomic) CloudRecordType type;//请求类型
@property (assign, nonatomic) long houseID;//房屋id
@property (assign, nonatomic) long folderID;//文件id
@property (copy, nonatomic) NSString * monthStr;//月份时间
@property (copy, nonatomic) NSString * titleName;//标题

@end
