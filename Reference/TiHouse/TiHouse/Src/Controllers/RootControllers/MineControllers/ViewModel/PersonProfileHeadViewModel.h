//
//  PersonProfileHeadViewModel.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/23.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewModel.h"

@interface PersonProfileHeadViewModel : BaseViewModel

@property (nonatomic, strong) UIColor *headViewBackgroundColor;
@property (nonatomic, copy  ) NSString *imageUrl;
@property (nonatomic, strong) UIImage *placeHolderImage;
@property (nonatomic, copy  ) NSString *name;

@end
