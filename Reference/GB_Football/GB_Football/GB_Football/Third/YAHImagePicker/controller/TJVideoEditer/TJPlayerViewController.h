//
//  TJPlayerViewController.h
//  TJVideoEditer
//
//  Created by TanJian on 17/2/10.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


@interface TJPlayerViewController : UIViewController

@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, assign) CGFloat videoLimitTime;   //视频限制时长
//保存完成后的回调
@property (nonatomic, copy) void (^cutDoneBlock)(NSURL *);

@end
