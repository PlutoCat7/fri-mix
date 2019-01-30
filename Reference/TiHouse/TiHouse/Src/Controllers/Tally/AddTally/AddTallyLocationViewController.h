//
//  AddTallyLocationViewController.h
//  TiHouse
//
//  Created by AlienJunX on 2018/2/6.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"


@class Location;

typedef void(^SelectedCompletionBlock)(Location *location);

@interface AddTallyLocationViewController : BaseViewController
@property (copy, nonatomic) SelectedCompletionBlock block;

@end
