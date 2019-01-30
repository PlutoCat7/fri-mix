//
//  ProgressView.h
//  TiHouse
//
//  Created by gaodong on 2018/2/7.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

@property (strong, nonatomic) NSString *IconName;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *Price;
@property (assign, nonatomic) NSInteger Percent;
@property (nonatomic) BOOL isPay;

- (void)updateWithTitle:(NSString *)title Price:(NSInteger)price Percent:(NSInteger)percent isPay:(BOOL)ispay;

@end
