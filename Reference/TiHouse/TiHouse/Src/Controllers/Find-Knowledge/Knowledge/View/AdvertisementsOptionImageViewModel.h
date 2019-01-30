//
//  AdvertisementsOptionImageViewModel.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/8.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewModel.h"

@interface AdvertisementsOptionImageViewModel : BaseViewModel

@property (nonatomic, strong  ) UIImage *placeHolderImage;
@property (nonatomic, copy    ) NSString *imageUrl;
@property (nonatomic, assign  ) BOOL     hasBoarder;
@property (nonatomic, strong  ) UIImage  *topImage;

@end
