//
//  CollectionDetailViewModel.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewModel.h"

@interface CollectionDetailViewModel : BaseViewModel

@property (nonatomic, copy  ) NSString *imgUrl;
@property (nonatomic, strong) UIImage  *placeHolder;
@property (nonatomic, copy  ) NSString *topTitle;
@property (nonatomic, copy  ) NSString *bottomTitle;

@end
