//
//  GBSwtich.h
//  GB_TransferMarket
//
//  Created by Pizza on 2017/1/3.
//  Copyright © 2017年 gxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBSwtich : UIView
@property (nonatomic, copy) void (^action)();
@property (nonatomic, assign) BOOL on;

@property (weak, nonatomic) IBOutlet UIImageView *bgClose;
@property (weak, nonatomic) IBOutlet UIImageView *bgOpen;
@property (weak, nonatomic) IBOutlet UIImageView *ballRed;
@property (weak, nonatomic) IBOutlet UIImageView *ballGray;

@end
