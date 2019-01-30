//
//  GBSearchBar.h
//  GB_Video
//
//  Created by gxd on 2018/1/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBSearchBar : UIView

@property (nonatomic, copy) void (^actionSearch)(void);
@property (nonatomic, copy) void (^actionPerson)(void);

@end
