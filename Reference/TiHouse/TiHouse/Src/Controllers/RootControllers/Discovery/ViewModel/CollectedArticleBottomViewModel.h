//
//  CollectedArticleBottomViewModel.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/24.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewModel.h"

@interface CollectedArticleBottomViewModel : BaseViewModel

@property (nonatomic, copy  ) NSString *leftImageUrl;
@property (nonatomic, strong) UIImage  *leftPlaceHolder;
@property (nonatomic, copy  ) NSString *name;
@property (nonatomic, copy  ) NSString *time;
@property (nonatomic, strong) UIImage  *rightButton;

@end
