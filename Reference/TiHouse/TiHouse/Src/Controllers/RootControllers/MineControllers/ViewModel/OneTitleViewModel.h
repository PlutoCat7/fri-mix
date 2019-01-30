//
//  OneTitleViewModel.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/23.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewModel.h"

@interface OneTitleViewModel : BaseViewModel

@property (nonatomic , copy  ) NSString *title;
@property (nonatomic, assign ) NSTextAlignment *textAlignment;

@end
