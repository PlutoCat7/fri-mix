//
//  OptionDetailViewModel.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/8.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewModel.h"

@interface OptionDetailViewModel : BaseViewModel

@property (nonatomic, strong  ) UIImage     *leftIcon;
@property (nonatomic, copy    ) NSString    *optionText;
@property (nonatomic, copy    ) NSString    *rightOptionText;
@property (nonatomic, strong  ) UIImage     *arrowImage;

@end
