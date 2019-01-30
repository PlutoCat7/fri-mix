//
//  TwoPictureViewModel.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewModel.h"

@interface TwoPictureViewModel : BaseViewModel

@property (nonatomic, copy  ) NSString *firstImageUrl;
@property (nonatomic, strong) UIImage  *firstPlaceHolder;
@property (nonatomic, strong) UIImage  *topLeftIcon;
@property (nonatomic, assign) BOOL     hasTopLeftIcon;

@property (nonatomic, copy  ) NSString *secondImageUrl;
@property (nonatomic, strong) UIImage  *secondPlaceHolder;
@property (nonatomic, strong) UIImage  *topRightIcon;
@property (nonatomic, assign) BOOL     hasTopRightIcon;

@end
