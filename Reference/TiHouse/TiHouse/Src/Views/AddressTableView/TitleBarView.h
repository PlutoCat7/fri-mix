//
//  TitleBarView.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/17.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleBarView : UIView

@property (nonatomic, retain) AddresManager *Addres;
@property (nonatomic, retain) UIButton *selectBtn;
@property (nonatomic, copy) void(^CloseBlock)(void);
@property (nonatomic, copy) void(^SelectBtnBlock)(NSInteger tag);

-(void)addMuneBtn:(NSInteger )item;


@end
