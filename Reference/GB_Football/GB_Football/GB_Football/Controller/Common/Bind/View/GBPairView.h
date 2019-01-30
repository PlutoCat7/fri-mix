//
//  GBPairView.h
//  GB_Football
//
//  Created by Pizza on 2016/12/20.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBPairView : UIView
// 从连接中到连接成功
-(void)connectingTurnToConnected:(void(^)())completionBlock;
// 从成功连接到正在连接
-(void)connectedTurnToConnecting:(void(^)())completionBlock;
// 从连接中到连接失败
-(void)connectingTurnToFailed:(void(^)())completionBlock;
// 从失败到连接中
-(void)failedTurnToConnecting:(void(^)())completionBlock;
@end
