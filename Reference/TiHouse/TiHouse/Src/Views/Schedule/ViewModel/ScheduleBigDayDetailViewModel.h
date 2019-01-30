//
//  ScheduleBigDayDetailViewModel.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewModel.h"

@interface ScheduleBigDayDetailViewModel : BaseViewModel

@property (nonatomic, copy  ) NSString *topImageUrl;
@property (nonatomic, copy  ) NSString *centerLeftTItle;
@property (nonatomic, copy  ) NSString *centerRightTitle;
@property (nonatomic, strong) NSMutableArray *options;

@end
