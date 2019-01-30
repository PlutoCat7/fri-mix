//
//  GBGameDetailUserInfoView.h
//  GB_Football
//
//  Created by yahua on 2017/8/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNibBridge.h"
#import "MatchResponseInfo.h"

@interface GBGameDetailUserInfoView : UIView <
XXNibBridge>

@property (nonatomic, strong) MatchUserInfo *matchUserInfo;

@end
