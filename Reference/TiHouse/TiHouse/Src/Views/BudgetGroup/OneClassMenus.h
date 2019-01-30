//
//  OneClassMenus.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/25.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneClassMenus : UIView

@property (nonatomic, retain) NSArray *btnDatas;
@property (nonatomic, copy) void(^MenuClikcWihtTag)(NSInteger tag);

@end
