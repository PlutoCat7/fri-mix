//
//  AddressViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/17.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddresManager;
@interface AddressViewController : UIViewController

@property (nonatomic, copy) void(^finishAddres)(AddresManager *addres);
@property (nonatomic, retain) AddresManager *addres;

-(void)hiddenContent;
-(void)showContent;

@end
