//
//  AdvertisementsDetailDataModel.h
//  TiHouse
//
//  Created by Teen Ma on 2018/4/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvertisementsDetailDataModel : NSObject

@property (nonatomic, copy  ) NSString *urlpicindex;
@property (nonatomic, copy  ) NSString *type;
@property (nonatomic, assign) BOOL     statusshow;
@property (nonatomic, copy  ) NSString *allurllink;
@property (nonatomic, copy  ) NSString *remaintime;
@property (nonatomic, copy  ) NSString *advertid;
@property (nonatomic, copy  ) NSString *adverttype;

@end
