//
//  GBSharePan.h
//  GB_Football
//
//  Created by Pizza on 2016/11/18.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBShareItem.h"
#import "UMShareManager.h"

@class GBSharePan;

@protocol GBSharePanDelegate <NSObject>
- (void)GBSharePanAction:(GBSharePan*)pan tag:(SHARE_TYPE)tag;
- (void)GBSharePanActionCancel:(GBSharePan*)pan;
@optional
- (void)GBSharePanActionWillShow:(GBSharePan*)pan;
- (void)GBSharePanActionWillHide:(GBSharePan*)pan;
@end

@interface GBSharePan : UIView
@property (weak, nonatomic) id<GBSharePanDelegate> delegate;
-(GBSharePan*)showSharePanWithDelegate:(id<GBSharePanDelegate>)delegate;
-(GBSharePan*)showSharePanWithDelegate:(id<GBSharePanDelegate>)delegate showSingle:(BOOL)showSingle;
-(GBSharePan*)showSharePanWithDelegate:(id<GBSharePanDelegate>)delegate favorState:(NSInteger)favorState;
-(void)hide:(void(^)(BOOL success))complete;
@end
