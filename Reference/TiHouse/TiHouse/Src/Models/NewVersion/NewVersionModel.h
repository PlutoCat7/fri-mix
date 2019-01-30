//
//  NewVersionModel.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/4/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionContentModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger index;

@end

@interface NewVersionModel : NSObject

@property (nonatomic, assign) int versionno;
@property (nonatomic, copy) NSString *versioncode;
@property (nonatomic, strong) NSArray<VersionContentModel *> *versioncontentJA;
@property (nonatomic, assign) double labelWidth;
@property (nonatomic, strong) NSMutableArray *heightsArray;

+ (void)checkNewVersion:(void(^)(BOOL b, NewVersionModel *model))block;

@end
