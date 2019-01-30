//
//  ThreePictureViewModel.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewModel.h"

@interface ThreePictureViewModel : BaseViewModel

@property (nonatomic, copy  ) NSString *firstImageUrl;
@property (nonatomic, strong) UIImage  *firstPlaceHolder;
@property (nonatomic, strong) UIImage  *firstTopIcon;
@property (nonatomic, assign) BOOL     hasFirstTopIcon;

@property (nonatomic, copy  ) NSString *secondImageUrl;
@property (nonatomic, strong) UIImage  *secondPlaceHolder;
@property (nonatomic, strong) UIImage  *secondTopIcon;
@property (nonatomic, assign) BOOL     hasSecondTopIcon;

@property (nonatomic, copy  ) NSString *thirdImageUrl;
@property (nonatomic, strong) UIImage  *thirdPlaceHolder;
@property (nonatomic, strong) UIImage  *thirdTopIcon;
@property (nonatomic, assign) BOOL     hasThirdTopIcon;

@property (nonatomic, assign) NSInteger countRowIndex;//行数

@end
