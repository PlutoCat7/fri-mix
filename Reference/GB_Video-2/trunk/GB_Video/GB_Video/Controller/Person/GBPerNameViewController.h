//
//  GBPerNameViewController.h
//  GB_TransferMarket
//
//  Created by gxd on 17/1/3.
//  Copyright © 2017年 gxd. All rights reserved.
//

#import "GBBaseViewController.h"

@interface GBPerNameViewController : GBBaseViewController

@property (nonatomic,copy) NSString* defaltName;
@property (nonatomic, assign) NSInteger minLenght;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic,copy) void(^saveBlock)(NSString* name);

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder;

@end
