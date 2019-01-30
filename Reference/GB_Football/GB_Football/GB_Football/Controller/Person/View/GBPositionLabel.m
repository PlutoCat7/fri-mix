//
//  GBPositionLabel.m
//  GB_Football
//
//  Created by Pizza on 16/8/5.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBPositionLabel.h"
#import "XXNibBridge.h"


@interface GBPositionLabel()<XXNibBridge>

@property (weak, nonatomic) IBOutlet UILabel *posNameLabel;
@property (weak, nonatomic) IBOutlet UIView *colorBar;

@end

@implementation GBPositionLabel

#pragma mark - Getter and Setter

- (void)setIndex:(NSInteger)index {
    
    _index = index;
    self.posNameLabel.text = [LogicManager englishPositonWithIndex:index];
    self.colorBar.backgroundColor = [LogicManager positonColorWithIndex:index];
}

@end
