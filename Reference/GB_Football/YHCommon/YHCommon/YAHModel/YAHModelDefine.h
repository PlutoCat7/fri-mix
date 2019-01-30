//
//  YAHModelDefine.h
//  YAHModel
//
//  Created by yahua on 16/4/5.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#ifndef YAHModelDefine_h
#define YAHModelDefine_h

typedef NS_ENUM(NSUInteger, YAHRequestErrorCode) {
    YAHRequestErrorUnknow = -1,
    YAHRequestErrorCancel = 999,
    YAHRequestErrorParameter = 1000,  //参数错误
    YAHRequestErrorAdapter = 1001,    //解析出错
    YAHRequestErrorOther = 1002,      //超时、url错误、host错误等
};

typedef NS_ENUM(NSUInteger, YHRequestStyle) {
    YHRequestStyleUnKnow,
    YHRequestStyleRow,   //row格式
    YHRequestStyleForm,  //form-data格式
};


typedef NS_ENUM(NSUInteger, YAHRequestState) {
    YAHRequestStateRunning,
    YAHRequestStateSuspended,
    YAHRequestStateCanceling,
    YAHRequestStateFailure,
    YAHRequestStateSuccess,
};

#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

typedef void (^YAHModelCompleteBlock)(NSError * _Nullable error);

typedef void (^YAHQuickNetworkCompleteBlock)(NSDictionary *_Nullable jsonDic, NSError * _Nullable error);

#endif /* YAHModelDefine_h */
