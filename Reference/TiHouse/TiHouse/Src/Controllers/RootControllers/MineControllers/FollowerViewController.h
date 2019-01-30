//
//  FollowerViewController.h
//  TiHouse
//
//  Created by admin on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"

@interface FollowerViewController : BaseViewController


@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) NSMutableArray *followers;
@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, assign) NSInteger uid;

@end

