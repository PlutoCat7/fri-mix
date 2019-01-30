//
//  AdverHeadViewModel.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewModel.h"

@interface AdverHeadViewModel : BaseViewModel

@property (nonatomic, copy  ) NSString *adv_imageUrl;
@property (nonatomic, copy  ) NSString *topRightTitle;
@property (nonatomic, strong) UIImage  *placeHolder;

@end
