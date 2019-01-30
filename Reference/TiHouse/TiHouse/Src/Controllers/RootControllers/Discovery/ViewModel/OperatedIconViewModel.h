//
//  OperatedIconViewModel.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewModel.h"

@interface OperatedIconViewModel : BaseViewModel

@property (nonatomic, strong  ) UIImage *firstIcon;
@property (nonatomic, copy    ) NSString *firstTitle;

@property (nonatomic, strong  ) UIImage *secondIcon;
@property (nonatomic, copy    ) NSString *secondTitle;

@property (nonatomic, strong  ) UIImage *thirdIcon;
@property (nonatomic, copy    ) NSString *thirdTitle;

@property (nonatomic, strong  ) UIImage  *rightIcon;

@end
