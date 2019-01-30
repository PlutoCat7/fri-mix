//
//  TimeDivisionSectionHeaderView.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/9.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TimeDivisionSectionHeaderView.h"

@interface TimeDivisionSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *pointImageView;


@end

@implementation TimeDivisionSectionHeaderView

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.pointImageView.layer.cornerRadius = self.pointImageView.width/2;
    self.pointImageView.clipsToBounds = YES;
}

@end
