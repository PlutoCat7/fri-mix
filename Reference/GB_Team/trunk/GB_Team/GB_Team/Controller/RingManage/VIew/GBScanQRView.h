//
//  GBScanQRView.h
//  GB_Football
//
//  Created by Pizza on 16/8/17.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface BackView : UIView
@property (assign,nonatomic) CGRect rectWhite;
@end

@interface GBScanQRView : UIView
@property (nonatomic, assign) BOOL isStart;
@property (copy, nonatomic) void(^selectedHandler)(NSString *item);

- (void)cleanData;
- (void)startCameraScan;
- (void)stopCameraScan;

@end
