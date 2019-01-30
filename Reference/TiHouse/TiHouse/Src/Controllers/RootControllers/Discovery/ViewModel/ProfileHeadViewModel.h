//
//  ProfileHeadViewModel.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/18.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewModel.h"

@interface ProfileHeadViewModel : BaseViewModel

@property (nonatomic, strong  ) UIImage *placeHolderImage;
@property (nonatomic, copy    ) NSString *imageUrl;
@property (nonatomic, copy    ) NSString *name;

@property (nonatomic, copy    ) NSString *backgroundColorImageUrl;//右下角封面url
@property (nonatomic, strong  ) UIImage  *backgroundColorImage;

@property (nonatomic, copy    ) NSString *buttonText;//按钮文案
@property (nonatomic, strong  ) UIColor  *buttonBackgroundColor;//按钮背景颜色

@property (nonatomic, strong  ) UIImage *buttonLeftImage;//中间view左边image
@property (nonatomic, copy    ) NSString *buttonRightText;//中间view右边image

@property (nonatomic, copy    ) NSString *bottomLeftAttributedTitle;
@property (nonatomic, copy    ) NSString *bottomLeftTitle;

@property (nonatomic, copy    ) NSString *bottomRightAttributedTitle;
@property (nonatomic, copy    ) NSString *bottomRightTitle;
@property (nonatomic, assign  ) BOOL     hasButton; //按钮是编辑资料view 还是关注按钮button

@property (nonatomic, strong  ) UIImage  *bottomRightImage;//右下角封面图标
@property (nonatomic, assign  ) BOOL     backgroundCanTouched;//背景是否可以点击

@end
