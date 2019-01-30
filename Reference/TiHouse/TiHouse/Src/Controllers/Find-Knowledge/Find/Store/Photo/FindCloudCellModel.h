//
//  FindCloudCellModel.h
//  TiHouse
//
//  Created by yahua on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindCloudCellModel : NSObject

@property (nonatomic, assign) long fileid;
@property (nonatomic, copy) NSURL *imageUrl;
@property (nonatomic, strong) UIImage *image;

@end
