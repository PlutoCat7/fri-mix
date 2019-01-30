//
//  TallySharePan.h
//
//  Created by Pizza on 2016/11/18.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TallyShareItem.h"
#import "UMShareManager.h"

@class TallySharePan;

@protocol TallySharePanDelegate <NSObject>
- (void)TallySharePanAction:(TallySharePan*)pan tag:(SHARE_TYPE)tag;
- (void)TallySharePanActionCancel:(TallySharePan*)pan;
@optional
- (void)TallySharePanActionWillShow:(TallySharePan*)pan;
- (void)TallySharePanActionWillHide:(TallySharePan*)pan;
@end

@interface TallySharePan : UIView
@property (weak, nonatomic) id<TallySharePanDelegate> delegate;
-(TallySharePan*)showSharePanWithDelegate:(id<TallySharePanDelegate>)delegate;
-(TallySharePan*)showSharePanWithDelegate:(id<TallySharePanDelegate>)delegate showSingle:(BOOL)showSingle;
-(void)hide:(void(^)(BOOL success))complete;
@end
