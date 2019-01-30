//
//  MineOptionViewModel.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/23.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewModel.h"

@class MineOptionDetailViewModel;

@interface MineOptionViewModel : BaseViewModel

@property (nonatomic, strong) MineOptionDetailViewModel *leftViewModel;

@property (nonatomic, strong) MineOptionDetailViewModel *centerViewModel;

@property (nonatomic, strong) MineOptionDetailViewModel *rightViewModel;

@end
