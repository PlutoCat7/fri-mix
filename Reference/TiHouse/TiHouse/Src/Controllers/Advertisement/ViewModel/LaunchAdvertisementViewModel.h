//
//  LaunchAdvertisementViewModel.h
//  YouShuLa
//
//  Created by Teen Ma on 2018/4/3.
//  Copyright © 2018年 YouShuLa_IOS. All rights reserved.
//

#import "BaseViewModel.h"

@interface LaunchAdvertisementViewModel : BaseViewModel

@property (nonatomic, assign  ) NSInteger duration; 
@property (nonatomic, assign  ) BOOL      hasDurationLabel;
@property (nonatomic, assign  ) BOOL      canTouch;
@property (nonatomic, strong  ) UIImage   *placeHolderImageView;
@property (nonatomic, copy    ) NSString  *adImageUrl;
@property (nonatomic, strong  ) UIImage   *bottomImage;

@end
