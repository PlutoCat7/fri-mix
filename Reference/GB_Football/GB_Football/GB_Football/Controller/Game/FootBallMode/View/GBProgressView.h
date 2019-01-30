//
//  GBProgressView.h
//  GB_Football
//
//  Created by Pizza on 2016/10/31.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,GPS_PROGRAM_STATE)
{
    STATE_IDLE = 0,         // 空闲
    STATE_DOWNLOADING,      // 下载开始－星历下载中
    STATE_DOWNLOAD_FINISH,  // 星历下载完成
    STATE_PROGRAMMING,      // 写入开始－星历写入中
    STATE_PROGRAM_FINISH,   // 星历写入完成
    STATE_PROGRAM_FAIED,    // 失败
};

@interface GBProgressView : UIView

@property (nonatomic, assign) GPS_PROGRAM_STATE state;
// 设置状态
-(void)setupState:(GPS_PROGRAM_STATE)state;
// 取值范围0-100
@property (nonatomic,assign) CGFloat percent;
@end
