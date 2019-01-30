//
//  UserGradeStarView.h
//  CarOilSupermarket
//
//  Created by wangshiwen on 2018/3/18.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNibBridge.h"

@interface UserGradeStarView : UIView <XXNibBridge>

- (void)refreshViewLevel:(NSInteger)level;

@end
