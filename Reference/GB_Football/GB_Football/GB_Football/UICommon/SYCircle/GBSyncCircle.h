//
//  GBSyncCircle.h
//  GB_Football
//
//  Created by Pizza on 16/8/30.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBSyncCircle : UIView
@property(nonatomic,assign) CGFloat percent;
// 准备
-(void)prepareWithCompletionBlock:(void(^)())completionBlock;
// 取消
-(void)cancelWithCompletionBlock:(void(^)())completionBlock;
// 开始同步
-(void)showWithCompletionBlock:(void(^)())completionBlock;
// 同步数据
-(void)syncWithCompletionBlock:(void(^)())completionBlock;
// 正在分析数据
-(void)analysisWithCompletionBlock:(void(^)())completionBlock;
// 返回空闲状态
-(void)idleWithCompletionBlock:(void(^)())completionBlock analysisOK:(BOOL)analysisOK;
@end
