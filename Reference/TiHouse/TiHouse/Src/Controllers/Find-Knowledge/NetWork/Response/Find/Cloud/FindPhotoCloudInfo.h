//
//  FindPhotoCloudInfo.h
//  TiHouse
//
//  Created by yahua on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "YAHActiveObject.h"

@interface FindPhotoCloudInfo : YAHActiveObject

@property (nonatomic, assign) long fileid;
@property (nonatomic, copy) NSString *urlfile;  //图片地址
@property (nonatomic, copy) NSString *urlfilesmall; //缩略图

@end
