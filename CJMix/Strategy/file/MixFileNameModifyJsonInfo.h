//
//  FileNameModifyJsonInfo.h
//  najiabao-file
//
//  Created by wangshiwen on 2019/1/24.
//  Copyright © 2019 yahua. All rights reserved.
//  导出修改pbproj json数据

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MixSingleModifyJsonInfo : NSObject

@property (nonatomic, strong) NSMutableDictionary *insert;  //不能修改属性名
@property (nonatomic, strong) NSMutableDictionary *remove;  //不能修改属性名
@property (nonatomic, strong) NSMutableDictionary *modify;  //不能修改属性名

@end

@interface MixFileNameModifyJsonInfo : NSObject

@property (nonatomic, strong) MixSingleModifyJsonInfo *forward;
@property (nonatomic, strong) MixSingleModifyJsonInfo *backward;
@property (nonatomic, assign) NSInteger version;

- (NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
