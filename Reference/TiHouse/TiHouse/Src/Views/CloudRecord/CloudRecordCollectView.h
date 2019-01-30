//
//  CloudRecordCollectView.h
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseView.h"

typedef enum : NSUInteger {
    CloudRecordFolder = 0,//文件
    CloudRecordMonth = 1,//月份
    CloudRecordPhoto = 2,//图片
    CloudRecordVideo = 3,//视频
    CloudRecordCollect = 4,//收藏
    CloudRecordRecent = 5,//最近上传
} CloudRecordType;

@interface CloudRecordCollectView : BaseView

+ (instancetype)shareInstanceWithViewModel:(id<BaseViewModelProtocol>)viewModel withHouseID:(long)houseID withFolderID:(long)folderID withType:(CloudRecordType )type withMonthStr:(NSString *)monthStr;

@property (strong, nonatomic) UIViewController * viewController;

- (id)currentPreviewCell:(id)model;

@end
