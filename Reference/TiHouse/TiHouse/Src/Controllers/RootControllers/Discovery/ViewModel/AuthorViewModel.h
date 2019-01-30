//
//  AuthorViewModel.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewModel.h"

typedef NS_ENUM(NSInteger , AUTHORVIEWMODELTYPE) {
    AUTHORVIEWMODELTYPE_CONCERNTYPE,//关注样式
    AUTHORVIEWMODELTYPE_ADVERTISEMENTSTYPE,//广告样式
    AUTHORVIEWMODELTYPE_EDITTYPE//编辑样式
};

@interface AuthorViewModel : BaseViewModel

@property (nonatomic, copy  ) NSString *imageUrl;
@property (nonatomic, strong) UIImage  *placeHolder;
@property (nonatomic, copy  ) NSString *topTitle;
@property (nonatomic, copy  ) NSString *bottomTitle;

//关注样式
@property (nonatomic, copy  ) NSString *buttonTitle;
@property (nonatomic, strong) UIColor  *buttonBackgroundColor;
@property (nonatomic, strong) UIColor  *buttonTextColor;
@property (nonatomic, assign) BOOL     buttonCanTouch;

@property (nonatomic, assign) BOOL     hasRightButton;

//广告样式
@property (nonatomic, copy  ) NSString *advButtonTitle;
@property (nonatomic, strong) UIImage  *advButtonArrowImage;

//编辑样式
@property (nonatomic, strong) UIImage  *rightButtonImage;

@property (nonatomic, assign) AUTHORVIEWMODELTYPE type;

@end

